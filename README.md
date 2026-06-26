# Manipal Eats — Restaurant Recommendation System

A full-stack web application for discovering restaurants in Manipal, Karnataka.
Browse restaurants on an interactive map, filter by cuisine, price, and rating,
read and write reviews, and get personalised recommendations — all powered by a
MySQL 9.5 database with stored procedures, triggers, and cursors.

Built for **Database Systems Lab (CSS 2212)** — Manipal Institute of Technology, April 2026.

---

## Features

- Interactive Leaflet.js map with named restaurant markers using real GPS coordinates
- Each restaurant card shows all cuisines (primary and secondary) via GROUP_CONCAT
- Filter by cuisine, price range, and minimum rating
- Debounced live search by restaurant name or description
- Decimal ratings from 1.0 to 5.0 in steps of 0.1
- Real-time avg_rating update after every review add, edit, or delete
- Recommended For You section powered by the GetPersonalizedRecommendations cursor SP
- Cuisines in Manipal dropdown powered by the GetCuisineBreakdown cursor SP
- JWT authentication with bcryptjs password hashing (salt rounds = 10)
- Legacy plain-text passwords auto-upgraded to bcrypt on first login
- Security question-based password recovery
- User profile with review history and edit modal
- Categorised menus with veg/non-veg indicators and spice level tags

---

## Tech Stack

| Layer | Technology |
|---|---|
| Backend | Node.js 20 + Express.js |
| Database | MySQL 9.5 Community Server |
| Frontend | HTML5, CSS3, Vanilla JavaScript |
| Map | Leaflet.js + OpenStreetMap (no API key needed) |
| Authentication | JWT (jsonwebtoken) + bcryptjs |
| DB Driver | mysql2 (promise API, connection pool) |
| Java Connectivity | JDBC with MySQL Connector/J 9.6.0 |

---

## Project Structure

```
dbs_lab_project/
│
├── backend/
│   ├── db/
│   │   ├── pool.js              # MySQL connection pool
│   │   └── auth.js              # JWT verifyToken middleware
│   ├── routes/
│   │   ├── auth.js              # /api/auth/*
│   │   ├── restaurants.js       # /api/restaurants/*
│   │   ├── reviews.js           # /api/reviews/*
│   │   └── users.js             # /api/users/*
│   ├── server.js                # Express entry point
│   ├── package.json
│   └── .env                     # NOT pushed to GitHub
│
├── frontend/
│   ├── css/
│   │   └── style.css
│   ├── js/
│   │   └── utils.js
│   ├── pages/
│   │   ├── login.html
│   │   ├── signup.html
│   │   ├── forgot.html
│   │   ├── restaurant.html
│   │   └── profile.html
│   └── index.html
│
├── sql/
│   ├── setup.sql                # Run once after importing the dump
├── .gitignore
└── README.md
```

---

## Prerequisites

