import 'package:easyshop/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widget/color_shop.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends StatefulWidget {
  RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final AuthController authController = Get.put(AuthController());

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
                // عبارة ترحيبية فوق الكارد
                const Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Text(
                    "مرحباً! أنشئ حسابك لتبدأ تجربة التسوق المثالية ",
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
                    side: BorderSide(color: Colors.purple),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    width: 400,
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: authController.registerFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "انشاء حساب",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 20),

                          // Username
                          TextFormField(
                            controller: authController.usernameController,
                            validator: authController.validateUsername,
                            cursorColor: ColorShop.purple3,
                            style: const TextStyle(color: Colors.white70),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person_outlined, color: Colors.white60),
                              labelText: "اسم المستخدم",
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              labelStyle: const TextStyle(color: Colors.white70, fontSize: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Email
                          TextFormField(
                            controller: authController.emailController,
                            validator: authController.validateEmail,
                            cursorColor: ColorShop.purple3,
                            style: const TextStyle(color: Colors.white70),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email_outlined, color: Colors.white60),
                              labelText: "البريد الألكتروني",
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              labelStyle: const TextStyle(color: Colors.white70, fontSize: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Password مع أيقونة إظهار/إخفاء
                          TextFormField(
                            controller: authController.passwordController,
                            validator: authController.validatePassword,
                            obscureText: _obscurePassword,
                            cursorColor: ColorShop.purple3,
                            style: const TextStyle(color: Colors.white70),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outline_rounded, color: Colors.white60),
                              labelText: "كلمة المرور",
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              labelStyle: const TextStyle(color: Colors.white70, fontSize: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.white60,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Confirm Password مع أيقونة إظهار/إخفاء
                          TextFormField(
                            controller: authController.confirmPasswordController,
                            validator: authController.validateConfirmPassword,
                            obscureText: _obscureConfirmPassword,
                            cursorColor: ColorShop.purple3,
                            style: const TextStyle(color: Colors.white70),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.password, color: Colors.white60),
                              labelText: "تأكيد كلمة المرور",
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              labelStyle: const TextStyle(color: Colors.white70, fontSize: 15),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.white60,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // زر التسجيل
                          ElevatedButton(
                            onPressed: authController.Vregister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorShop.purple2,
                              foregroundColor: Colors.white70,
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              "انشاء حساب",
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
                              const Text("لديك حساب مسبقا.",
                                  style: TextStyle(color: Colors.white70, fontSize: 15)),
                              TextButton(
                                onPressed: () {
                                  Get.to(LoginView());
                                },
                                child: const Text(
                                  "تسجيل دخول",
                                  style: TextStyle(color: Colors.pinkAccent, fontSize: 15),
                                ),
                              ),
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
