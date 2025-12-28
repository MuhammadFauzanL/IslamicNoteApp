const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 4000;

// ================= MIDDLEWARE =================
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use((req, res, next) => {
  console.log(`${req.method} ${req.path}`);
  next();
});

// ================= ROUTES =================
const doaRoutes = require('./routes/doa.routes');
const artikelRoutes = require('./routes/artikel.routes');
const authRoutes = require('./routes/auth.routes');
const chatbotRoutes = require('./routes/chatbot.route');

// ================= MODELS INIT =================
const artikelModel = require('./models/artikel.model');
const userModel = require('./models/user.model');

artikelModel.initArtikelTable();
userModel.initUserTable();

// ================= API =================
app.use('/api/doa', doaRoutes);          // 🔓 PUBLIC
app.use('/api/artikel', artikelRoutes);  // 🔓 PUBLIC
app.use('/api/auth', authRoutes);        // 🔐 LOGIN / REGISTER
app.use('/api/chatbot', chatbotRoutes);  // 🔓 CHATBOT

// ================= HEALTH =================
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok' });
});

// ================= 404 =================
app.use((req, res) => {
  res.status(404).json({ message: 'Endpoint tidak ditemukan' });
});

// ================= ERROR =================
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({ message: 'Server error' });
});

app.listen(PORT, () => {
  console.log(`🚀 Server running http://localhost:${PORT}`);
});
