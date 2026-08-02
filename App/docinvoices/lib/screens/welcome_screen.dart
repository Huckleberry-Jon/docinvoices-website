import 'package:flutter/material.dart';

import 'create_account_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final bool isSpanish = languageCode == 'es';

    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/docinvoices_logo.png',
                    width: 150,
                  ),
                  const SizedBox(height: 28),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 38,
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
                  const SizedBox(height: 34),
                  Text(
                    isSpanish ? '¡Bienvenido!' : 'Welcome!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isSpanish
                        ? 'Cree facturas profesionales usando su voz.'
                        : 'Create professional invoices using your voice.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateAccountScreen(
                               languageCode: languageCode,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        isSpanish ? 'Comenzar' : 'Get Started',
                        style: const TextStyle(fontSize: 21),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isSpanish
    ? 'Las cuentas de usuario estarán disponibles en una futura actualización.'
    : 'User accounts will be available in a future update.',
                          ),
                        ),
                      );
                    },
                    child: Text(
                      isSpanish
                          ? '¿Ya tiene una cuenta? Iniciar sesión'
                          : 'Already have an account? Sign In',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}