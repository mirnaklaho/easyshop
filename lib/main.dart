import 'package:easyshop/views/splash_shop_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/favorite_controller.dart';
void main(){
  Get.put(FavoriteController());
  return runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Easy Shop",
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.pink[50], // يطبق على كل الشاشات
      ),
      home: SplashShopView(),

    );
  }
}
