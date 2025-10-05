import 'dart:convert';
import 'package:easyshop/widget/color_shop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants/constant.dart';
import '../views/admin_home_page.dart';
import '../views/home_page.dart';

class AuthController extends GetxController {

  late SharedPreferences pref;

  @override
  Future<void> onInit() async {
    pref = await SharedPreferences.getInstance();
    super.onInit();
  }

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernameController = TextEditingController();

  // مفاتيح الفورم
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  //  تسجيل الدخول مع دعم الدور
  Future<void> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      String token = res["token"];
      String role = res["user"]["role"] ?? "user"; // الحصول على الدور

      // تخزين بيانات المستخدم
      await pref.setString("token", token);
      await pref.setString("email", email);
      await pref.setString("role", role); // تخزين الدور

      //  التوجيه حسب الدور
      if (role == "admin") {
        Get.offAll(() => AdminHomePage()); // صفحة الأدمن
      } else {
        Get.offAll(() => HomePage()); // صفحة الزبون
      }

    } else {
      final res = jsonDecode(response.body);
      Get.snackbar(
        "Error",
        res["message"] ?? "Login failed",
        backgroundColor: ColorShop.purple,
        colorText: Colors.white,
      );
    }
  }


  //  تسجيل حساب جديد مع دعم الدور
  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    String? role, // يمكن إرسال الدور عند إنشاء الحساب
  }) async {
    try {
      final response = await http.post(
        Uri.parse(registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
          "confirmPassword": confirmPassword,
          "role": role ?? "user", // إذا لم يُرسل، افتراضيًا user
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // تسجيل دخول تلقائي بعد التسجيل
        await login(email: email, password: password);
      } else {
        final res = jsonDecode(response.body);
        Get.snackbar(
          "Error",
          res["message"] ?? "Registration failed",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  // التحقق من الفورم
  Future<void> Vlogin() async {
    if (!loginFormKey.currentState!.validate()) return;
    await login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  Future<void> Vregister() async {
    if (!registerFormKey.currentState!.validate()) return;
    await register(
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
    );
  }

  // التحقق من المدخلات
  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) return "Username is required";
    if (value.length < 3) return "Username must be at least 3 characters";
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Email is required";
    if (!GetUtils.isEmail(value)) return "Enter a valid email";
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    if (value.length < 6) return "Password must be at least 6 characters";
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return "Confirm your password";
    if (value != passwordController.text) return "Passwords do not match";
    return null;
  }
}
