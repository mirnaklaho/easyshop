import 'package:get/get.dart';

class NavigationController extends GetxController {
  int currentIndex = 0;
  String? userEmail;

  void changePage(int index) {
    currentIndex = index;
    update();
  }

  void setUserEmail(String email) {
    userEmail = email;
    update();
  }
}
