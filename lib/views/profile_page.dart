import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_view.dart';
import 'favorites_page.dart';
import 'billsListPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userEmail = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("email") ?? "";
    setState(() {
      userEmail = email;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mainColor = const Color(0xFFFFF0F5);
    final secondaryColor = const Color(0xFFFFF5F8);

    return Scaffold(
      appBar: AppBar(
        title: const Text("الملف الشخصي", style: TextStyle(fontFamily: 'Cairo')),
        centerTitle: true,
        backgroundColor: mainColor.withOpacity(0.9),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.pinkAccent))
          : Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [mainColor, secondaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage('assets/profile.png'),
                backgroundColor: Colors.grey.shade200,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                userEmail!.isNotEmpty ? userEmail! : "لم يتم تسجيل الدخول",
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // ✅ استخدام ListTile بدل الأزرار
            _buildListTile(
              "طلباتي",
              Icons.list_alt,
              Colors.pink.shade300,
                  () => Get.to(() => BillsListPage()),
            ),
            _buildListTile(
              "المفضلة",
              Icons.favorite,
              Colors.pink.shade300,
                  () => Get.to(() => FavoritesPage()),
            ),
            _buildListTile(
              "تسجيل الخروج",
              Icons.logout,
              Colors.red.shade300,
                  () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Get.offAll(() => LoginView());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon, Color iconColor, VoidCallback onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: iconColor, size: 28),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
