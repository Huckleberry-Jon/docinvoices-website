import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/customer_repository.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final companyController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipController = TextEditingController();

  final notesController = TextEditingController();

bool isSpanishCustomer = false;
  @override
  void dispose() {
    nameController.dispose();
    companyController.dispose();
    phoneController.dispose();
    emailController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void _saveCustomer() {
    if (!_formKey.currentState!.validate()) return;

    final customer = Customer(
      name: nameController.text.trim(),
      company: companyController.text.trim(),
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
      street: streetController.text.trim(),
      city: cityController.text.trim(),
      state: stateController.text.trim(),
      zip: zipController.text.trim(),
      notes: notesController.text.trim(),
      preferredLanguage: isSpanishCustomer ? 'es' : 'en',
    );
CustomerRepository.addCustomer(customer);
    Navigator.pop(context, customer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Customer'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Customer Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Customer Name *',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Customer name is required';
                }
                return null;
              },
            ),

            TextFormField(
              controller: companyController,
              decoration: const InputDecoration(
                labelText: 'Company',
              ),
            ),

            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
              ),
            ),

            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
const SizedBox(height: 16),

SwitchListTile(
  contentPadding: EdgeInsets.zero,
  title: const Text('Preferred Language'),
  subtitle: Text(
    isSpanishCustomer ? 'Español' : 'English',
  ),
  value: isSpanishCustomer,
  onChanged: (value) {
    setState(() {
      isSpanishCustomer = value;
    });
  },
),
            const SizedBox(height: 24),

            const Text(
              'Address',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: streetController,
              decoration: const InputDecoration(
                labelText: 'Street',
              ),
            ),

            TextFormField(
              controller: cityController,
              decoration: const InputDecoration(
                labelText: 'City',
              ),
            ),

            TextFormField(
              controller: stateController,
              decoration: const InputDecoration(
                labelText: 'State',
              ),
            ),

            TextFormField(
              controller: zipController,
              decoration: const InputDecoration(
                labelText: 'ZIP Code',
              ),
            ),

            const SizedBox(height: 24),

            TextFormField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Customer Notes',
              ),
              maxLines: 4,
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveCustomer,
                    child: const Text('Save Customer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}