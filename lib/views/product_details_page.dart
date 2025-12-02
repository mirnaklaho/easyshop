import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/constant.dart';
import '../models/product.dart';
import '../controllers/cart_controller.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  final CartController cartController = Get.find();

  ProductDetailsPage({super.key, required this.product});

  final RxInt quantity = 1.obs; // كمية المنتج الافتراضية
  final double productRating = 4.0; // تقييم افتراضي

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: Text(
          product.name ?? "تفاصيل المنتج",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.pink[50],
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Hero(
                tag: "product_${product.id}",
                child: Container(
                  width: double.infinity,
                  height: screenHeight * 0.35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      '$baseUrl/${product.image}',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),


              Text(
                product.name ?? "",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${product.price?.toStringAsFixed(2) ?? '0'} \$",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 6),

              // تقييم افتراضي
              Row(
                children: List.generate(5, (i) {
                  if (i < productRating.floor()) {
                    return const Icon(Icons.star, color: Colors.orange, size: 18);
                  } else if (i < productRating) {
                    return const Icon(Icons.star_half, color: Colors.orange, size: 18);
                  } else {
                    return const Icon(Icons.star_border, color: Colors.orange, size: 18);
                  }
                }),
              ),
              const Divider(thickness: 1, height: 20),


              Text(
                product.description ?? "لا يوجد وصف متاح.",
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),


              Obx(() => Row(
                children: [
                  const Text(
                    "الكمية: ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      children: [

                        IconButton(
                          icon: const Icon(Icons.remove, size: 20),
                          onPressed: () {
                            if (quantity.value > 1) quantity.value--;
                          },
                        ),

                        Text(
                          quantity.value.toString(),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),

                        IconButton(
                          icon: const Icon(Icons.add, size: 20),
                          onPressed: () {
                            quantity.value++;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              cartController.addProduct(product, quantity: quantity.value);
              Get.snackbar(
                "تمت الإضافة",
                "${product.name} تمت إضافته للسلة",
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.pink[200],
                colorText: Colors.white,
              );
            },
            icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
            label: const Text(
              "إضافة إلى السلة",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
