

import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'services/business_profile_repository.dart';
import 'services/customer_repository.dart';
import 'services/job_repository.dart';
import 'services/customer_unit_repository.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await BusinessProfileRepository.instance.load();
await CustomerRepository.loadCustomers();
await JobRepository.instance.load();
  runApp(const DocInvoicesApp());
  await CustomerUnitRepository.loadUnits();
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

 

  