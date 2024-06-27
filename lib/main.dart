import 'package:gigle_boo/spalashpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// Mengimpor SplashPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashPage(), // Menggunakan SplashPage sebagai halaman awal
    );
  }
}
