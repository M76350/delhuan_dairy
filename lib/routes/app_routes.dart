import 'package:flutter/material.dart';
import '../presentation/product_detail/product_detail.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/shopping_cart/shopping_cart.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/product_catalog/product_catalog.dart';
import '../presentation/about_us/about_us.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String productDetail = '/product-detail';
  static const String splash = '/splash-screen';
  static const String shoppingCart = '/shopping-cart';
  static const String home = '/home-screen';
  static const String productCatalog = '/product-catalog';
  static const String aboutUs = '/about-us';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    productDetail: (context) => const ProductDetail(),
    splash: (context) => const SplashScreen(),
    shoppingCart: (context) => const ShoppingCart(),
    home: (context) => const HomeScreen(),
    productCatalog: (context) => const ProductCatalog(),
    aboutUs: (context) => const AboutUs(),
    // TODO: Add your other routes here
  };
}
