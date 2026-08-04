import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/customer_repository.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({
    super.key,
    required this.languageCode,
    this.customer,
  });

  final String languageCode;
  final Customer? customer;

  @override
  State<CustomerScreen> createState() =>
      _CustomerScreenState();
}
    class _CustomerScreenState extends State<CustomerScreen> {
  bool get isEditing => widget.customer != null;

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
void initState() {
  super.initState();

  if (widget.customer != null) {
    final customer = widget.customer!;

    nameController.text = customer.name;
    companyController.text = customer.company;
    phoneController.text = customer.phone;
    emailController.text = customer.email;
    streetController.text = customer.street;
    cityController.text = customer.city;
    stateController.text = customer.state;
    zipController.text = customer.zip;
    notesController.text = customer.notes;

    isSpanishCustomer =
        customer.preferredLanguage == 'es';
  }
}
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

 Future<void> _saveCustomer() async {
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
if (isEditing) {
  await CustomerRepository.updateCustomer(
    widget.customer!,
    customer,
  );
} else {
  await CustomerRepository.addCustomer(customer);
}

if (!mounted) return;

Navigator.pop(context, customer);
  }

  @override
Widget build(BuildContext context) {
  final bool isSpanish =
      widget.languageCode == 'es';

  return Scaffold(
    appBar: AppBar(
     title: Text(
  isEditing
      ? (isSpanish ? 'Editar cliente' : 'Edit Customer')
      : (isSpanish ? 'Nuevo cliente' : 'New Customer'),
),
    ),
    body: Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            isSpanish
                ? 'Información del cliente'
                : 'Customer Information',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: isSpanish
                  ? 'Nombre del cliente *'
                  : 'Customer Name *',
            ),
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return isSpanish
                    ? 'Se requiere el nombre del cliente'
                    : 'Customer name is required';
              }
              return null;
            },
          ),

          TextFormField(
            controller: companyController,
            decoration: InputDecoration(
              labelText: isSpanish
                  ? 'Empresa'
                  : 'Company',
            ),
          ),

          TextFormField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: isSpanish
                  ? 'Teléfono'
                  : 'Phone',
            ),
          ),

          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: isSpanish
                  ? 'Correo electrónico'
                  : 'Email',
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
                    child: Text(
  isSpanish ? 'Cancelar' : 'Cancel',
),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveCustomer,
                    child: Text(
  isEditing
      ? (isSpanish ? 'Guardar cambios' : 'Save Changes')
      : (isSpanish ? 'Guardar cliente' : 'Save Customer'),
),
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