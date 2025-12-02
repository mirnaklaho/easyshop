const express = require('express');
const router = express.Router();
const authenticateToken = require('../middleware/authMiddleWare');
const { getAllOffers, insertOffer, deleteOffer } = require('../controllers/offers_controller');

router.get('/getAllOffers', authenticateToken, getAllOffers);
router.post('/insertOffer', authenticateToken, insertOffer);
router.post('/deleteOffer', authenticateToken, deleteOffer);

module.exports = router;
