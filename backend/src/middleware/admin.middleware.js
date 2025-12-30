// backend/src/middleware/admin.middleware.js

const adminOnly = (req, res, next) => {
  try {
    // auth.middleware HARUS jalan dulu
    if (!req.user) {
      return res.status(401).json({
        success: false,
        message: 'Unauthorized',
      });
    }

    if (req.user.isAdmin !== true) {
      return res.status(403).json({
        success: false,
        message: 'Akses admin ditolak',
      });
    }

    next();
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Admin middleware error',
    });
  }
};

module.exports = adminOnly;
