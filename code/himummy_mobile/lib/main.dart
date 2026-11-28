import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:himummy_mobile/data/emulator_config.dart';
import 'package:himummy_mobile/presentation/screens/auth/login_screen.dart';

/// Demo options: work ONLY with the local Firebase emulator.
/// Replace with generated firebase_options.dart (flutterfire configure)
/// when a real Firebase project exists.
const FirebaseOptions _demoOptions = FirebaseOptions(
  apiKey: 'demo-key',
  appId: '1:1:web:1',
  messagingSenderId: '1',
  projectId: 'demo-himummy',
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: _demoOptions);
  if (kDebugMode) {
    await useFirebaseEmulator();
  }
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