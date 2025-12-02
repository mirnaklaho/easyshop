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
    final mainColor = Colors.pinkAccent.shade100;
    final bgColor = Colors.grey.shade100;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text(
          "الملف الشخصي",
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.pinkAccent))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // ---- صورة البروفايل ----
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: const AssetImage('assets/profile.png'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // ---- الإيميل ----
            Text(
              userEmail!.isNotEmpty ? userEmail! : "لم يتم تسجيل الدخول",
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            // ---- صندوق المعلومات ----
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildModernTile(
                    icon: Icons.home_outlined,
                    title: "الصفحة الرئيسية",
                    color: Colors.teal,
                    onTap: () {
                      Get.back();
                    },
                  ),
                  _divider(),

                  _buildModernTile(
                    icon: Icons.list_alt,
                    title: "طلباتي",
                    color: Colors.blueAccent,
                    onTap: () => Get.to(() => BillsListPage()),
                  ),
                  _divider(),
                  _buildModernTile(
                    icon: Icons.favorite,
                    title: "المفضلة",
                    color: Colors.pinkAccent,
                    onTap: () => Get.to(() => FavoritesPage()),
                  ),
                  _divider(),

                  _buildModernTile(
                    icon: Icons.logout,
                    title: "تسجيل الخروج",
                    color: Colors.redAccent,
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      Get.offAll(() => LoginView());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildModernTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        height: 1,
        width: double.infinity,
        color: Colors.grey.withOpacity(0.2),
      ),
    );
  }

}
