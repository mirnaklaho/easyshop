import 'package:easyshop/views/login_view.dart';
import 'package:easyshop/widget/color_shop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashShopView extends StatefulWidget {
  const SplashShopView({super.key});
  @override
  State<SplashShopView> createState() => _SplashShopViewState();
}

class _SplashShopViewState extends State<SplashShopView>
    with TickerProviderStateMixin {
  late AnimationController _titleController;
  late AnimationController _subtitleController;
  late AnimationController _logoPulseController;
  late AnimationController _buttonPulseController;

  @override
  void initState() {
    super.initState();

    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _subtitleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    Future.delayed(const Duration(milliseconds: 400), () {
      _subtitleController.forward();
    });

    _logoPulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: 0.95,
      upperBound: 1.05,
    )..repeat(reverse: true);

    _buttonPulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      lowerBound: 0.95,
      upperBound: 1.05,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _logoPulseController.dispose();
    _buttonPulseController.dispose();
    super.dispose();
  }

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              SizedBox(
                width: 260,
                height: 260,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 0,
                      child: Image.asset(
                        "assets/lipstick.png",
                        width: 40,
                        color: Colors.white.withOpacity(0.4),
                        colorBlendMode: BlendMode.modulate,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Image.asset(
                        "assets/powder.png",
                        width: 38,
                        color: Colors.white.withOpacity(0.4),
                        colorBlendMode: BlendMode.modulate,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Image.asset(
                        "assets/cream.png",
                        width: 42,
                        color: Colors.white.withOpacity(0.4),
                        colorBlendMode: BlendMode.modulate,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      child: Image.asset(
                        "assets/mascara.png",
                        width: 36,
                        color: Colors.white.withOpacity(0.4),
                        colorBlendMode: BlendMode.modulate,
                      ),
                    ),
                    ScaleTransition(
                      scale: _logoPulseController,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.15),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.08),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset("assets/bag.png"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),


              FadeTransition(
                opacity: _titleController,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _titleController,
                    curve: Curves.easeOutBack,
                  )),
                  child: const Text(
                    "استمتعي بتجربة التسوق المثالية 🛍️",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black38,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),


              FadeTransition(
                opacity: _subtitleController,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.2),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _subtitleController,
                    curve: Curves.easeOut,
                  )),
                  child: const Text(
                    "أفضل المنتجات والجمال بين يديك",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 45),


              GestureDetector(
                onTap: () {
                  Get.off(() => LoginView());
                },
                child: ScaleTransition(
                  scale: _buttonPulseController,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 45, vertical: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      gradient: LinearGradient(
                        colors: [
                          ColorShop.purple.withOpacity(0.6),
                          ColorShop.purple2.withOpacity(0.6)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          "ابدأ الآن",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
