import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fooddeliveryapp/admin/add_food.dart';
import 'package:fooddeliveryapp/admin/admin_login.dart';
import 'package:fooddeliveryapp/admin/home_admin.dart';
import 'package:fooddeliveryapp/pages/bottomnav.dart';
import 'package:fooddeliveryapp/pages/home.dart';
import 'package:fooddeliveryapp/pages/onboard.dart';
import 'package:fooddeliveryapp/pages/signup.dart';
import 'package:fooddeliveryapp/pages/wallet.dart';
import 'package:fooddeliveryapp/widget/app_constant.dart';
import 'package:fooddeliveryapp/admin/add_food.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase and Stripe
  try {
    Stripe.publishableKey = publishableKey; // Make sure publishableKey is properly defined in app_constant.dart
    await Firebase.initializeApp();
    print('Firebase and Stripe initialized successfully.');
  } catch (e) {
    print('Error initializing Firebase or Stripe: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Onboard(), // Replace with Onboard() or other initial page if needed
    );
  }
}
