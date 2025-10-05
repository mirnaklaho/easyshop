import 'package:easyshop/views/register_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widget/color_shop.dart';
import '../controllers/auth_controller.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthController authController = Get.put(AuthController());
  bool _obscurePassword = true; // حالة إخفاء/إظهار كلمة المرور

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ColorShop.purple,
              ColorShop.purple2,
              ColorShop.purple3,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                // عبارة ترحيبية
                const Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: Text(
                    "أهلاً بك! سجّل دخولك لتستمتع بتجربة التسوق ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                Card(
                  shadowColor: Colors.black87,
                  color: ColorShop.purple2.withOpacity(0.7),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.purple),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    width: 400,
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: authController.loginFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "تسجيل دخول",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Email
                          TextFormField(
                            controller: authController.emailController,
                            cursorColor: ColorShop.purple3,
                            style: const TextStyle(color: Colors.white70),
                            decoration: InputDecoration(
                              labelText: "البريد الألكتروني",
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: Colors.white60,
                              ),
                              labelStyle: const TextStyle(
                                  color: Colors.white70, fontSize: 15),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: authController.validateEmail,
                          ),
                          const SizedBox(height: 15),

                          // Password مع أيقونة إظهار/إخفاء
                          TextFormField(
                            controller: authController.passwordController,
                            cursorColor: ColorShop.purple3,
                            obscureText: _obscurePassword,
                            style: const TextStyle(color: Colors.white70),
                            decoration: InputDecoration(
                              labelText: "كلمة المرور",
                              prefixIcon: const Icon(
                                Icons.lock_outline_rounded,
                                color: Colors.white60,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white60,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              labelStyle: const TextStyle(
                                  color: Colors.white70, fontSize: 15),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: authController.validatePassword,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "نسيت كلمة المرور؟",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // زر تسجيل الدخول
                          ElevatedButton(
                            onPressed: authController.Vlogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorShop.purple2,
                              foregroundColor: Colors.white70,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              "تسجيل دخول",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("ليس لديك حساب؟ ",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 15)),
                              TextButton(
                                onPressed: () {
                                  Get.to(RegisterView());
                                },
                                child: const Text("انشاء حساب",
                                    style: TextStyle(
                                        color: Colors.pinkAccent, fontSize: 15)),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
