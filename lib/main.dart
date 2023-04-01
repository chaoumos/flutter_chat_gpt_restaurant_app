// main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_gpt/routes.dart';
import 'package:flutter_chat_gpt/services/cart_service.dart';
import 'package:flutter_chat_gpt/services/firestore_service.dart';
import 'package:flutter_chat_gpt/services/order_service.dart';
import 'package:flutter_chat_gpt/services/stripe_service.dart';
import 'package:flutter_chat_gpt/services/user_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

import '../firebase_options.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
        name: "firebaseUiAuth");
  }

  //this is for demo propose only dont put any api keys in your code like this
  //chek
  Stripe.publishableKey = dotenv.env["stripeApiKey"] ?? "";

  // if (FirebaseAuth.instance.currentUser == null) {
  //   await FirebaseAuth.instance.signInAnonymously();
  // }

  await initServices();
  runApp(const MyApp());
}

Future initServices() async {
  FirebaseUIAuth.configureProviders([
    GoogleProvider(clientId: "1:558196312739:android:6dad85fcfe7a81efea0d16"),
    EmailAuthProvider(),
    PhoneAuthProvider()
  ]);
  Get.lazyPut(() => UserService());
  Get.lazyPut<CartService>(() => CartService());
  Get.lazyPut<FirestoreService>(() => FirestoreService());
  Get.lazyPut(() => OrderService());
  Get.lazyPut(() => StripeService());
  Get.lazyPut(() => UserService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Restaurant Ordering App',
      initialRoute: '/',
      getPages: RestaurantOrderingRoutes.routes,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        // fontFamily: 'georgia',
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), gapPadding: 10),
        ),
      ),
    );
  }
}
