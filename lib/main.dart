// import 'package:burger/details.dart';
// import 'package:burger/restaurant_profile.dart';
// import 'package:burger/ui/auth/pages/splash.dart';
// import 'package:burger/ui/bottomTab/bottom.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';

// void main() async {
//   // Ensures Flutter bindings are initialized before Firebase
//   WidgetsFlutterBinding.ensureInitialized();

//   // Initialize Firebase (works for web and other platforms)
//   await Firebase.initializeApp(
//     options: const FirebaseOptions(
//       apiKey: "AIzaSyBUFjscwsjTLsj6FYkmwu0ZyT8a3eAjNLs",
//       authDomain: "flutter-bur.firebaseapp.com",
//       projectId: "flutter-bur",
//       storageBucket: "flutter-bur.firebasestorage.app",
//       messagingSenderId: "373424854295",
//       appId: "1:373424854295:web:8fe787cdd971601d449352",
//       measurementId: "G-6TJKHT4CYE",
//     ),
//   );
//   print("✅ Firebase initialized successfully!");
//   print("✅ Firebase initialized successfully!");

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: user == null ? Splash() : const BottomTabs(),
//       // home: Partner(),
//       // home: RestaurantProfile(),
//     );
//   }
// }

import 'package:burger/bloc/cart_bloc/cart_bloc.dart';
import 'package:burger/bloc/orders_bloc/orders_bloc.dart';
import 'package:burger/bloc/reviews_bloc/reviews_bloc.dart';
import 'package:burger/data/repositories/cart_repository.dart';
import 'package:burger/data/repositories/order_repository.dart';
import 'package:burger/data/services/cart_services.dart';
import 'package:burger/data/services/order_services.dart';
import 'package:burger/ui/auth/pages/splash.dart';
import 'package:burger/ui/bottomTab/bottom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBUFjscwsjTLsj6FYkmwu0ZyT8a3eAjNLs",
      authDomain: "flutter-bur.firebaseapp.com",
      projectId: "flutter-bur",
      storageBucket: "flutter-bur.firebasestorage.app",
      messagingSenderId: "373424854295",
      appId: "1:373424854295:web:8fe787cdd971601d449352",
      measurementId: "G-6TJKHT4CYE",
    ),
  );
  print("✅ Firebase initialized successfully!");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              CartBloc(repository: CartRepository(service: CartServices())),
        ),
        BlocProvider(create: (_) => OrdersBloc()),
        BlocProvider(
          create: (_) => ReviewsBloc(
            repository: OrderRepository(service: OrderServices()),
          ),
        ),

        // Add other blocs here if needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: user == null ? Splash() : const BottomTabs(),
      ),
    );
  }
}
