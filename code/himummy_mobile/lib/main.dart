import 'package:flutter/material.dart';
import 'presentation/screens/auth/login_screen.dart';

void main() {
  runApp(const HiMummyApp());
}

class HiMummyApp extends StatelessWidget {
  const HiMummyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HiMummy',
      debugShowCheckedModeBanner: false, // Removes the debug banner in top-right corner
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Nunito Sans', // Will apply once font is added, fallback is default
      ),
      // Set LoginScreen as the starting screen of the app
      home: const LoginScreen(),
    );
  }
}