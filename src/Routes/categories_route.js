const express = require('express');
const router = express.Router();
const authenticateToken = require('../middleware/authMiddleWare');
const {
    getAllCategories,
    insertCategory,
    deleteCategory,
    updateCategory,
    getProductsByCategory
} = require('../controllers/categories_controller');

router.get('/getAllCategories',authenticateToken, getAllCategories);
router.post('/insertCategory', authenticateToken, insertCategory);
router.post('/deleteCategory', authenticateToken, deleteCategory);
router.post('/updateCategory', authenticateToken, updateCategory);
router.get('/getProductsByCategory', getProductsByCategory);


module.exports = router;
