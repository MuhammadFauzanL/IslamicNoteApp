const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const userModel = require('../models/user.model');
const { authMiddleware, JWT_SECRET } = require('../middleware/auth.middleware');

// ================= REGISTER =================
router.post('/register', async (req, res) => {
  try {
    const { name, email, password } = req.body;

    if (!name || !email || !password)
      return res.status(400).json({ success: false, message: 'Data tidak lengkap' });

    const user = await userModel.register({ name, email, password });

    const token = jwt.sign(
      { id: user.id, email: user.email, role: user.role },
      JWT_SECRET,
      { expiresIn: '7d' }
    );

    res.status(201).json({
      success: true,
      data: { user, token }
    });

  } catch (err) {
    res.status(400).json({ success: false, message: err.message });
  }
});

// ================= LOGIN =================
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await userModel.login(email, password);

    const token = jwt.sign(
      { id: user.id, email: user.email, role: user.role },
      JWT_SECRET,
      { expiresIn: '7d' }
    );

    res.json({
      success: true,
      data: { user, token }
    });

  } catch (err) {
    res.status(401).json({ success: false, message: err.message });
  }
});

// ================= ME =================
router.get('/me', authMiddleware, (req, res) => {
  res.json({
    success: true,
    data: req.user
  });
});

module.exports = router;
