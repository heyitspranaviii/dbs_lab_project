const jwt = require('jsonwebtoken');
const JWT_SECRET = process.env.JWT_SECRET || 'manipal_eats_secret_2024';

function verifyToken(req, res, next) {
  const auth = req.headers['authorization'];
  const token = auth && auth.startsWith('Bearer ') ? auth.slice(7) : null;

  if (!token) return res.status(401).json({ error: 'No token provided' });

  try {
    req.user = jwt.verify(token, JWT_SECRET);
    next();
  } catch {
    res.status(401).json({ error: 'Invalid or expired token' });
  }
}

module.exports = { verifyToken, JWT_SECRET };
