// routes/products.route.js
const express = require('express');
const router = express.Router();
const authenticateToken = require('../middleware/authMiddleWare');
const { getAllProducts, insertProduct, deleteProduct, updateProduct,getAllOffers } = require('../controllers/products_controller');

router.get('/getAllProducts', authenticateToken, getAllProducts);
router.post('/insertProduct', authenticateToken, insertProduct);
router.post('/deleteProduct', authenticateToken, deleteProduct);
router.post('/updateProduct', authenticateToken, updateProduct);
router.get('/getAllOffers', authenticateToken, getAllOffers);

module.exports = router;
