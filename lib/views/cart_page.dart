import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/cart_controller.dart';
import '../controllers/bills_controller.dart';
import '../constants/constant.dart'; // يحتوي على baseUrl, insertBillUrl, insertBillDetailsUrl

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find();
    final BillsController billsController = Get.put(BillsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(" السلة"),
        backgroundColor: Colors.pink[50],
        elevation: 0.5,
        centerTitle: true,
      ),
      body: GetBuilder<CartController>(
        builder: (_) {
          if (_.cartItems.isEmpty) {
            return const Center(
              child: Text("السلة فارغة"),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = _.cartItems[index];
                    final quantity = _.getQuantity(item);

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                '$baseUrl/${item.image ?? ''}',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${item.price} \$',
                                    style: const TextStyle(fontSize: 14, color: Colors.green),
                                  ),
                                  const SizedBox(height: 8),

                                  Row(
                                    children: [
                                      const Text(
                                        "الكمية: ",
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.pink.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '$quantity',
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          cartController.removeProduct(item);
                                          Get.snackbar(
                                            "تم الحذف",
                                            "${item.name} تم حذفه من السلة",
                                            snackPosition: SnackPosition.TOP,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "الإجمالي:",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${_.totalPrice.toStringAsFixed(2)} \$",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final email = prefs.getString("email");
                        final token = prefs.getString("token");

                        if (_.cartItems.isEmpty) {
                          Get.snackbar("تنبيه", "السلة فارغة");
                          return;
                        }

                        final total = _.totalPrice;

                        // إنشاء الفاتورة
                        final response = await http.post(
                          Uri.parse(insertBillUrl),
                          headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
                          body: jsonEncode({"email": email, "total": total}),
                        );

                        if (response.statusCode == 200) {
                          final body = jsonDecode(response.body);
                          final billId = body['id'];

                          // إضافة كل المنتجات مع الكمية
                          for (var item in _.cartItems) {
                            await http.post(
                              Uri.parse(insertBillUrl),
                              headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
                              body: jsonEncode({
                                "billId": billId,
                                "productId": item.id,
                                "amount": _.getQuantity(item),
                              }),
                            );
                          }

                          cartController.clearCart();
                          await billsController.getAllBills();
                          Get.snackbar("تمت العملية", "تم تأكيد الطلب بنجاح");
                          Get.back();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        "تأكيد الطلب",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
