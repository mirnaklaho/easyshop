import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SplashShopController extends GetxController {
  // مدة Splash
  final int splashDuration = 10;

  void startSplash(VoidCallback onFinish) {
    // بعد المدة المحددة ينفذ onFinish
    Timer(Duration(seconds: splashDuration), () {
      onFinish();
    });
  }
}
