const express=require('express');
const Router =require('express');
const router=Router();
const authenticateToken = require('../middleware/authMiddleWare.js');
const {getAllAds,insertAds , deleteAds,updateAds}=require('../controllers/ads_controller');



router.get('/getAllAds',authenticateToken,getAllAds);// رابط محمي مقفول بس يلي مسجل دخول من قبل بيثدر يدخل على هاد الرابط 
router.post('/insertAds',authenticateToken,insertAds);
router.post('/deleteAds',authenticateToken,deleteAds);
router.post('/updateAds',authenticateToken,updateAds);// ما رح تتحقق العملية الا بعد تنفيذ عملية التحقق,هذا الرابط محمي و مقفول باستخدام تابع auth


module.exports=router;
