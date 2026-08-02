

import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'services/business_profile_repository.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await BusinessProfileRepository.instance.load();

  runApp(const DocInvoicesApp());
}

class DocInvoicesApp extends StatelessWidget {
  const DocInvoicesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DocInvoices',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050B14),
      ),
      home: const SplashScreen(),
    );
  }
}

 

  