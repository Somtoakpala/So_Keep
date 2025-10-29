// main.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:so_keep/model/product_model.dart';
import 'package:so_keep/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Hive
    await Hive.initFlutter();
    
    // Register adapter
    Hive.registerAdapter(ProductsAdapter());
    
    // Open the box
    await Hive.openBox<Products>('productsBox');
    
    print('Hive initialized successfully!');
    
    runApp(const MyApp());
  } catch (e) {
    print('Error initializing Hive: $e');
    runApp(const ErrorApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'So Keep',
      home: HomeScreen(),
    );
  }
}

class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Failed to initialize app. Please restart.'),
        ),
      ),
    );
  }
}