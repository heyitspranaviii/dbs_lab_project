const express         = require('express');
const pool            = require('../db/pool');
const { verifyToken } = require('../db/auth');

const router = express.Router();

/* ═══════════════════════════════════════════════════════════
   ALL static/meta routes MUST come before /:id
   ═══════════════════════════════════════════════════════════ */

/* ─── Cuisines dropdown ───────────────────────────────────── */
router.get('/meta/cuisines', async (_req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT cuisine_id, cuisine_name FROM cuisines ORDER BY cuisine_name`
    );
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
});

/* ─── Cuisine breakdown (calls GetCuisineBreakdown cursor SP) */
router.get('/meta/cuisine-breakdown', async (_req, res) => {
  try {
    const [results] = await pool.query(`CALL GetCuisineBreakdown()`);
    res.json(results[0] || []);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
});

/* ─── Personalised recommendations (calls cursor SP) ────────
   Finds restaurants the user has NOT reviewed, in cuisines
   they previously rated >= 4.0, ranked by match_score then
   avg_rating.  Returns [] if user has no qualifying reviews. */
router.get('/recommendations/foryou', verifyToken, async (req, res) => {
  const userId = req.user.userId;
  try {
    const [results] = await pool.query(
      `CALL GetPersonalizedRecommendations(?)`, [userId]
    );
    res.json(results[0] || []);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
});

/* ─── LIST / SEARCH / FILTER ──────────────────────────────── */
router.get('/', async (req, res) => {
  const { cuisine, price, min_rating, search } = req.query;

  let sql = `
    SELECT
      r.restaurant_id,
      r.name,
      r.description,
      r.avg_rating,
      r.price_range,
      r.latitude,
      r.longitude,
      MAX(a.area_name) AS area_name,
      COUNT(DISTINCT rv.review_id) AS review_count,
      GROUP_CONCAT(DISTINCT c.cuisine_name ORDER BY rc.is_primary DESC SEPARATOR ', ') AS all_cuisines,
      MAX(CASE WHEN rc.is_primary = 1 THEN c.cuisine_name END) AS primary_cuisine
    FROM restaurants r
    LEFT JOIN areas a ON a.area_id = r.area_id
    LEFT JOIN restaurant_cuisines rc ON rc.restaurant_id = r.restaurant_id
    LEFT JOIN cuisines c ON c.cuisine_id = rc.cuisine_id
    LEFT JOIN reviews rv
           ON rv.restaurant_id = r.restaurant_id AND rv.status = 'approved'
    WHERE r.is_active = 1
  `;

  const params = [];

  if (cuisine) {
    /* Match any cuisine tag (primary OR secondary) so filtering by
       e.g. Chinese shows restaurants where Chinese is a secondary cuisine */
    sql += ` AND r.restaurant_id IN (
      SELECT restaurant_id FROM restaurant_cuisines WHERE cuisine_id = ?
    )`;
    params.push(Number(cuisine));
  }
  if (price) {
    sql += ' AND r.price_range = ?';
    params.push(price);
  }
  if (min_rating) {
    sql += ' AND r.avg_rating >= ?';
    params.push(Number(min_rating));
  }
  if (search) {
    sql += ' AND (r.name LIKE ? OR r.description LIKE ?)';
    params.push('%' + search + '%', '%' + search + '%');
  }

  sql += ` GROUP BY r.restaurant_id, r.name, r.description,
                    r.avg_rating, r.price_range, r.latitude, r.longitude
           ORDER BY r.avg_rating DESC`;

  try {
    const [rows] = await pool.query(sql, params);
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
});

/* ═══════════════════════════════════════════════════════════
   Dynamic /:id routes MUST come AFTER all static routes
   ═══════════════════════════════════════════════════════════ */

/* ─── SINGLE RESTAURANT DETAIL ────────────────────────────── */
router.get('/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const [[restaurant]] = await pool.query(
      `SELECT r.*, a.area_name
       FROM restaurants r
       LEFT JOIN areas a ON a.area_id = r.area_id
       WHERE r.restaurant_id = ? AND r.is_active = 1`,
      [id]
    );
    if (!restaurant) return res.status(404).json({ error: 'Restaurant not found' });

    const [cuisines] = await pool.query(
      `SELECT c.cuisine_id, c.cuisine_name, rc.is_primary
       FROM restaurant_cuisines rc
       JOIN cuisines c ON c.cuisine_id = rc.cuisine_id
       WHERE rc.restaurant_id = ?
       ORDER BY rc.is_primary DESC`,
      [id]
    );

    restaurant.cuisines = cuisines;
    res.json(restaurant);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
});

/* ─── MENU FOR A RESTAURANT ───────────────────────────────── */
router.get('/:id/menu', async (req, res) => {
  const { id } = req.params;
  try {
    const [categories] = await pool.query(
      `SELECT menu_cat_id, category_name, display_order
       FROM menu_categories WHERE restaurant_id = ?
       ORDER BY display_order`,
      [id]
    );
    const [items] = await pool.query(
      `SELECT item_id, menu_cat_id, item_name, description,
              price, is_vegetarian, is_available, spice_level
       FROM menu_items WHERE restaurant_id = ? AND is_available = 1
       ORDER BY menu_cat_id, item_name`,
      [id]
    );
    const menu = categories.map(cat => ({
      ...cat,
      items: items.filter(i => i.menu_cat_id === cat.menu_cat_id)
    }));
    res.json(menu);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;