- [Node.js 20+](https://nodejs.org/)
- [MySQL 9.5 Community Server](https://dev.mysql.com/downloads/mysql/)


---

## Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/heyitspranaviii/manipal-eats.git
cd dbs_lab_project
```

### 2. Import the database dump

Open MySQL Command Line Client and run:

```sql
source C:/path/to/full_dump1.sql
```

### 3. Run setup.sql

```sql
use restaurant_db;
source C:/path/to/manipal-eats/sql/setup.sql
```

### 4. Create the .env file

Inside the `backend/` folder, create a file named `.env`:

```
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_mysql_root_password
DB_NAME=restaurant_db
JWT_SECRET=any_long_random_string_here
PORT=3000
```

> This file is listed in .gitignore and will never be pushed to GitHub.

### 5. Install dependencies

```bash
cd backend
npm install
```

### 6. Start the server

```bash
npm start
```

Expected output:

```
Manipal Eats running at http://localhost:3000
```

### 7. Open in browser

```
http://localhost:3000
```

---

## API Endpoints

> Note: Static routes (/meta/cuisines, /meta/cuisine-breakdown, /recommendations/foryou)
> are defined before /:id in restaurants.js to prevent Express route conflicts.

### Auth

| Method | Endpoint | Description |
|---|---|---|
| POST | /api/auth/signup | Register new user, stores bcrypt hash |
| POST | /api/auth/login | Login with bcrypt verify and legacy auto-upgrade |
| POST | /api/auth/security-question | Fetch security question by email |
| POST | /api/auth/reset-password | Verify answer and update password hash |

### Restaurants

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| GET | /api/restaurants | No | All restaurants, supports ?cuisine= ?price= ?min_rating= ?search= |
| GET | /api/restaurants/meta/cuisines | No | Cuisine list for filter dropdown |
| GET | /api/restaurants/meta/cuisine-breakdown | No | Calls GetCuisineBreakdown() cursor SP |
| GET | /api/restaurants/recommendations/foryou | JWT | Calls GetPersonalizedRecommendations() cursor SP |
| GET | /api/restaurants/:id | No | Single restaurant with all cuisine tags |
| GET | /api/restaurants/:id/menu | No | Menu categories and items grouped |

### Reviews

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| GET | /api/reviews/restaurant/:id | No | All approved reviews for a restaurant |
| POST | /api/reviews | JWT | Add review, direct INSERT and getExactAvg() |
| PUT | /api/reviews/:id | JWT | Edit own review with ownership check |
| DELETE | /api/reviews/:id | JWT | Delete own review with ownership check |

### Users

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| GET | /api/users/me | JWT | Profile and total review count |
| PUT | /api/users/me | JWT | Update full_name, phone, gender |
| GET | /api/users/me/reviews | JWT | All reviews by logged-in user |

---

## Database Features

### Tables

The database has 30 tables normalised to 3NF. The Node.js backend queries only these 11 core tables:

users, user_profiles, restaurants, cuisines, restaurant_cuisines, menu_categories, menu_items, reviews, areas, cities, user_activity_log

### Triggers

| Trigger | Fires on | What it does |
|---|---|---|
| after_review_insert | INSERT on reviews | Recalculates avg_rating |
| after_review_update | UPDATE on reviews | Same recalculation |
| after_review_delete | DELETE on reviews | Same recalculation with COALESCE fallback to 0.00 |

### Stored Procedures

**AddReview** — Inserts a new review. The after_review_insert trigger fires automatically.
**UpdateReview** — Updates a review only if the requesting user owns it. Raises SIGNAL SQLSTATE '45000' if not found or not owned.
**DeleteReview** — Deletes a review only if the requesting user owns it. Raises SIGNAL SQLSTATE '45000' if not found or not owned.

### Cursor-Based Stored Procedures

**GetCuisineBreakdown** — Powers the Cuisines in Manipal dropdown on the homepage.
Uses a cursor to iterate over every cuisine, compute restaurant count and average rating for each, and return results sorted by avg_rating DESC.

API endpoint: GET /api/restaurants/meta/cuisine-breakdown

**GetPersonalizedRecommendations** — Powers the Recommended For You section on the homepage.
Uses a cursor to iterate over cuisines the user has rated 3.5 or above. For each cuisine, finds restaurants the user has not yet reviewed and accumulates a match_score. Results are ranked by match_score DESC then avg_rating DESC, limited to 5.

API endpoint: GET /api/restaurants/recommendations/foryou (requires JWT)

### Scalar Function

**GetRatingLabel** — Converts a numeric avg_rating to a descriptive string. Used in Java JDBC queries and available for direct MySQL queries.

## Authentication Flow

1. **Signup** — Password hashed with bcryptjs (salt rounds = 10) before storing in the database.
2. **Login** — If stored hash starts with $2 it uses bcrypt.compare(). If it is a legacy plain-text password it does a direct compare then auto-upgrades to bcrypt on the same request.
3. **JWT** — A 7-day token is issued on login, stored in localStorage, and sent as Authorization: Bearer token on every protected request.

---

