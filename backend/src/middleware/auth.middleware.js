const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'islamicnote_secret_key_2024';

// Auth middleware for API routes (JWT)
const authMiddleware = (req, res, next) => {
    const token = req.headers.authorization?.split(' ')[1];

    if (!token) {
        return res.status(401).json({ success: false, message: 'Token tidak ditemukan' });
    }

    try {
        const decoded = jwt.verify(token, JWT_SECRET);
        req.user = decoded;
        req.admin = decoded; // backwards compatibility
        next();
    } catch (error) {
        return res.status(401).json({ success: false, message: 'Token tidak valid' });
    }
};

// Admin-only middleware (requires authMiddleware first)
const adminOnly = (req, res, next) => {
    if (!req.user || req.user.role !== 'admin') {
        return res.status(403).json({
            success: false,
            message: 'Akses ditolak. Hanya admin yang diizinkan.'
        });
    }
    next();
};

// Auth middleware for admin pages (session)
const sessionAuth = (req, res, next) => {
    if (req.session && req.session.admin) {
        next();
    } else {
        res.redirect('/admin/login');
    }
};

// Generate JWT token
const generateToken = (user) => {
    return jwt.sign(
        { id: user.id, email: user.email, name: user.name, role: user.role },
        JWT_SECRET,
        { expiresIn: '7d' }
    );
};

module.exports = {
    authMiddleware,
    adminOnly,
    sessionAuth,
    generateToken,
    JWT_SECRET
};
