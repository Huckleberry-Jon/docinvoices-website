import 'package:flutter/material.dart';

import 'business_info_screen.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  InputDecoration _fieldStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: const Color(0xFF1E252F),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.orange,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isSpanish = languageCode == 'es';
    return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/images/docinvoices_logo.png',
                    height: 110,
                  ),
                  const SizedBox(height: 24),
                  Text(
  isSpanish
      ? 'Cree su cuenta'
      : 'Create Your Account',
  textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
  isSpanish
      ? 'Ingrese su información para comenzar.'
      : 'Enter your information to get started.',
  textAlign: TextAlign.center,
  style: const TextStyle(
    color: Colors.white70,
    fontSize: 18,
  ),
),
                  const SizedBox(height: 36),
                  TextField(
                    decoration:_fieldStyle(
  isSpanish ? 'Su nombre' : 'Your Name',
  Icons.person_outline,
),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration:_fieldStyle(
  isSpanish ? 'Correo electrónico' : 'Email Address',
  Icons.email_outlined,
),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    keyboardType: TextInputType.phone,
                    decoration:_fieldStyle(
  isSpanish ? 'Número de teléfono' : 'Phone Number',
  Icons.phone_outlined,
),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    obscureText: true,
                    decoration:_fieldStyle(
  isSpanish ? 'Contraseña' : 'Password',
  Icons.lock_outline,
),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    obscureText: true,
                    decoration: _fieldStyle(
  isSpanish ? 'Confirmar contraseña' : 'Confirm Password',
  Icons.lock_reset_outlined,
),
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusinessInfoScreen(
                           languageCode: languageCode,
),
                          ),
                        );
                      },
                      child: Text(
  isSpanish ? 'Continuar' : 'Continue',
  style: const TextStyle(fontSize: 20),
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