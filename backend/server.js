require('dotenv').config();
const express      = require('express');
const cors         = require('cors');
const path         = require('path');
const cookieParser = require('cookie-parser');

const authRoutes        = require('./routes/auth');
const restaurantRoutes  = require('./routes/restaurants');
const reviewRoutes      = require('./routes/reviews');
const userRoutes        = require('./routes/users');

const app  = express();
const PORT = process.env.PORT || 3000;

/* ── Middleware ── */
app.use(cors());
app.use(express.json());
app.use(cookieParser());
app.use(express.static(path.join(__dirname, '../frontend')));

/* ── API Routes ── */
app.use('/api/auth',        authRoutes);
app.use('/api/restaurants', restaurantRoutes);
app.use('/api/reviews',     reviewRoutes);
app.use('/api/users',       userRoutes);

/* ── Serve HTML pages ── */
app.get('/',           (_req, res) => res.sendFile(path.join(__dirname, '../frontend', 'index.html')));
app.get('/login',      (_req, res) => res.sendFile(path.join(__dirname, '../frontend', 'pages', 'login.html')));
app.get('/signup',     (_req, res) => res.sendFile(path.join(__dirname, '../frontend', 'pages', 'signup.html')));
app.get('/forgot',     (_req, res) => res.sendFile(path.join(__dirname, '../frontend', 'pages', 'forgot.html')));
app.get('/restaurant', (_req, res) => res.sendFile(path.join(__dirname, '../frontend', 'pages', 'restaurant.html')));
app.get('/profile',    (_req, res) => res.sendFile(path.join(__dirname, '../frontend', 'pages', 'profile.html')));

/* ── 404 ── */
app.use((_req, res) => res.status(404).json({ error: 'Route not found' }));

app.listen(PORT, () => {
  console.log(`\n  Manipal Eats running at http://localhost:${PORT}\n`);
});
