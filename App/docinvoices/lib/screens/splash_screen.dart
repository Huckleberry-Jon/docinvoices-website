import 'dart:async';
import 'dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'language_screen.dart';
import 'subscription_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () async {
      final prefs = await SharedPreferences.getInstance();
final bool subscriptionActive =
    prefs.getBool('subscriptionActive') ?? false;
      final bool setupComplete =
          prefs.getBool('setupComplete') ?? false;

      final String languageCode =
          prefs.getString('languageCode') ?? 'en';

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
         builder: (_) => !setupComplete
    ? const LanguageScreen()
    : subscriptionActive
        ? DashboardScreen(
            languageCode: languageCode,
          )
        : SubscriptionScreen(
            languageCode: languageCode,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/docinvoices_logo.png',
              width: 180,
            ),
            const SizedBox(height: 30),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: 'Doc',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                    text: 'Invoices',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 18),
                children: [
                  TextSpan(
                    text: 'From ',
                    style: TextStyle(color: Colors.white70),
                  ),
                  TextSpan(
                    text: 'Job',
                    style: TextStyle(color: Colors.blue),
                  ),
                  TextSpan(
                    text: ' to ',
                    style: TextStyle(color: Colors.white70),
                  ),
                  TextSpan(
                    text: 'Payment.',
                    style: TextStyle(color: Colors.orange),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 42),
            const SizedBox(
              width: 38,
              height: 38,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}