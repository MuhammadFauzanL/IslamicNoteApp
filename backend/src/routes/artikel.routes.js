const express = require('express');
const router = express.Router();
const artikelController = require('../controllers/artikel.controller');

router.get('/', artikelController.getAll);
router.get('/:id', artikelController.getById);
router.post('/', artikelController.create);
router.put('/:id', artikelController.update);
router.delete('/:id', artikelController.remove);

module.exports = router;
