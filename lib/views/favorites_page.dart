import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import '../constants/constant.dart';
import '../models/product.dart';

class FavoritesPage extends StatelessWidget {
  FavoritesPage({super.key});

  final FavoriteController favoriteController = Get.find<FavoriteController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("المفضلة"),
        backgroundColor: Colors.pink[50],
        elevation: 0.5,
      ),
      body: GetBuilder<FavoriteController>(
        builder: (_) {
          if (_.favorites.isEmpty) {
            return const Center(
              child: Text(
                "لا توجد منتجات في المفضلة",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              itemCount: _.favorites.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.55, // 🔥 صغّرنا النسبة ليطول الكرت
              ),
              itemBuilder: (context, index) {
                final Product product = _.favorites[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                        child: AspectRatio(
                          aspectRatio: 1, // الصورة مربعة
                          child: Image.network(
                            '$baseUrl/${product.image}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                product.name ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Expanded( // 🔥 الوصف بياخد مساحة مرنة
                                child: Text(
                                  product.description ?? "",
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${product.price?.toStringAsFixed(2) ?? "0.00"} \$',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: double.infinity,
                                height: 32,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _.removeFromFavorite(product);
                                    Get.snackbar(
                                      duration: const Duration(seconds: 1),
                                      "المفضلة",
                                      "${product.name} تمت إزالته من المفضلة",
                                      snackPosition: SnackPosition.TOP,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  icon: const Icon(Icons.delete_outline, size: 18, color: Colors.white),
                                  label: const Text(
                                    "إزالة",
                                    style: TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
