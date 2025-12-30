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

// Log request (optional)
app.use((req, res, next) => {
  console.log(`${req.method} ${req.path}`);
  next();
});

// ================= ROUTES =================
const doaRoutes = require('./routes/doa.routes');
const artikelRoutes = require('./routes/artikel.routes');
const authRoutes = require('./routes/auth.routes');
const chatbotRoutes = require('./routes/chatbot.route');

// ================= MODELS =================
const artikelModel = require('./models/artikel.model');
const userModel = require('./models/user.model');

// ================= SAFE INIT (ANTI BERISIK) =================
// ⚠️ PENTING: init DB dibungkus try-catch
// Agar:
// - Internet mati ❌ tidak crash
// - DB unreachable ❌ tidak spam error
// - Server tetap jalan ✅
(async () => {
  try {
    await userModel.initUserTable();
    console.log('✅ User table ready');
  } catch (e) {
    console.warn('⚠️ DB offline, skip init user table');
  }

  try {
    await artikelModel.initArtikelTable();
    console.log('✅ Artikel table ready');
  } catch (e) {
    console.warn('⚠️ DB offline, skip init artikel table');
  }
})();

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

// ================= START =================
app.listen(PORT, () => {
  console.log(`🚀 Server running http://localhost:${PORT}`);
});
