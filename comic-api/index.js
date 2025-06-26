// File: index.js
const express = require('express');
const cors = require('cors');
const fs = require('fs');
const bodyParser = require('body-parser');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

const app = express();
const PORT = 3000;
const SECRET_KEY = 'your_secret_key';

app.use(cors());
app.use(bodyParser.json());

// Load comics data
const comicsData = JSON.parse(fs.readFileSync('./data/comics.json', 'utf8'));
console.log('✅ Đã load comicsData:', comicsData.chineseComics?.length || 0);

// Load discussion
const DISCUSSIONS_FILE = './data/discussions.json';
let discussions = [];

if (fs.existsSync(DISCUSSIONS_FILE)) {
  discussions = JSON.parse(fs.readFileSync(DISCUSSIONS_FILE, 'utf8'));
}

function saveDiscussions() {
  fs.writeFileSync(DISCUSSIONS_FILE, JSON.stringify(discussions, null, 2));
}

// Load user data
let users = [];
const USERS_FILE = './data/users.json';
if (fs.existsSync(USERS_FILE)) {
  users = JSON.parse(fs.readFileSync(USERS_FILE));
}

function saveUsers() {
  fs.writeFileSync(USERS_FILE, JSON.stringify(users, null, 2));
}

function authMiddleware(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  if (!token) return res.sendStatus(401);

  jwt.verify(token, SECRET_KEY, (err, user) => {
    if (err) return res.sendStatus(403);
    req.user = user;
    next();
  });
}

// API: Lấy tất cả truyện
app.get('/api/comics', (req, res) => {
  res.json(comicsData);
});

// API: Lấy truyện HOT (sắp xếp theo views)
app.get('/api/comics/hot', (req, res) => {
  const all = [
    ...(comicsData.chineseComics || []),
    ...(comicsData.koreanComics || []),
    ...(comicsData.textComics || [])
  ];

  const sorted = all.sort((a, b) => (b.views || 0) - (a.views || 0));
  res.json(sorted);
});

// API: Chi tiết một truyện
app.get('/api/comics/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const all = [
    ...(comicsData.chineseComics || []),
    ...(comicsData.koreanComics || []),
    ...(comicsData.textComics || [])
  ];
  const comic = all.find(c => c.id === id);
  if (!comic) return res.status(404).json({ error: 'Not found' });
  res.json(comic);
});

// API: Danh sách chương của truyện
app.get('/api/comics/:id/chapters', (req, res) => {
  const id = parseInt(req.params.id);
  const all = [
    ...(comicsData.chineseComics || []),
    ...(comicsData.koreanComics || []),
    ...(comicsData.textComics || [])
  ];
  const comic = all.find(c => c.id === id);
  if (!comic) return res.status(404).json({ error: 'Comic not found' });
  res.json(comic.chapters || []);
});

// API: Chi tiết 1 chapter
app.get('/api/chapters/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const allComics = [
    ...(comicsData.chineseComics || []),
    ...(comicsData.koreanComics || []),
    ...(comicsData.textComics || [])
  ];
  let found = null;
  allComics.forEach(c => {
    c.chapters?.forEach(ch => {
      if (ch.id === id) found = ch;
    });
  });
  if (!found) return res.status(404).json({ error: 'Chapter not found' });
  res.json(found);
});

// API: Tìm kiếm theo tiêu đề
app.get('/api/search', (req, res) => {
  const keyword = req.query.q?.toLowerCase() || '';
  const all = [
    ...(comicsData.chineseComics || []),
    ...(comicsData.koreanComics || []),
    ...(comicsData.textComics || [])
  ];
  const result = all.filter(c => c.title.toLowerCase().includes(keyword));
  res.json(result);
});

// API: Lấy danh sách tất cả thể loại
app.get('/api/genres', (req, res) => {
  const all = [
    ...(comicsData.chineseComics || []),
    ...(comicsData.koreanComics || []),
    ...(comicsData.textComics || [])
  ];
  const genres = new Set();
  all.forEach(c => {
    c.genres?.split(',').map(g => g.trim()).forEach(g => genres.add(g));
  });
  res.json([...genres]);
});

// API: Lọc truyện theo thể loại
app.get('/api/comics/genre/:genre', (req, res) => {
  const genre = req.params.genre.toLowerCase();
  const all = [
    ...(comicsData.chineseComics || []),
    ...(comicsData.koreanComics || []),
    ...(comicsData.textComics || [])
  ];
  const filtered = all.filter(c =>
    c.genres?.toLowerCase().includes(genre)
  );
  res.json(filtered);
});

// API người dùng: Đăng ký, đăng nhập, lấy profile
app.post('/api/auth/register', (req, res) => {
  const { username, password } = req.body;
  if (!username || !password) return res.status(400).json({ error: 'Missing fields' });
  if (users.find(u => u.username === username)) return res.status(409).json({ error: 'User exists' });

  const hashed = bcrypt.hashSync(password, 10);
  const user = { id: Date.now(), username, password: hashed };
  users.push(user);
  saveUsers();
  res.json({ message: 'Registered successfully' });
});

app.post('/api/auth/login', (req, res) => {
  const { username, password } = req.body;
  const user = users.find(u => u.username === username);
  if (!user || !bcrypt.compareSync(password, user.password)) {
    return res.status(401).json({ error: 'Invalid credentials' });
  }
  const token = jwt.sign({ id: user.id, username: user.username }, SECRET_KEY, { expiresIn: '7d' });
  res.json({ token });
});

app.get('/api/user/profile', authMiddleware, (req, res) => {
  const user = users.find(u => u.id === req.user.id);
  if (!user) return res.sendStatus(404);
  res.json({ id: user.id, username: user.username });
});

app.get('/api/discussions', (req, res) => {
  res.json(discussions);
});

app.post('/api/discussions', authMiddleware, (req, res) => {
  const { message } = req.body;
  if (!message) return res.status(400).json({ error: 'Missing message' });

  const user = users.find(u => u.id === req.user.id);
  const discussion = {
    id: Date.now(),
    userId: user.id,
    username: user.username,
    role: 'Thường dân',
    message,
    createdAt: new Date().toISOString()
  };
  discussions.unshift(discussion);
  saveDiscussions();
  res.json(discussion);
});

app.listen(PORT, () => console.log(`✅ API running at http://localhost:${PORT}`));
