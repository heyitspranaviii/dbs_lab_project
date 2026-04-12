const express  = require('express');
const bcrypt   = require('bcryptjs');
const jwt      = require('jsonwebtoken');
const pool     = require('../db/pool');
const { JWT_SECRET } = require('../db/auth');

const router      = express.Router();
const SALT_ROUNDS = 10;

/* ─── SIGN UP ─────────────────────────────────────────── */
router.post('/signup', async (req, res) => {
  const { username, email, password, full_name, security_question, security_answer } = req.body;

  if (!username || !email || !password)
    return res.status(400).json({ error: 'username, email and password are required' });

  if (password.length < 6)
    return res.status(400).json({ error: 'Password must be at least 6 characters' });

  if (username.length < 3)
    return res.status(400).json({ error: 'Username must be at least 3 characters' });

  try {
    const hash       = await bcrypt.hash(password, SALT_ROUNDS);
    const answerHash = security_answer
      ? await bcrypt.hash(security_answer.toLowerCase().trim(), SALT_ROUNDS)
      : null;

    const [result] = await pool.query(
      `INSERT INTO users (username, email, password_hash, security_question, security_answer)
       VALUES (?, ?, ?, ?, ?)`,
      [username.trim(), email.trim().toLowerCase(), hash,
       security_question || null, answerHash]
    );

    const userId = result.insertId;

    await pool.query(
      `INSERT INTO user_profiles (user_id, full_name) VALUES (?, ?)
       ON DUPLICATE KEY UPDATE full_name = VALUES(full_name)`,
      [userId, full_name || username]
    );

    await pool.query(
      `INSERT INTO user_activity_log (user_id, action) VALUES (?, 'signup')`,
      [userId]
    );

    const token = jwt.sign({ userId, username: username.trim() }, JWT_SECRET, { expiresIn: '7d' });
    res.status(201).json({ token, userId, username: username.trim() });
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') {
      const field = err.message.includes('username') ? 'Username' : 'Email';
      return res.status(409).json({ error: field + ' already exists' });
    }
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
});

/* ─── LOGIN ───────────────────────────────────────────── */
router.post('/login', async (req, res) => {
  const { login, password } = req.body;
  if (!login || !password)
    return res.status(400).json({ error: 'login and password are required' });

  try {
    const [rows] = await pool.query(
      `SELECT user_id, username, email, password_hash, is_active
       FROM users WHERE (email = ? OR username = ?) AND is_active = 1 LIMIT 1`,
      [login.trim().toLowerCase(), login.trim()]
    );

    if (!rows.length)
      return res.status(401).json({ error: 'Invalid email/username or password' });

    const user = rows[0];

    /* Support both bcrypt hashes and plain-text passwords (legacy data) */
    let match = false;
    if (user.password_hash.startsWith('$2')) {
      match = await bcrypt.compare(password, user.password_hash);
    } else {
      /* plain text legacy — compare directly, then upgrade hash */
      match = (password === user.password_hash);
      if (match) {
        const newHash = await bcrypt.hash(password, SALT_ROUNDS);
        await pool.query(`UPDATE users SET password_hash = ? WHERE user_id = ?`,
          [newHash, user.user_id]);
      }
    }

    if (!match)
      return res.status(401).json({ error: 'Invalid email/username or password' });

    const token = jwt.sign(
      { userId: user.user_id, username: user.username },
      JWT_SECRET,
      { expiresIn: '7d' }
    );
    res.json({ token, userId: user.user_id, username: user.username });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
});

/* ─── GET SECURITY QUESTION ───────────────────────────── */
router.post('/security-question', async (req, res) => {
  const { email } = req.body;
  if (!email) return res.status(400).json({ error: 'email is required' });

  try {
    const [rows] = await pool.query(
      `SELECT security_question FROM users WHERE email = ? AND is_active = 1 LIMIT 1`,
      [email.trim().toLowerCase()]
    );
    if (!rows.length)
      return res.status(404).json({ error: 'No account found with that email' });
    if (!rows[0].security_question)
      return res.status(404).json({ error: 'No security question set for this account' });

    res.json({ question: rows[0].security_question });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
});

/* ─── RESET PASSWORD ──────────────────────────────────── */
router.post('/reset-password', async (req, res) => {
  const { email, answer, new_password } = req.body;
  if (!email || !answer || !new_password)
    return res.status(400).json({ error: 'email, answer and new_password are required' });
  if (new_password.length < 6)
    return res.status(400).json({ error: 'Password must be at least 6 characters' });

  try {
    const [rows] = await pool.query(
      `SELECT user_id, security_answer FROM users WHERE email = ? AND is_active = 1 LIMIT 1`,
      [email.trim().toLowerCase()]
    );
    if (!rows.length)
      return res.status(404).json({ error: 'No account found with that email' });

    const user = rows[0];
    if (!user.security_answer)
      return res.status(400).json({ error: 'No security answer on file for this account' });

    /* Support both hashed and plain-text legacy answers */
    let match = false;
    if (user.security_answer.startsWith('$2')) {
      match = await bcrypt.compare(answer.toLowerCase().trim(), user.security_answer);
    } else {
      match = (answer.toLowerCase().trim() === user.security_answer.toLowerCase().trim());
    }

    if (!match)
      return res.status(401).json({ error: 'Incorrect answer. Please try again.' });

    const newHash = await bcrypt.hash(new_password, SALT_ROUNDS);
    await pool.query(`UPDATE users SET password_hash = ? WHERE user_id = ?`,
      [newHash, user.user_id]);

    res.json({ message: 'Password reset successful' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;
