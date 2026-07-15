import 'package:flutter/material.dart';

import 'connect_payments_screen.dart';

class ChooseIndustryScreen extends StatefulWidget {
  const ChooseIndustryScreen({super.key});

  @override
  State<ChooseIndustryScreen> createState() =>
      _ChooseIndustryScreenState();
}

class _ChooseIndustryScreenState extends State<ChooseIndustryScreen> {
  final List<String> industries = [
    'Mechanic Repair',
    'Plumbing',
    'HVAC',
    'Electrical',
    'Lawn Care',
    'Handyman',
    'Construction',
    'Other',
  ];

  String? selectedIndustry;
  final TextEditingController otherController = TextEditingController();

  @override
  void dispose() {
    otherController.dispose();
    super.dispose();
  }

  void _continueToPayments() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ConnectPaymentsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool showOtherField = selectedIndustry == 'Other';

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
                    Icons.business_center_outlined,
                    color: Colors.orange,
                    size: 70,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'What type of work do you do?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Select the option that best describes your business.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ...industries.map((industry) {
                    final bool isSelected =
                        selectedIndustry == industry;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          setState(() {
                            selectedIndustry = industry;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1C22),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.orange
                                  : Colors.white24,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                color: isSelected
                                    ? Colors.orange
                                    : Colors.white54,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  industry,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  if (showOtherField) ...[
                    const SizedBox(height: 4),
                    TextField(
                      controller: otherController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'What type of work do you do?',
                        labelStyle: const TextStyle(
                          color: Colors.white70,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1E252F),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Colors.white30,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Colors.orange,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: selectedIndustry == null
                          ? null
                          : _continueToPayments,
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