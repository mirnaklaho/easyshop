import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';
import '../views/profile_page.dart';

class BottomBarShared extends StatelessWidget {
  final NavigationController navController;

  const BottomBarShared({super.key, required this.navController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationController>(
      init: navController,
      builder: (_) {
        double screenWidth = MediaQuery.of(context).size.width;
        return SizedBox(
          height: 70,
          child: Stack(
            clipBehavior: Clip.none,
            children: [

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildItem(Icons.person_pin, "الملف الشخصي", 0, _.currentIndex),
                    _buildItem(Icons.shopping_cart, "السلة", 1, _.currentIndex),
                    const SizedBox(width: 60),
                    _buildItem(Icons.favorite, "المفضلة", 2, _.currentIndex),
                    _buildItem(Icons.shopping_bag_outlined, "الفواتير", 3, _.currentIndex),
                  ],
                ),
              ),


              Positioned(
                top: -20,
                left: screenWidth / 2 - 30,
                child: GestureDetector(
                  onTap: () => navController.changePage(0),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEB66A2),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: 1.0,
                          end: _.currentIndex == 0 ? 1.3 : 1.0,
                        ),
                        duration: const Duration(milliseconds: 200),
                        builder: (context, scale, child) {
                          return Transform.scale(
                            scale: scale,
                            child: const Icon(Icons.home, color: Colors.white, size: 30),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItem(IconData iconData, String label, int index, int currentIndex) {
    bool isSelected = index == currentIndex;
    return GestureDetector(
      onTap: () {
        if (label == "الملف الشخصي") {
          Get.to(() => ProfilePage());
        } else {
          navController.changePage(index);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 1.0, end: isSelected ? 1.3 : 1.0),
            duration: const Duration(milliseconds: 200),
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Icon(iconData, color: isSelected ? Colors.pink : Colors.grey),
              );
            },
          ),
          const SizedBox(height: 4),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 1.0, end: isSelected ? 1.1 : 1.0),
            duration: const Duration(milliseconds: 200),
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.pink : Colors.grey,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
