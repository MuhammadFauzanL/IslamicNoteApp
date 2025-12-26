const express = require('express');
const router = express.Router();
const artikelController = require('../controllers/artikel.controller');

// Public routes
router.get('/', artikelController.getAll);
router.get('/:id', artikelController.getById);

// Admin routes (akan ditambahkan auth middleware nanti)
router.post('/', artikelController.create);
router.put('/:id', artikelController.update);
router.delete('/:id', artikelController.remove);

module.exports = router;
