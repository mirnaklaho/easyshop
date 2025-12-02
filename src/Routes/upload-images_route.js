const express = require('express');
const router = express.Router();
const authenticateToken = require('../middleware/authMiddleWare');
const multer = require('multer');
const path = require('path');
const{uploadImage}=require('../controllers/upload-image_controller');

function createStorage(folderPath) {
  return multer.diskStorage({
    destination: function (req, file, cb) {
      cb(null, folderPath);
    },
    filename: function (req, file, cb){
      let fileName;
      if(file.originalname.endsWith('jpg')){
        fileName =Date.now()+'-'+'client.jpg';
      }else{
        fileName =Date.now()+'-'+'client.png';
      }
      cb(null,fileName);
    }
  });
}

// تخزين الصور في المجلدات

const storageAds = createStorage('src/images/ads');
const storageProduct = createStorage('src/images/products');
const storageCategories = createStorage('src/images/categories');
// رفع الصور
const uploadAds = multer({ storage: storageAds });
const uploadProduct = multer({ storage: storageProduct });
const uploadCategories = multer({ storage: storageCategories });


//رابط رفع صورة + بعطي الملف على بوست مان
// POST /upload/ads
router.post('/uploadAds', authenticateToken,uploadAds.single('file'), uploadImage)

// POST /upload/product
router.post('/uploadProduct', authenticateToken,uploadProduct.single('file'), uploadImage)


// POST /upload/categories
router.post('/uploadCategories', authenticateToken,uploadCategories.single('file'),uploadImage)
  

module.exports = router;

