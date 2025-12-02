import 'package:easyshop/views/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../constants/constant.dart';
import '../controllers/cart_controller.dart';
import '../controllers/favorite_controller.dart';
import '../controllers/home_page_controller.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/product_page_controller.dart';
import '../models/product.dart';
import '../widget/BottomBarShared.dart';
import 'cart_page.dart';
import 'favorites_page.dart';
import 'billsListPage.dart';
import 'login_view.dart';
import 'product_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomePageController homeController = Get.put(HomePageController());
  final ProductPageController productController = Get.put(ProductPageController());
  final NavigationController navController = Get.put(NavigationController());
  final CartController cartController = Get.put(CartController());
  final FavoriteController favoriteController = Get.put(FavoriteController(), permanent: true);

  String? userEmail;
  bool isLoading = true;

  final List<Widget> pages = [
    const SizedBox(),
    const CartPage(),
    FavoritesPage(),
    BillsListPage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      userEmail = prefs.getString("email") ?? "";
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {

      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Colors.pinkAccent),
        ),
      );
    }

    return GetBuilder<NavigationController>(
      builder: (_) => Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFFEFA), Color(0xFFFFFDFC)],
            ),
          ),
          child: Column(
            children: [
              _buildCustomAppBar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: _.currentIndex == 0 ? _buildHomeContent() : pages[_.currentIndex],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomBarShared(navController: navController),
      ),
    );
  }

  //   AppBar
  Widget _buildCustomAppBar() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFEF87B2),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            GestureDetector(
              onTap: () {
                if (userEmail != null && userEmail!.isNotEmpty) {
                  Get.to(() => ProfilePage());
                } else {
                  Get.snackbar(
                    "تنبيه",
                    "يتم تحميل بيانات الحساب...",
                    backgroundColor: Colors.pink.shade100,
                    colorText: Colors.black87,
                  );
                }
              },
              child: const Icon(Icons.person_pin, color: Colors.white, size: 33),
            ),

            const Text(
              "جمالك بلا حدود",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            GestureDetector(
              onTap: () => Get.to(() => const CartPage()),
              child: const Icon(Icons.shopping_cart, color: Colors.white, size: 28),
            ),
          ],
        ),
      ),
    );
  }

  //  محتوى الصفحة الرئيسية
  Widget _buildHomeContent() {
    return ListView(
      children: [
        _buildCarousel(),
        const SizedBox(height: 25),
        _buildSectionTitle("الفئات"),
        const SizedBox(height: 15),
        _buildCategories(),
        const SizedBox(height: 25),
        _buildSectionTitle("المنتجات المميزة"),
        const SizedBox(height: 15),
        _buildProducts(),
        const SizedBox(height: 25),
        _buildSectionTitle("أقوى العروض"),
        const SizedBox(height: 15),
        _buildOffers(),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontFamily: 'Cairo',
          ),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  //  Carousel
  Widget _buildCarousel() {
    return GetBuilder<HomePageController>(
      builder: (_) {
        if (_.adsItem.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Colors.pinkAccent));
        }
        return Column(
          children: [
            CarouselSlider.builder(
              itemCount: _.adsItem.length,
              itemBuilder: (context, index, realIndex) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _.adsItem[index],
                );
              },
              options: CarouselOptions(
                height: 200,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                onPageChanged: (index, reason) => _.setCurrentAd(index),
                viewportFraction: 0.85,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _.adsItem.length,
                    (index) => Container(
                  width: _.currentAdIndex == index ? 12 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _.currentAdIndex == index
                        ? Colors.pink.shade400
                        : Colors.pink.shade200.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Categories
  Widget _buildCategories() {
    return GetBuilder<HomePageController>(
      builder: (_) {
        if (_.categoriesList.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Colors.pinkAccent));
        }
        return SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _.categoriesList.length,
            separatorBuilder: (_, __) => const SizedBox(width: 15),
            itemBuilder: (context, index) {
              final category = _.categoriesList[index];
              return GestureDetector(
                onTap: () {
                  productController.setText(category.name!);
                  productController.byCategory(homeController.productsList, category.id!);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundImage: NetworkImage('$baseUrl/${category.icon}'),
                      backgroundColor: Colors.pink.shade50,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 80,
                      child: Text(
                        category.name ?? "",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            fontFamily: 'Cairo'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  //  Products
  Widget _buildProducts() {
    return GetBuilder<HomePageController>(
      builder: (_) {
        if (_.productsList.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Colors.pinkAccent));
        }
        return SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _.productsList.length,
            itemBuilder: (context, index) => _buildProductCard(product: _.productsList[index]),
          ),
        );
      },
    );
  }

  Widget _buildProductCard({required Product product}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Get.to(() => ProductDetailsPage(product: product)),
      child: Stack(
        children: [
          Container(
            width: 160,
            margin: const EdgeInsets.only(right: 12, bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    '$baseUrl/${product.image}',
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () {
                              cartController.addProduct(product);
                              Get.snackbar(
                                "تمت الإضافة",
                                "تمت الإضافة إلى السلة",
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.pink[200],
                                colorText: Colors.white,
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.add_shopping_cart, size: 20, color: Colors.pink),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                product.name ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontFamily: 'Cairo'),
                                textAlign: TextAlign.right,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${product.price} \$",
                                style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Cairo'),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => favoriteController.toggleFavorite(product),
              child: Obx(() {
                bool isFav = favoriteController.isFavoriteById(product.id!);
                return Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                    color: isFav ? Colors.red : Colors.pink,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }



  // Offers
  Widget _buildOffers() {
    return GetBuilder<HomePageController>(
      builder: (_) {
        if (_.offersList.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Colors.pinkAccent));
        }
        return SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            itemCount: _.offersList.length,
            itemBuilder: (context, index) {
              final offer = _.offersList[index];
              final int uniqueId = (offer.offerId ?? 0) + 1000000;
              final Product p = Product(
                id: uniqueId,
                name: offer.name,
                image: offer.image,
                price: offer.newPrice != null ? double.tryParse(offer.newPrice!) ?? 0.0 : 0.0,
                description: offer.description,
              );
              return _buildOfferCard(offer: offer, product: p);
            },
          ),
        );
      },
    );
  }

  Widget _buildOfferCard({required dynamic offer, required Product product}) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Get.to(() => ProductDetailsPage(product: product)),
      child: Stack(
        children: [
          Container(
            width: 160,
            margin: const EdgeInsets.only(right: 12, bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    '$baseUrl/${offer.image}',
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () {
                              cartController.addProduct(product);
                              Get.snackbar(
                                "تمت الإضافة",
                                "تمت الإضافة إلى السلة",
                                snackPosition: SnackPosition.TOP,
                                backgroundColor: Colors.pink[200],
                                colorText: Colors.white,
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(Icons.add_shopping_cart, size: 20, color: Colors.pink),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                offer.name ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontFamily: 'Cairo'),
                                textAlign: TextAlign.right,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${offer.newPrice} \$",
                                style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Cairo'),
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => favoriteController.toggleFavorite(product),
              child: Obx(() {
                bool isFav = favoriteController.isFavoriteById(product.id!);
                return Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                    color: isFav ? Colors.red : Colors.pink,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

}
