import 'package:get/get.dart';
import '../models/product.dart';

class CartController extends GetxController {
  // قائمة المنتجات في السلة (كل منتج يظهر مرة واحدة فقط)
  List<Product> cartItems = [];

  // خريطة لتخزين كمية كل منتج حسب id
  Map<int, int> quantities = {};

  // إجمالي السعر
  double get totalPrice {
    double total = 0;
    for (var item in cartItems) {
      int qty = quantities[item.id!] ?? 1;
      total += (double.tryParse(item.price?.toString() ?? '0') ?? 0) * qty;
    }
    return total;
  }

  // إضافة منتج للسلة أو زيادة الكمية إذا كان موجودًا مسبقًا
  void addProduct(Product product, {int quantity = 1}) {
    if (!cartItems.any((p) => p.id == product.id)) {
      cartItems.add(product);
    }
    quantities[product.id!] = (quantities[product.id!] ?? 0) + quantity;
    update(); // لإعادة بناء الـ GetBuilder
  }

  // إزالة منتج من السلة
  void removeProduct(Product product) {
    cartItems.removeWhere((p) => p.id == product.id);
    quantities.remove(product.id!);
    update();
  }

  // تقليل كمية منتج معين
  void decreaseQuantity(Product product, {int quantity = 1}) {
    if (quantities.containsKey(product.id!)) {
      final newQty = quantities[product.id!]! - quantity;
      if (newQty > 0) {
        quantities[product.id!] = newQty;
      } else {
        quantities.remove(product.id!);
        cartItems.removeWhere((p) => p.id == product.id);
      }
      update();
    }
  }

  // الحصول على كمية منتج محدد
  int getQuantity(Product product) {
    return quantities[product.id!] ?? 0;
  }

  // مسح كل السلة
  void clearCart() {
    cartItems.clear();
    quantities.clear();
    update();
  }
}
