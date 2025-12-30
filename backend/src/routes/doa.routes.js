const express = require('express');
const router = express.Router();
const doaController = require('../controllers/doa.controller');

// Public routes
router.get('/', doaController.getAll);
router.get('/:id', doaController.getById);

// Admin routes (akan ditambahkan auth middleware nanti)
const { authMiddleware } = require('../middleware/auth.middleware');
const adminOnly = require('../middleware/admin.middleware');

router.post('/', authMiddleware, adminOnly, doaController.create);
router.put('/:id', authMiddleware, adminOnly, doaController.update);
router.delete('/:id', authMiddleware, adminOnly, doaController.remove);

module.exports = router;
