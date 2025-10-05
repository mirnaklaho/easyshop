import 'dart:convert';
import 'package:easyshop/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constant.dart';
import '../models/ads.dart';
import '../models/category.dart';
import '../models/offers.dart';
import '../models/product.dart';

class HomePageController extends GetxController {
  late SharedPreferences pref;
  List<Offer> offersList = [];
  List<Ads> adsList = [];
  List<Widget> adsItem = [];
  List<Category> categoriesList = [];
  List<Product> productsList = [];
  String token = "";
  int currentAdIndex = 0;
  List<String> adsTexts = [
    "💄عرض روج اليوم ",
    "✨أفضل أنواع المكياج بانتظارك ",
    "   ✨ أفخم أنواع العطور بانتظارك ",
    "🌸أفضل كريمات العناية بالبشرة ",
    "💄عرض لأفضل أنواع الروج ",
  ];


  //  متغير لمعرفة إذا المستخدم أدمن
  bool isAdmin = false;

  // استدعاء من الكاروسل لتحديث المؤشر
  void setCurrentAd(int index) {
    currentAdIndex = index;
    update();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    pref = await SharedPreferences.getInstance();
    token = pref.getString("token") ?? "";

    //  جلب الدور من SharedPreferences
    isAdmin = pref.getString("role") == "admin";

    await getAllAds();
    getAllCategories();
    getAllProducts();
    getAllOffers();
  }

  Future<void> getAllOffers() async {
    token = pref.getString("token") ?? "";
    final response = await http.get(Uri.parse(offersUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        });
    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body);
      offersList = list.map((e) => Offer.fromJson(e)).toList();
      update();
    } else if (response.statusCode == 403) {
      Get.to(LoginView());
    } else {
      print("Error fetching offers: ${response.body}");
    }
  }

  Future<void> getAllAds() async {
    token = pref.getString("token") ?? "";
    final response = await http.get(
      Uri.parse(adsUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body);
      adsList = list.map((e) => Ads.fromJson(e)).toList();
      adsItem.clear();
      for (var ad in adsList) {
        adsItem.add(
          Container(
            margin: const EdgeInsets.all(6.0),
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                image: NetworkImage('${baseUrl}/${ad.image}'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }
      update();
    } else if (response.statusCode == 403) {
      Get.to(() => LoginView());
    } else {
      print("Error loading ads: ${response.body}");
    }
  }

  Future<void> getAllCategories() async {
    token = pref.getString("token") ?? "";
    final response = await http.get(Uri.parse(categoriesUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        });
    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body);
      categoriesList = list.map((e) => Category.fromJson(e)).toList();
      update();
    } else if (response.statusCode == 403) {
      Get.to(LoginView());
    }
  }

  Future<void> getAllProducts() async {
    token = pref.getString("token") ?? "";
    final response = await http.get(Uri.parse(productsUrl), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    });
    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body);
      productsList = list.map((e) => Product.fromJson(e)).toList();
      update();
    } else if (response.statusCode == 403) {
      Get.to(LoginView());
    } else {
      print("Error fetching products: ${response.body}");
    }
  }

  Future<void> getProductsByCategory(int categoryId) async {
    token = pref.getString("token") ?? "";
    final url = Uri.parse(getProductsByCategoryUrl);
    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    });

    if (response.statusCode == 200) {
      List<dynamic> list = jsonDecode(response.body);
      productsList = list.map((e) => Product.fromJson(e)).toList();
      update();
    } else if (response.statusCode == 403) {
      Get.to(LoginView());
    } else {
      print("Error fetching products by category: ${response.body}");
    }
  }

  Product? getProductById(dynamic id) {
    try {
      return productsList.firstWhere((p) => p.id.toString() == id.toString());
    } catch (e) {
      print("⚠️ Product with ID $id not found");
      return null;
    }
  }
}
