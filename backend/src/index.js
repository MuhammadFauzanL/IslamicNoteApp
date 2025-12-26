const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet());
app.use(cors()); // Enable CORS for Flutter app
app.use(express.json()); // Parse JSON bodies
app.use(express.urlencoded({ extended: true })); // Parse form data



// Request logging (simple)
app.use((req, res, next) => {
    console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
    next();
});

// Import routes
const doaRoutes = require('./routes/doa.routes');
const artikelRoutes = require('./routes/artikel.routes');
const authRoutes = require('./routes/auth.routes');
// Initialize tables
const artikelModel = require('./models/artikel.model');
const userModel = require('./models/user.model');
artikelModel.initArtikelTable();
userModel.initUserTable();

// API Routes
app.use('/api/doa', doaRoutes);
app.use('/api/artikel', artikelRoutes);
app.use('/api/auth', authRoutes);

// Health check endpoint
app.get('/api/health', (req, res) => {
    res.json({
        status: 'ok',
        message: 'Islamic Note API is running',
        timestamp: new Date().toISOString()
    });
});

// Root endpoint
app.get('/', (req, res) => {
    res.json({
        name: 'Islamic Note API',
        version: '1.0.0',
        endpoints: {
            health: '/api/health',
            doa: '/api/doa',
            artikel: '/api/artikel',
            auth: '/api/auth'
        }
    });
});

// 404 handler
app.use((req, res) => {
    res.status(404).json({
        error: 'Not Found',
        message: `Endpoint ${req.path} tidak ditemukan`
    });
});

// Error handler
app.use((err, req, res, next) => {
    console.error('Error:', err);
    res.status(500).json({
        error: 'Internal Server Error',
        message: process.env.NODE_ENV === 'development' ? err.message : 'Terjadi kesalahan server'
    });
});

// Start server
app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
    console.log(`📚 API Docs: http://localhost:${PORT}/`);
});
