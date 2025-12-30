const express = require('express');
const router = express.Router();
const artikelController = require('../controllers/artikel.controller');
const { authMiddleware } = require('../middleware/auth.middleware'); 
const adminOnly = require('../middleware/admin.middleware');

router.get('/', artikelController.getAll);
router.get('/:id', artikelController.getById);
router.post('/', authMiddleware, adminOnly, artikelController.create);
router.put('/:id', authMiddleware, adminOnly,artikelController.update);
router.delete('/:id',authMiddleware, adminOnly, artikelController.remove);

module.exports = router;
