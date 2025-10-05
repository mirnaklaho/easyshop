import 'package:easyshop/views/product_page.dart';
import 'package:get/get.dart';

import '../models/product.dart';

class ProductPageController extends GetxController {
  List<Product> showListProduct = [];
  String text = '';

  void setText(String text) {
    this.text = text;
    update();
  }

  void byCategory(List<Product> list, int categoryId) {
    showListProduct = [];
    for (int i = 0; i < list.length; i++) {
      if (list[i].categoryId == categoryId) {
        showListProduct.add(list[i]);
      }
    }
    update();
    Get.to(() => ProductPage());
  }
}
