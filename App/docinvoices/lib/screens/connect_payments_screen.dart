import 'package:flutter/material.dart';

import 'dashboard_screen.dart';

class ConnectPaymentsScreen extends StatefulWidget {
  const ConnectPaymentsScreen({super.key});

  @override
  State<ConnectPaymentsScreen> createState() =>
      _ConnectPaymentsScreenState();
}

class _ConnectPaymentsScreenState extends State<ConnectPaymentsScreen> {
  String? selectedPayment;

  Widget _paymentCard(
    String title,
    IconData icon,
  ) {
    final bool isSelected = selectedPayment == title;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          setState(() {
            selectedPayment = title;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF1E252F),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? Colors.orange : Colors.white24,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.orange,
                size: 30,
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              Icon(
                isSelected
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: isSelected ? Colors.orange : Colors.white38,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _continueToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardScreen(),
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
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const Icon(
                    Icons.payments_outlined,
                    color: Colors.orange,
                    size: 70,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Connect Payments',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Choose how you would like to receive payments.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _paymentCard(
                    'Stripe',
                    Icons.credit_card_outlined,
                  ),
                  _paymentCard(
                    'Square',
                    Icons.point_of_sale_outlined,
                  ),
                  _paymentCard(
                    'Skip For Now',
                    Icons.arrow_forward_outlined,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed:
                          selectedPayment == null ? null : _continueToDashboard,
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