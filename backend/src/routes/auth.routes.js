const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const userModel = require('../models/user.model');
const { authMiddleware, JWT_SECRET } = require('../middleware/auth.middleware');

// POST /api/auth/register - Register new user
router.post('/register', async (req, res) => {
    try {
        const { name, email, password } = req.body;

        // Validation
        if (!name || !email || !password) {
            return res.status(400).json({
                success: false,
                message: 'Nama, email, dan password wajib diisi'
            });
        }

        if (password.length < 6) {
            return res.status(400).json({
                success: false,
                message: 'Password minimal 6 karakter'
            });
        }

        const user = await userModel.register({ name, email, password });

        // Generate token
        const token = jwt.sign(
            { id: user.id, email: user.email, role: user.role },
            JWT_SECRET,
            { expiresIn: '7d' }
        );

        res.status(201).json({
            success: true,
            message: 'Registrasi berhasil',
            data: {
                user,
                token
            }
        });
    } catch (error) {
        console.error('Register error:', error);
        res.status(400).json({
            success: false,
            message: error.message || 'Registrasi gagal'
        });
    }
});

// POST /api/auth/login - Login user
router.post('/login', async (req, res) => {
    try {
        const { email, password } = req.body;

        // Validation
        if (!email || !password) {
            return res.status(400).json({
                success: false,
                message: 'Email dan password wajib diisi'
            });
        }

        const user = await userModel.login(email, password);

        // Generate token
        const token = jwt.sign(
            { id: user.id, email: user.email, role: user.role },
            JWT_SECRET,
            { expiresIn: '7d' }
        );

        res.json({
            success: true,
            message: 'Login berhasil',
            data: {
                user,
                token
            }
        });
    } catch (error) {
        console.error('Login error:', error);
        res.status(401).json({
            success: false,
            message: error.message || 'Login gagal'
        });
    }
});

// GET /api/auth/me - Get current user info
router.get('/me', authMiddleware, async (req, res) => {
    try {
        const user = await userModel.findById(req.admin.id);

        if (!user) {
            return res.status(404).json({
                success: false,
                message: 'User tidak ditemukan'
            });
        }

        res.json({
            success: true,
            data: user
        });
    } catch (error) {
        console.error('Get user error:', error);
        res.status(500).json({
            success: false,
            message: 'Gagal mengambil data user'
        });
    }
});

// PUT /api/auth/profile - Update profile
router.put('/profile', authMiddleware, async (req, res) => {
    try {
        const { name, email } = req.body;
        const user = await userModel.updateProfile(req.admin.id, { name, email });

        res.json({
            success: true,
            message: 'Profil berhasil diperbarui',
            data: user
        });
    } catch (error) {
        console.error('Update profile error:', error);
        res.status(500).json({
            success: false,
            message: 'Gagal memperbarui profil'
        });
    }
});

// PUT /api/auth/change-password - Change password
router.put('/change-password', authMiddleware, async (req, res) => {
    try {
        const { oldPassword, newPassword } = req.body;

        // Validation
        if (!oldPassword || !newPassword) {
            return res.status(400).json({
                success: false,
                message: 'Password lama dan baru wajib diisi'
            });
        }

        if (newPassword.length < 6) {
            return res.status(400).json({
                success: false,
                message: 'Password baru minimal 6 karakter'
            });
        }

        await userModel.changePassword(req.admin.id, oldPassword, newPassword);

        res.json({
            success: true,
            message: 'Password berhasil diubah'
        });
    } catch (error) {
        console.error('Change password error:', error);
        res.status(400).json({
            success: false,
            message: error.message || 'Gagal mengubah password'
        });
    }
});

module.exports = router;
