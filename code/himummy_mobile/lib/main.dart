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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Nunito Sans',
      ),
      home: const LoginScreen(),
    );
  }
}