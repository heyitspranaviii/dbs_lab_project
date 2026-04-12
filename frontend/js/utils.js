/* ── API base helper ── */
var API = {
  base: '/api',

  headers: function() {
    var h = { 'Content-Type': 'application/json' };
    var token = localStorage.getItem('token');
    if (token) h['Authorization'] = 'Bearer ' + token;
    return h;
  },

  get: async function(path) {
    var r = await fetch(this.base + path, { headers: this.headers() });
    var data = await r.json();
    if (!r.ok) throw new Error(data.error || 'Request failed');
    return data;
  },

  post: async function(path, body) {
    var r = await fetch(this.base + path, {
      method: 'POST',
      headers: this.headers(),
      body: JSON.stringify(body)
    });
    var data = await r.json();
    if (!r.ok) throw new Error(data.error || 'Request failed');
    return data;
  },

  put: async function(path, body) {
    var r = await fetch(this.base + path, {
      method: 'PUT',
      headers: this.headers(),
      body: JSON.stringify(body)
    });
    var data = await r.json();
    if (!r.ok) throw new Error(data.error || 'Request failed');
    return data;
  },

  del: async function(path) {
    var r = await fetch(this.base + path, {
      method: 'DELETE',
      headers: this.headers()
    });
    var data = await r.json();
    if (!r.ok) throw new Error(data.error || 'Request failed');
    return data;
  }
};

/* ── Auth helpers ── */
var Auth = {
  isLoggedIn: function() { return !!localStorage.getItem('token'); },
  userId:     function() { return parseInt(localStorage.getItem('userId') || '0'); },
  username:   function() { return localStorage.getItem('username') || ''; },

  save: function(token, userId, username) {
    localStorage.setItem('token',    token);
    localStorage.setItem('userId',   String(userId));
    localStorage.setItem('username', username);
  },

  logout: function() {
    localStorage.removeItem('token');
    localStorage.removeItem('userId');
    localStorage.removeItem('username');
    window.location.href = '/login';
  }
};

/* ── Toast ── */
function showToast(msg, type, duration) {
  type     = type     || 'success';
  duration = duration || 3000;
  var el = document.getElementById('toast');
  if (!el) {
    el = document.createElement('div');
    el.id = 'toast';
    document.body.appendChild(el);
  }
  el.textContent = msg;
  el.className   = 'show ' + type;
  clearTimeout(el._timer);
  el._timer = setTimeout(function() { el.className = ''; }, duration);
}

/* ── Star rendering ── */
function renderStars(rating) {
  var full = Math.floor(rating);
  var dec  = rating - full;
  var half = dec >= 0.25 && dec < 0.75;
  var html = '<span class="stars">';
  for (var i = 1; i <= 5; i++) {
    if (i <= full) {
      html += '<span class="star full">&#9733;</span>';
    } else if (i === full + 1 && half) {
      html += '<span class="star half">&#9733;</span>';
    } else {
      html += '<span class="star">&#9734;</span>';
    }
  }
  html += '</span>';
  return html;
}

/* ── Navbar ── */
function buildNavbar(activePage) {
  var nav = document.getElementById('main-nav');
  if (!nav) return;

  if (Auth.isLoggedIn()) {
    nav.innerHTML =
      '<a href="/" ' + (activePage === 'home' ? 'class="active"' : '') + '>Home</a>' +
      '<a href="/profile" ' + (activePage === 'profile' ? 'class="active"' : '') + '>My Profile</a>' +
      '<a href="#" onclick="Auth.logout();return false;" class="btn-nav">Logout</a>';
  } else {
    nav.innerHTML =
      '<a href="/">Home</a>' +
      '<a href="/login" ' + (activePage === 'login' ? 'class="active"' : '') + '>Login</a>' +
      '<a href="/signup" class="btn-nav">Sign Up</a>';
  }
}
