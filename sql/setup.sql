-- ============================================================
-- Manipal Eats — SQL Setup Script
-- Run this once after importing the original dump.
-- ============================================================

USE restaurant_db;

-- ============================================================
-- STEP 1: REMOVE role COLUMN FROM users
-- ============================================================
ALTER TABLE users DROP COLUMN IF EXISTS role;


-- ============================================================
-- STEP 2: DROP UNNECESSARY TRIGGERS
-- ============================================================

-- DROP: after_review_insert_log
-- Reason: causes double-logging. Backend logs actions itself.
DROP TRIGGER IF EXISTS after_review_insert_log;

-- DROP: after_user_signup (optional — backend logs signup too)
-- Keep if you want DB-level audit. We drop it to avoid duplicates.
DROP TRIGGER IF EXISTS after_user_signup;


-- ============================================================
-- STEP 3: KEEP + RECREATE ESSENTIAL TRIGGERS
-- ============================================================

DROP TRIGGER IF EXISTS after_review_insert;
DROP TRIGGER IF EXISTS after_review_update;
DROP TRIGGER IF EXISTS after_review_delete;

DELIMITER ;;

-- Recalculate avg_rating after any review insert
CREATE TRIGGER after_review_insert
AFTER INSERT ON reviews FOR EACH ROW
BEGIN
  UPDATE restaurants
  SET avg_rating = (
    SELECT ROUND(AVG(rating), 2)
    FROM reviews
    WHERE restaurant_id = NEW.restaurant_id
      AND status = 'approved'
  )
  WHERE restaurant_id = NEW.restaurant_id;
END;;

-- Recalculate avg_rating after any review update
CREATE TRIGGER after_review_update
AFTER UPDATE ON reviews FOR EACH ROW
BEGIN
  UPDATE restaurants
  SET avg_rating = (
    SELECT ROUND(AVG(rating), 2)
    FROM reviews
    WHERE restaurant_id = NEW.restaurant_id
      AND status = 'approved'
  )
  WHERE restaurant_id = NEW.restaurant_id;
END;;

-- Recalculate avg_rating after any review delete
CREATE TRIGGER after_review_delete
AFTER DELETE ON reviews FOR EACH ROW
BEGIN
  UPDATE restaurants
  SET avg_rating = COALESCE(
    (
      SELECT ROUND(AVG(rating), 2)
      FROM reviews
      WHERE restaurant_id = OLD.restaurant_id
        AND status = 'approved'
    ), 0.00
  )
  WHERE restaurant_id = OLD.restaurant_id;
END;;

DELIMITER ;


-- ============================================================
-- STEP 4: DROP + RECREATE STORED PROCEDURES
-- ============================================================

DROP PROCEDURE IF EXISTS AddReview;
DROP PROCEDURE IF EXISTS UpdateReview;
DROP PROCEDURE IF EXISTS DeleteReview;
DROP PROCEDURE IF EXISTS GetTopRestaurants;
DROP PROCEDURE IF EXISTS GetCuisineBreakdown;
DROP PROCEDURE IF EXISTS GetAreaBreakdown;
DROP FUNCTION  IF EXISTS GetRatingLabel;

DELIMITER ;;

-- AddReview: inserts a review (trigger auto-updates avg_rating)
CREATE PROCEDURE AddReview(
  IN p_restaurant_id INT,
  IN p_user_id       INT,
  IN p_rating        DECIMAL(2,1),
  IN p_title         VARCHAR(255),
  IN p_body          TEXT
)
BEGIN
  INSERT INTO reviews (restaurant_id, user_id, rating, title, body, created_at)
  VALUES (p_restaurant_id, p_user_id, p_rating, p_title, p_body, NOW());
END;;

-- UpdateReview: only updates if the calling user owns the review
CREATE PROCEDURE UpdateReview(
  IN p_review_id INT,
  IN p_user_id   INT,
  IN p_rating    DECIMAL(2,1),
  IN p_title     VARCHAR(255),
  IN p_body      TEXT
)
BEGIN
  UPDATE reviews
  SET rating = p_rating,
      title  = p_title,
      body   = p_body
  WHERE review_id = p_review_id
    AND user_id   = p_user_id;

  IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Review not found or you do not own it';
  END IF;
END;;

-- DeleteReview: only deletes if the calling user owns the review
CREATE PROCEDURE DeleteReview(
  IN p_review_id INT,
  IN p_user_id   INT
)
BEGIN
  DELETE FROM reviews
  WHERE review_id = p_review_id
    AND user_id   = p_user_id;

  IF ROW_COUNT() = 0 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Review not found or you do not own it';
  END IF;
END;;

