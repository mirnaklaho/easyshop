const express = require('express');
const conn = require('./config/db');
const cors = require('cors');
const app = express();
const path = require('path');

app.use(express.json());

app.use(cors({
  origin: "*",
  methods: ["GET", "POST", "PUT", "DELETE"],
}));



app.use('/auth',require('./Routes/user_route'));
app.use('/ads',require('./Routes/ads_route'));
app.use('/categories',require('./Routes/categories_route'));
app.use('/products', require('./Routes/products_route'));
app.use('/offer', require('./Routes/offers_route.js'));
app.use('/bills', require('./Routes/bills_route'));

//رابط رفع صورة
app.use('/upload', require('./Routes/upload-images_route'));


app.use( express.static(path.join(__dirname, './images')));//رابط سماحية للوصول الى الصور في المجلدات

app.use( express.static(path.join(__dirname, './images/ads')));// للوصول لمجلد صور الاعلانات
app.use( express.static(path.join(__dirname, './images/categories'))); // للوصول لمجلد صور الفئات
app.use( express.static(path.join(__dirname, './images/products')));//  الرئيسية لوصول لمجلد صور المنتجات
app.use( express.static(path.join(__dirname, './images/extraproduct')));
app.use( express.static(path.join(__dirname, './images/offers')));








const PORT = process.env.PORT || 3000;

app.listen(PORT, '0.0.0.0', () => {
  console.log("Server running on port " + PORT);
});

