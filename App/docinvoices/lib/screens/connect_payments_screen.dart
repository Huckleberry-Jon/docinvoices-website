import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'subscription_screen.dart';

class ConnectPaymentsScreen extends StatefulWidget {
  const ConnectPaymentsScreen({
    
    super.key,
    required this.languageCode,
  });

  final String languageCode;

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

 Future<void> _continueToSubscription() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setBool(
    'setupComplete',
    true,
  );

  await prefs.setString(
    'languageCode',
    widget.languageCode,
  );

  if (!mounted) return;

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => SubscriptionScreen(
        languageCode: widget.languageCode,
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final bool isSpanish = widget.languageCode == 'es';
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
                  Text(
                     isSpanish
                     ? 'Conectar pagos'
                      : 'Connect Payments',
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
      ? 'Elija cómo desea recibir los pagos.'
      : 'Choose how you would like to receive payments.',
  textAlign: TextAlign.center,
  style: const TextStyle(
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
  isSpanish ? 'Omitir por ahora' : 'Skip For Now',
  Icons.arrow_forward_outlined,
),
const SizedBox(height: 30),
SizedBox(
  height: 60,
  child: ElevatedButton(
    onPressed:
    selectedPayment == null ? null : _continueToSubscription,
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