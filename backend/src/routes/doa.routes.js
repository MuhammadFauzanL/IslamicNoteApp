const express = require('express');
const router = express.Router();
const doaController = require('../controllers/doa.controller');

// Public routes
router.get('/', doaController.getAll);
router.get('/:id', doaController.getById);

// Admin routes (akan ditambahkan auth middleware nanti)
router.post('/', doaController.create);
router.put('/:id', doaController.update);
router.delete('/:id', doaController.remove);

module.exports = router;
