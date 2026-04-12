const express      = require('express');
const pool         = require('../db/pool');
const { verifyToken } = require('../db/auth');

const router = express.Router();

/* ─── GET MY PROFILE ──────────────────────────────────── */
router.get('/me', verifyToken, async (req, res) => {
  const userId = req.user.userId;
  try {
    const [[user]] = await pool.query(
      `SELECT u.user_id, u.username, u.email, u.created_at,
              up.full_name, up.avatar_url, up.gender, up.phone
       FROM users u
       LEFT JOIN user_profiles up ON up.user_id = u.user_id
       WHERE u.user_id = ? AND u.is_active = 1`,
      [userId]
    );
    if (!user) return res.status(404).json({ error: 'User not found' });

    // review count
    const [[{ total }]] = await pool.query(
      `SELECT COUNT(*) AS total FROM reviews WHERE user_id = ?`,
      [userId]
    );
    user.total_reviews = total;

    res.json(user);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
});

/* ─── UPDATE MY PROFILE ───────────────────────────────── */
router.put('/me', verifyToken, async (req, res) => {
  const userId = req.user.userId;
  const { full_name, phone, gender } = req.body;

  try {
    await pool.query(
      `UPDATE user_profiles
       SET full_name = COALESCE(?, full_name),
           phone     = COALESCE(?, phone),
           gender    = COALESCE(?, gender)
       WHERE user_id = ?`,
      [full_name || null, phone || null, gender || null, userId]
    );
    res.json({ message: 'Profile updated' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
});

/* ─── GET MY REVIEWS ──────────────────────────────────── */
router.get('/me/reviews', verifyToken, async (req, res) => {
  const userId = req.user.userId;
  try {
    const [rows] = await pool.query(
      `SELECT rv.review_id, rv.rating, rv.title, rv.body,
              rv.visit_date, rv.created_at,
              r.restaurant_id, r.name AS restaurant_name,
              r.avg_rating AS restaurant_avg_rating
       FROM reviews rv
       JOIN restaurants r ON r.restaurant_id = rv.restaurant_id
       WHERE rv.user_id = ?
       ORDER BY rv.created_at DESC`,
      [userId]
    );
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;