-- GetTopRestaurants: top N restaurants by avg_rating
-- GetRatingLabel replaced with inline CASE (no extra function call)
CREATE PROCEDURE GetTopRestaurants(IN p_limit INT)
BEGIN
  SELECT
    r.restaurant_id,
    r.name,
    r.avg_rating,
    CASE
      WHEN r.avg_rating >= 4.5 THEN 'Excellent'
      WHEN r.avg_rating >= 4.0 THEN 'Very Good'
      WHEN r.avg_rating >= 3.5 THEN 'Good'
      WHEN r.avg_rating >= 3.0 THEN 'Average'
      ELSE 'Below Average'
    END AS rating_label,
    c.cuisine_name AS cuisine_type,
    COUNT(rv.review_id) AS total_reviews
  FROM restaurants r
  LEFT JOIN restaurant_cuisines rc
         ON rc.restaurant_id = r.restaurant_id AND rc.is_primary = 1
  LEFT JOIN cuisines c ON rc.cuisine_id = c.cuisine_id
  LEFT JOIN reviews rv ON rv.restaurant_id = r.restaurant_id
  WHERE r.is_active = 1
  GROUP BY r.restaurant_id, r.name, r.avg_rating, c.cuisine_name
  ORDER BY r.avg_rating DESC
  LIMIT p_limit;
END;;


-- ============================================================
-- CURSOR 1: GetCuisineBreakdown
-- Use case: analytics/admin panel — shows how many restaurants
-- exist per cuisine and their average rating.
-- ============================================================
CREATE PROCEDURE GetCuisineBreakdown()
BEGIN
  DECLARE done           INT DEFAULT FALSE;
  DECLARE v_cuisine_id   INT;
  DECLARE v_cuisine_name VARCHAR(100);

  DECLARE cur CURSOR FOR
    SELECT cuisine_id, cuisine_name FROM cuisines ORDER BY cuisine_name;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  DROP TEMPORARY TABLE IF EXISTS tmp_cuisine_breakdown;
  CREATE TEMPORARY TABLE tmp_cuisine_breakdown (
    cuisine_name     VARCHAR(100),
    restaurant_count INT,
    avg_rating       DECIMAL(3,2)
  );

  OPEN cur;
  read_loop: LOOP
    FETCH cur INTO v_cuisine_id, v_cuisine_name;
    IF done THEN LEAVE read_loop; END IF;

    INSERT INTO tmp_cuisine_breakdown
    SELECT
      v_cuisine_name,
      COUNT(DISTINCT r.restaurant_id),
      ROUND(COALESCE(AVG(rv.rating), 0), 2)
    FROM restaurants r
    JOIN restaurant_cuisines rc
      ON rc.restaurant_id = r.restaurant_id
     AND rc.cuisine_id    = v_cuisine_id
    LEFT JOIN reviews rv ON rv.restaurant_id = r.restaurant_id
    WHERE r.is_active = 1;

  END LOOP;
  CLOSE cur;

  SELECT * FROM tmp_cuisine_breakdown
  WHERE restaurant_count > 0
  ORDER BY avg_rating DESC;

  DROP TEMPORARY TABLE IF EXISTS tmp_cuisine_breakdown;
END;;


-- ============================================================
-- CURSOR 2: GetPersonalizedRecommendations
-- Use case: "For You" section on homepage — finds restaurants
-- the user has NOT reviewed, in cuisines they rated >= 4.0,
-- ranked by match score + avg_rating.
-- ============================================================
CREATE PROCEDURE GetPersonalizedRecommendations(IN p_user_id INT)
BEGIN
  DECLARE done         INT DEFAULT FALSE;
  DECLARE v_cuisine_id INT;

  DECLARE cur CURSOR FOR
    SELECT DISTINCT rc.cuisine_id
    FROM reviews r
    JOIN restaurant_cuisines rc ON rc.restaurant_id = r.restaurant_id
    WHERE r.user_id = p_user_id AND r.rating >= 4.0;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  DROP TEMPORARY TABLE IF EXISTS tmp_recommendations;
  CREATE TEMPORARY TABLE tmp_recommendations (
    restaurant_id INT,
    name          VARCHAR(200),
    avg_rating    DECIMAL(3,2),
    cuisine_name  VARCHAR(100),
    price_range   VARCHAR(20),
    match_score   INT DEFAULT 0,
    PRIMARY KEY (restaurant_id)
  );

  OPEN cur;
  rec_loop: LOOP
    FETCH cur INTO v_cuisine_id;
    IF done THEN LEAVE rec_loop; END IF;

    INSERT INTO tmp_recommendations
      (restaurant_id, name, avg_rating, cuisine_name, price_range, match_score)
    SELECT
      r.restaurant_id, r.name, r.avg_rating,
      c.cuisine_name, r.price_range, 1
    FROM restaurants r
    JOIN restaurant_cuisines rc
      ON rc.restaurant_id = r.restaurant_id AND rc.cuisine_id = v_cuisine_id
    JOIN cuisines c ON c.cuisine_id = v_cuisine_id
    WHERE r.is_active = 1
      AND r.restaurant_id NOT IN (
        SELECT restaurant_id FROM reviews WHERE user_id = p_user_id
      )
    ON DUPLICATE KEY UPDATE
      match_score = tmp_recommendations.match_score + 1;

  END LOOP;
  CLOSE cur;

  SELECT * FROM tmp_recommendations
  ORDER BY match_score DESC, avg_rating DESC
  LIMIT 5;

  DROP TEMPORARY TABLE IF EXISTS tmp_recommendations;
END;;

DELIMITER ;


-- ============================================================
-- STEP 5: ADDITIONAL INDEX for fast user-review lookups
-- ============================================================
ALTER TABLE reviews
  ADD INDEX IF NOT EXISTS idx_reviews_user (user_id, created_at DESC);
