const express         = require('express');
const pool            = require('../db/pool');
const { verifyToken } = require('../db/auth');

const router = express.Router();

/* ── Helper: recalculate and return exact avg_rating ── */
async function getExactAvg(restaurantId) {
  const [[row]] = await pool.query(
    `SELECT ROUND(AVG(rating), 2) AS avg_rating
     FROM reviews
     WHERE restaurant_id = ? AND status = 'approved'`,
    [restaurantId]
  );
  const avg = row.avg_rating ? parseFloat(row.avg_rating) : 0;

  /* Also update restaurants table so listing page stays in sync */
  await pool.query(
    `UPDATE restaurants SET avg_rating = ? WHERE restaurant_id = ?`,
    [avg, restaurantId]
  );
  return avg;
}

/* ─── GET REVIEWS FOR A RESTAURANT ───────────────────── */
router.get('/restaurant/:restaurantId', async (req, res) => {
  const { restaurantId } = req.params;
  try {
    const [rows] = await pool.query(
      `SELECT rv.review_id, rv.user_id, rv.rating, rv.title, rv.body,
              rv.visit_date, rv.created_at,
              u.username, up.full_name
       FROM reviews rv
       JOIN users u ON u.user_id = rv.user_id
       LEFT JOIN user_profiles up ON up.user_id = rv.user_id
       WHERE rv.restaurant_id = ? AND rv.status = 'approved'
       ORDER BY rv.created_at DESC`,
      [restaurantId]
    );
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
});

/* ─── ADD REVIEW ──────────────────────────────────────── */
router.post('/', verifyToken, async (req, res) => {
  const { restaurant_id, rating, title, body } = req.body;
  const userId = req.user.userId;

  if (!restaurant_id || rating === undefined)
    return res.status(400).json({ error: 'restaurant_id and rating are required' });

  const r = parseFloat(rating);
  if (isNaN(r) || r < 1 || r > 5)
    return res.status(400).json({ error: 'Rating must be between 1.0 and 5.0' });

  try {
    await pool.query(
      `INSERT INTO reviews (restaurant_id, user_id, rating, title, body, created_at)
       VALUES (?, ?, ?, ?, ?, NOW())`,
      [restaurant_id, userId, r.toFixed(1), title || null, body || null]
    );

    await pool.query(
      `INSERT INTO user_activity_log (user_id, action) VALUES (?, 'review_added')`,
      [userId]
    );

    const avg = await getExactAvg(restaurant_id);
    res.status(201).json({ message: 'Review added', avg_rating: avg });
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY')
      return res.status(409).json({ error: 'You have already reviewed this restaurant' });
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
});

/* ─── UPDATE REVIEW ───────────────────────────────────── */
router.put('/:reviewId', verifyToken, async (req, res) => {
  const { reviewId } = req.params;
  const { rating, title, body } = req.body;
  const userId = req.user.userId;

  if (rating === undefined)
    return res.status(400).json({ error: 'rating is required' });

  const r = parseFloat(rating);
  if (isNaN(r) || r < 1 || r > 5)
    return res.status(400).json({ error: 'Rating must be between 1.0 and 5.0' });

  try {
    const [[existing]] = await pool.query(
      `SELECT restaurant_id FROM reviews WHERE review_id = ? AND user_id = ?`,
      [reviewId, userId]
    );
    if (!existing)
      return res.status(403).json({ error: 'Review not found or you do not own it' });

    await pool.query(
      `UPDATE reviews SET rating = ?, title = ?, body = ? WHERE review_id = ? AND user_id = ?`,
      [r.toFixed(1), title || null, body || null, reviewId, userId]
    );

    const avg = await getExactAvg(existing.restaurant_id);
    res.json({ message: 'Review updated', avg_rating: avg });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message || 'Server error' });
  }
});

/* ─── DELETE REVIEW ───────────────────────────────────── */
router.delete('/:reviewId', verifyToken, async (req, res) => {
  const { reviewId } = req.params;
  const userId = req.user.userId;

  try {
    const [[existing]] = await pool.query(
      `SELECT restaurant_id FROM reviews WHERE review_id = ? AND user_id = ?`,
      [reviewId, userId]
    );
    if (!existing)
      return res.status(403).json({ error: 'Review not found or you do not own it' });

    await pool.query(
      `DELETE FROM reviews WHERE review_id = ? AND user_id = ?`,
      [reviewId, userId]
    );

    const avg = await getExactAvg(existing.restaurant_id);
    res.json({ message: 'Review deleted', avg_rating: avg });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message || 'Server error' });
  }
});

module.exports = router;
