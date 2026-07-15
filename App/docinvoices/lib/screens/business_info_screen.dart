import 'package:flutter/material.dart';

import 'choose_industry_screen.dart';

class BusinessInfoScreen extends StatelessWidget {
  const BusinessInfoScreen({super.key});

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
                  const Icon(
                    Icons.storefront_outlined,
                    color: Colors.orange,
                    size: 70,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Business Information',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tell us about your business.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 36),
                  TextField(
                    decoration: _fieldStyle(
                      'Business Name',
                      Icons.business_outlined,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    keyboardType: TextInputType.phone,
                    decoration: _fieldStyle(
                      'Business Phone',
                      Icons.phone_outlined,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: _fieldStyle(
                      'Business Email',
                      Icons.email_outlined,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    decoration: _fieldStyle(
                      'Street Address',
                      Icons.location_on_outlined,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          decoration: _fieldStyle(
                            'City',
                            Icons.location_city_outlined,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TextField(
                          textCapitalization:
                              TextCapitalization.characters,
                          decoration: _fieldStyle(
                            'State',
                            Icons.map_outlined,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: _fieldStyle(
                      'ZIP Code',
                      Icons.markunread_mailbox_outlined,
                    ),
                  ),
                  const SizedBox(height: 34),
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ChooseIndustryScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontSize: 20),
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