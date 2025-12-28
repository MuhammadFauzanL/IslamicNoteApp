const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'islamicnote_secret_key_2024';

const authMiddleware = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader) {
    return res.status(401).json({
      success: false,
      message: 'Token tidak ditemukan'
    });
  }

  const token = authHeader.split(' ')[1];

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.user = decoded;
    next();
  } catch {
    return res.status(401).json({
      success: false,
      message: 'Token tidak valid'
    });
  }
};

module.exports = { authMiddleware, JWT_SECRET };
