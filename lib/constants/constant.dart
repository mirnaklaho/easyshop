
const String baseUrl = "http://192.168.1.101:3000";

// Auth
const String loginUrl = "$baseUrl/auth/login";
const String registerUrl = "$baseUrl/auth/register";
const  adsUrl= "$baseUrl/ads/getAllAds";
const  categoriesUrl="$baseUrl/categories/getAllCategories";
const  productsUrl="$baseUrl/products/getAllProducts";
const  getProductsByCategoryUrl="$baseUrl/categories/getProductsByCategory";
const  offersUrl="$baseUrl/offer/getAllOffers";
const  getAllBillsUrl="$baseUrl/bills/getAllBills";
const  insertBillUrl="$baseUrl/bills/insertBill";
const  confirmBillUrl = "$baseUrl/bills/confirm";//تاكيد شرا الفاتورة مدفوع
const  rejectBillUrl = "$baseUrl/bills/rejectBill";//تاكيد رفض الفاتورة
