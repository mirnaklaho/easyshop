import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/constant.dart';
import '../controllers/bills_controller.dart';
import '../controllers/home_page_controller.dart';
import '../models/bills.dart';


class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late HomePageController homeController;
  late BillsController billsController;

  @override
  void initState() {
    super.initState();
    homeController = Get.put(HomePageController());
    billsController = Get.put(BillsController());
  }

  @override
  Widget build(BuildContext context) {
    final background = const Color(0xFFFFF0F5);
    final accent = const Color(0xFFE91E63);
    final softAccent = const Color(0xFFFF80AB);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: background,
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "لوحة تحكم الأدمن",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            backgroundColor: background,
            elevation: 2,
            bottom: TabBar(
              labelColor: accent,
              unselectedLabelColor: Colors.grey,
              indicatorColor: accent,
              labelStyle: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
              tabs: const [
                Tab(text: "الفواتير"),
                Tab(text: "المنتجات"),
                Tab(text: "الفئات"),
                Tab(text: "العروض"),
              ],
            ),

          ),
          body: TabBarView(
            children: [
              //  الفواتير
              GetBuilder<BillsController>(
                builder: (_) {
                  if (billsController.billsList.isEmpty) {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.pinkAccent));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: billsController.billsList.length,
                    itemBuilder: (context, i) {
                      Bills bill = billsController.billsList[i];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('رقم الفاتورة: ${bill.id}',
                                  style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              Text('الإجمالي: ${bill.total ?? 0} ل.س',
                                  style: const TextStyle(fontFamily: 'Cairo')),
                              Text(
                                'الحالة: ${billsController.getState(bill.state)}',
                                style: const TextStyle(fontFamily: 'Cairo'),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _styledButton(
                                      label: "تأكيد",
                                      icon: Icons.check_circle,
                                      color: Colors.greenAccent.shade400,
                                      textColor: Colors.white,
                                      onPressed: bill.state != 'paid'
                                          ? () => billsController.confirmBill(bill.id!)
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _styledButton(
                                      label: "رفض",
                                      icon: Icons.cancel,
                                      color: Colors.redAccent.shade200,
                                      textColor: Colors.white,
                                      onPressed: bill.state != 'rejected'
                                          ? () => billsController.rejectBill(bill.id!)
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              //  المنتجات
              GetBuilder<HomePageController>(
                builder: (_) {
                  return _buildListSection(
                    list: homeController.productsList,
                    isImage: true,
                    onEdit: (item) => _showEditDialog(item),
                    onDelete: (item) => _showDeleteDialog(item),
                    getSubtitle: (p) => 'السعر: ${p.price ?? 0} ل.س',
                  );
                },
              ),

              //  الفئات
              GetBuilder<HomePageController>(
                builder: (_) {
                  if (homeController.categoriesList.isEmpty) {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.pinkAccent));
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemCount: homeController.categoriesList.length,
                    itemBuilder: (context, i) {
                      final category = homeController.categoriesList[i];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.pink.shade100.withOpacity(0.4),
                              blurRadius: 6,
                              offset: const Offset(2, 4),
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor: softAccent.withOpacity(0.3),
                              child: const Icon(Icons.category,
                                  color: Colors.pinkAccent, size: 40),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              category.name ?? "",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _styledButton(
                                      label: "تعديل",
                                      icon: Icons.edit,
                                      color: const Color(0xFFD1B3E0),
                                      textColor: Colors.white,
                                      onPressed: () => _showEditDialog(category),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _styledButton(
                                      label: "حذف",
                                      icon: Icons.delete,
                                      color: Colors.redAccent.shade100,
                                      textColor: Colors.white,
                                      onPressed: () => _showDeleteDialog(category),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),

              //  العروض
              GetBuilder<HomePageController>(
                builder: (_) {
                  return _buildListSection(
                    list: homeController.offersList,
                    isImage: true,
                    onEdit: (item) => _showEditDialog(item),
                    onDelete: (item) => _showDeleteDialog(item),
                    getSubtitle: (o) =>
                    'السعر الجديد: ${o.newPrice} ل.س\nالسعر القديم: ${o.oldPrice} ل.س\nالخصم: ${o.discount}%',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  زر مخصص
  Widget _styledButton({
    required String label,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        disabledBackgroundColor: Colors.grey.shade300,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      icon: Icon(icon, color: textColor, size: 18),
      label: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  //  قسم عام للمنتجات / العروض
  Widget _buildListSection({
    required List list,
    required bool isImage,
    required Function(dynamic) onEdit,
    required Function(dynamic) onDelete,
    required String Function(dynamic) getSubtitle,
  }) {
    if (list.isEmpty) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.pinkAccent));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, i) {
        final item = list[i];

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: isImage
                      ? (item.image != null && item.image!.isNotEmpty)
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      '$baseUrl/${item.image}',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image,
                          size: 40, color: Colors.grey),
                    ),
                  )
                      : const Icon(Icons.image,
                      size: 40, color: Colors.grey)
                      : const Icon(Icons.category,
                      size: 40, color: Colors.pinkAccent),
                  title: Text(
                    item.name ?? "",
                    style: const TextStyle(
                        fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    getSubtitle(item),
                    style: const TextStyle(fontFamily: 'Cairo'),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _styledButton(
                        label: "تعديل",
                        icon: Icons.edit,
                        color: const Color(0xFFD1B3E0),
                        textColor: Colors.white,
                        onPressed: () => onEdit(item),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _styledButton(
                        label: "حذف",
                        icon: Icons.delete,
                        color: Colors.redAccent.shade100,
                        textColor: Colors.white,
                        onPressed: () => onDelete(item),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //  Dialog لتعديل الاسم
  void _showEditDialog(dynamic item) {
    final TextEditingController controller = TextEditingController(text: item.name);

    Get.defaultDialog(
      title: "تعديل الاسم",
      content: Column(
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: "الاسم الجديد",
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    item.name = controller.text.trim();
                    Get.back();
                    setState(() {});
                  }
                },
                child: const Text("حفظ"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => Get.back(),
                child: const Text("إلغاء"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //  Dialog لتأكيد الحذف
  void _showDeleteDialog(dynamic item) {
    Get.defaultDialog(
      title: "تأكيد الحذف",
      middleText: "هل أنت متأكد أنك تريد حذف ${item.name}؟",
      textCancel: "إلغاء",
      textConfirm: "حذف",
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (homeController.productsList.contains(item)) {
          homeController.productsList.remove(item);
        } else if (homeController.categoriesList.contains(item)) {
          homeController.categoriesList.remove(item);
        } else if (homeController.offersList.contains(item)) {
          homeController.offersList.remove(item);
        }
        setState(() {});
        Get.back();
      },
    );
  }
}
