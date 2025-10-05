import 'package:get/get.dart';
import '../models/product.dart';

class FavoriteController extends GetxController {
  // ✅ مصفوفة مراقبة للمنتجات المفضلة
  final RxList<Product> favorites = <Product>[].obs;

  /// ✅ التحقق إذا المنتج موجود بالمفضلة عن طريق الـ id
  bool isFavoriteById(int id) {
    return favorites.any((p) => p.id == id);
  }

  /// ✅ إضافة للمفضلة
  void addToFavorite(Product product) {
    if (product.id == null) return;
    if (!isFavoriteById(product.id!)) {
      favorites.add(product);
    }
  }

  /// ✅ إزالة من المفضلة
  void removeFromFavorite(Product product) {
    if (product.id == null) return;
    favorites.removeWhere((p) => p.id == product.id);
  }

  /// ✅ تبديل الحالة (إضافة/إزالة)
  void toggleFavorite(Product product) {
    if (product.id == null) return;
    if (isFavoriteById(product.id!)) {
      removeFromFavorite(product);
    } else {
      addToFavorite(product);
    }
  }
}
