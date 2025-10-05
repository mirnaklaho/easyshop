import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bills_controller.dart';
import '../models/bills.dart';

class BillsListPage extends StatelessWidget {
  BillsListPage({super.key});
  final BillsController billsController = Get.put(BillsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          " الفواتير",
          style: TextStyle(
            fontSize: 22,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.pink[50],
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: Colors.pink[50],
      body: GetBuilder<BillsController>(
        builder: (_) {
          if (billsController.billsList.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.pinkAccent,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: billsController.billsList.length,
            itemBuilder: (context, i) {
              Bills bill = billsController.billsList[i];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                shadowColor: Colors.grey.withOpacity(0.3),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [Colors.pink.shade50, Colors.pink.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // رقم الفاتورة والحالة
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'رقم الفاتورة: ${bill.id}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: bill.state == 'paid'
                                  ? Colors.green.shade400
                                  : Colors.deepOrangeAccent.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              billsController.getState(bill.state),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // المجموع والتاريخ
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'الإجمالي: ${bill.total ?? 0} ل.س',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'التاريخ: ${bill.createdAt}',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // أزرار التأكيد / الرفض للأدمن فقط
                      if (billsController.role == 'admin')
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton.icon(
                                onPressed: bill.state == 'paid'
                                    ? null
                                    : () {
                                  billsController.confirmBill(bill.id!);
                                },
                                icon: const Icon(Icons.check),
                                label: Text(
                                  bill.state == 'paid' ? "تم التأكيد" : "تأكيد",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: bill.state == 'paid'
                                      ? Colors.green.shade300
                                      : Colors.green.shade400,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton.icon(
                                onPressed: bill.state == 'rejected'
                                    ? null
                                    : () {
                                  billsController.rejectBill(bill.id!);
                                },
                                icon: const Icon(Icons.close),
                                label: const Text("رفض", style: TextStyle(fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade400,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
