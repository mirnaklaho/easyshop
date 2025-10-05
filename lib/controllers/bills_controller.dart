import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../constants/constant.dart';
import '../models/bills.dart';
import '../controllers/home_page_controller.dart';
import '../models/product.dart';

class BillsController extends GetxController {
  List<Bills> billsList = [];
  String token = "";
  String role = ""; // دور المستخدم
  late SharedPreferences pref;

  final HomePageController homeController = Get.find<HomePageController>();

  @override
  Future<void> onInit() async {
    super.onInit();
    billsList.clear();
    await loadTokenAndRole();
    await getAllBills();
  }

  Future<void> loadTokenAndRole() async {
    pref = await SharedPreferences.getInstance();
    token = pref.getString("token") ?? "";
    role = pref.getString("role") ?? "user"; // جلب الدور
  }
  Future<void> getAllBills() async {
    final email = pref.getString("email") ?? "";
    final role = pref.getString("role") ?? "user";

    final response = await http.post(
      Uri.parse(getAllBillsUrl),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "email": role == "admin" ? null : email, // إذا أدمن، يرسل null ليجلب كل الفواتير
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      billsList = list.map((e) => Bills.fromJson(e)).toList();
      update();
    } else {
      print("Error fetching bills: ${response.statusCode}");
    }
  }


  String getState(dynamic state) {
    if (state is int) {
      switch (state) {
        case 0:
          return "معلق";
        case 1:
          return "مقبول";
        case 2:
          return "مرفوض";
        case 3:
          return "تم التسليم";
      }
    } else if (state is String) {
      return state;
    }
    return "";
  }

  Product? getProductForBill(int productId) {
    return homeController.getProductById(productId);
  }

  // تابع تأكيد الفاتورة (متاح فقط للأدمن)
  void confirmBill(int billId) async {
    if (role != 'admin') return;

    final response = await http.post(
      Uri.parse(confirmBillUrl),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"billId": billId}),
    );

    if (response.statusCode == 200) {
      int index = billsList.indexWhere((b) => b.id == billId);
      if (index != -1) {
        billsList[index].state = "paid";
        update();
      }
      Get.snackbar("نجاح", "تم تأكيد الفاتورة بنجاح",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade200);
    } else {
      Get.snackbar("خطأ", "فشل تأكيد الفاتورة",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade200);
    }
  }

  // تابع رفض الفاتورة (متاح فقط للأدمن)
  void rejectBill(int billId) async {
    if (role != 'admin') return;

    final response = await http.post(
      Uri.parse(rejectBillUrl),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"billId": billId}),
    );

    if (response.statusCode == 200) {
      int index = billsList.indexWhere((b) => b.id == billId);
      if (index != -1) {
        billsList[index].state = "rejected";
        update();
      }
      Get.snackbar("نجاح", "تم رفض الفاتورة",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade200);
    } else {
      Get.snackbar("خطأ", "فشل رفض الفاتورة",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade200);
    }
  }
}
