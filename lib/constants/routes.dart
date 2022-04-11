import 'package:e_commerce_seller/screens/screens.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  const AppRoutes._();

  static const String initialRoute = WelcomeScreen.routeName;

  static Map<String, WidgetBuilder> routes = {
    WelcomeScreen.routeName: (_) => const WelcomeScreen(),
    LoginScreen.routeName: (_) => const LoginScreen(),
    SignUpScreen.routeName: (_) => const SignUpScreen(),
    DashboardWrapper.routeName: (_) => const DashboardWrapper(),
    HomeScreen.routeName: (_) => const HomeScreen(),
    ProductsScreen.routeName: (_) => const ProductsScreen(),
    SettingsScreen.routeName: (_) => const SettingsScreen(),
  };
}
