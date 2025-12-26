const { query } = require('../config/database');
const bcrypt = require('bcryptjs');

// Initialize users table
const initUserTable = async () => {
    try {
        await query(`
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        role VARCHAR(20) DEFAULT 'user',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);

        // Check if default admin exists
        const result = await query('SELECT * FROM users WHERE email = $1', ['admin@islamicnote.com']);
        if (result.rows.length === 0) {
            const hashedPassword = await bcrypt.hash('admin123', 10);
            await query(
                'INSERT INTO users (name, email, password, role) VALUES ($1, $2, $3, $4)',
                ['Administrator', 'admin@islamicnote.com', hashedPassword, 'admin']
            );
            console.log('✅ Default admin user created: admin@islamicnote.com / admin123');
        }
    } catch (error) {
        console.error('Error creating users table:', error);
    }
};

// Register new user
const register = async (userData) => {
    const { name, email, password } = userData;

    // Check if email already exists
    const existing = await query('SELECT * FROM users WHERE email = $1', [email]);
    if (existing.rows.length > 0) {
        throw new Error('Email sudah terdaftar');
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const result = await query(
        'INSERT INTO users (name, email, password, role) VALUES ($1, $2, $3, $4) RETURNING id, name, email, role, created_at',
        [name, email, hashedPassword, 'user']
    );
    return result.rows[0];
};

// Login user
const login = async (email, password) => {
    const result = await query('SELECT * FROM users WHERE email = $1', [email]);
    const user = result.rows[0];

    if (!user) {
        throw new Error('Email tidak ditemukan');
    }

    const isValid = await bcrypt.compare(password, user.password);
    if (!isValid) {
        throw new Error('Password salah');
    }

    // Return user without password
    const { password: _, ...userWithoutPassword } = user;
    return userWithoutPassword;
};

// Find user by ID
const findById = async (id) => {
    const result = await query(
        'SELECT id, name, email, role, created_at FROM users WHERE id = $1',
        [id]
    );
    return result.rows[0];
};

// Find user by email
const findByEmail = async (email) => {
    const result = await query(
        'SELECT id, name, email, role, created_at FROM users WHERE id = $1',
        [email]
    );
    return result.rows[0];
};

// Update user profile
const updateProfile = async (id, userData) => {
    const { name, email } = userData;
    const result = await query(
        'UPDATE users SET name = $1, email = $2 WHERE id = $3 RETURNING id, name, email, role',
        [name, email, id]
    );
    return result.rows[0];
};

// Check if user is admin
const isAdmin = (user) => {
    return user && user.role === 'admin';
};

// Change password
const changePassword = async (id, oldPassword, newPassword) => {
    // Get user with password for verification
    const result = await query('SELECT * FROM users WHERE id = $1', [id]);
    const user = result.rows[0];

    if (!user) {
        throw new Error('User tidak ditemukan');
    }

    // Verify old password
    const isValid = await bcrypt.compare(oldPassword, user.password);
    if (!isValid) {
        throw new Error('Password lama salah');
    }

    // Hash new password and update
    const hashedPassword = await bcrypt.hash(newPassword, 10);
    await query('UPDATE users SET password = $1 WHERE id = $2', [hashedPassword, id]);

    return { success: true };
};

module.exports = {
    initUserTable,
    register,
    login,
    findById,
    findByEmail,
    updateProfile,
    isAdmin,
    changePassword
};
