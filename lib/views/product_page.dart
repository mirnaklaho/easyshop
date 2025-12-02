import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/product_page_controller.dart';
import '../controllers/cart_controller.dart';
import '../constants/constant.dart';
import '../models/product.dart';


class ProductPage extends StatelessWidget {
  ProductPage({super.key});

  final ProductPageController controller = Get.put(ProductPageController());
  final CartController cartController = Get.put(CartController());
  final FavoriteController favoriteController = Get.find<FavoriteController>();

  // لتخزين كمية كل منتج
  final Map<int, RxInt> quantities = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<ProductPageController>(
          builder: (_) => Text(
            controller.text,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.pink[50],
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),

      ),

      body: GetBuilder<ProductPageController>(
        builder: (_) {
          if (_.showListProduct.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // تجهيز قائمة المنتجات الفرعية
          List<Map<String, dynamic>> subProducts = [];
          for (var product in _.showListProduct) {
            if (product.subImages != null) {
              for (var i = 0; i < product.subImages!.length; i++) {
                final sub = product.subImages![i];
                final int parentId = product.id ?? 0;
                final int uniqueId = parentId * 1000 + i;

                double rating = 3.0 + (i % 3) * 0.5;
                if (sub['rating'] != null) {
                  rating = double.tryParse(sub['rating'].toString()) ?? rating;
                }

                subProducts.add({
                  'id': uniqueId,
                  'name': sub['name'] ?? product.name ?? '',
                  'description': sub['description'] ?? product.description ?? '',
                  'image': sub['image'] ?? product.image ?? '',
                  'price': sub['price'] is double
                      ? sub['price']
                      : double.tryParse(sub['price'].toString()) ?? 0.0,
                  'rating': rating,
                });

                // تهيئة كمية المنتج إذا لم تكن موجودة
                quantities[uniqueId] = quantities[uniqueId] ?? 1.obs;
              }
            }
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              itemCount: subProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.57,
              ),
              itemBuilder: (context, index) {
                final item = subProducts[index];
                final int id = item['id'] as int;
                final String name = item['name'] ?? '';
                final String description = item['description'] ?? '';
                final String image = item['image'] ?? '';
                final double price = item['price'] as double;
                final double rating = item['rating'] as double;
                final Product product = Product(
                  id: id,
                  name: name,
                  image: image,
                  price: price,
                  description: description,
                );

                final RxInt quantity = quantities[id]!;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                            child: Image.network(
                              '$baseUrl/$image',
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Obx(() {
                              final bool isFav = favoriteController.isFavoriteById(id);
                              return CircleAvatar(
                                backgroundColor: Colors.white.withOpacity(0.8),
                                child: IconButton(
                                  icon: Icon(
                                    isFav ? Icons.favorite : Icons.favorite_border,
                                    color: isFav ? Colors.red : Colors.grey,
                                  ),
                                  onPressed: () {
                                    favoriteController.toggleFavorite(product);
                                    final bool newState =
                                    favoriteController.isFavoriteById(id);
                                    Get.snackbar(
                                      "المفضلة",
                                      newState
                                          ? "$name تمت إضافته للمفضلة"
                                          : "$name تمت إزالته من المفضلة",
                                      snackPosition: SnackPosition.TOP,
                                    );
                                  },
                                ),
                              );
                            }),
                          ),
                        ],
                      ),


                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                textAlign: TextAlign.right,
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),

                              Expanded(
                                child: Text(
                                  description,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),



                              Row(
                                children: List.generate(5, (i) {
                                  if (i < rating.floor()) {
                                    return const Icon(Icons.star, color: Colors.orange, size: 16);
                                  } else if (i < rating) {
                                    return const Icon(Icons.star_half, color: Colors.orange, size: 16);
                                  } else {
                                    return const Icon(Icons.star_border, color: Colors.orange, size: 16);
                                  }
                                }),
                              ),
                              const SizedBox(height: 4),


                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${price.toStringAsFixed(2)} \$',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: 14,
                                    ),
                                  ),

                                  Obx(() => Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (quantity.value > 1) quantity.value--;
                                        },
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.remove, size: 14, color: Colors.black),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 6),
                                        child: Text(
                                          quantity.value.toString(),
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          quantity.value++;
                                        },
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.add, size: 14, color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                              const SizedBox(height: 4),

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    cartController.addProduct(product, quantity: quantity.value);
                                    Get.snackbar(
                                      "تمت الإضافة",
                                      "$name تمت إضافته للسلة",
                                      snackPosition: SnackPosition.TOP,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pink,
                                    shadowColor: Colors.pink.shade300,
                                    elevation: 6,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ).copyWith(
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                                      if (states.contains(MaterialState.pressed)) {
                                        return Colors.pink.shade200;
                                      }
                                      return Colors.pink;
                                    }),
                                    elevation: MaterialStateProperty.resolveWith<double>((states) {
                                      if (states.contains(MaterialState.pressed)) {
                                        return 2;
                                      }
                                      return 6;
                                    }),
                                  ),
                                  child: const Text(
                                    "إضافة",
                                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
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
