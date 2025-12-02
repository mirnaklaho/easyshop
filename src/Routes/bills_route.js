const express = require('express');
const router = express.Router();
const authenticateToken = require('../middleware/authMiddleWare');
const {
    insertBill,
    getAllBills,
    confirmBill,
    rejectBill
} = require('../controllers/bills_controller');


router.post('/getAllBills', authenticateToken, getAllBills);
router.post('/insertBill', authenticateToken, insertBill);
router.post('/confirm', confirmBill);
router.post('/rejectBill', rejectBill);

module.exports = router;
