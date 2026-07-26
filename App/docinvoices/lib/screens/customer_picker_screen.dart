import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/customer_repository.dart';
import 'customer_screen.dart';

class CustomerPickerScreen extends StatefulWidget {
  const CustomerPickerScreen({super.key});

  @override
  State<CustomerPickerScreen> createState() =>
      _CustomerPickerScreenState();
}

class _CustomerPickerScreenState extends State<CustomerPickerScreen> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final customers = CustomerRepository.customers.where((customer) {
      final search = searchText.toLowerCase();

      return customer.name.toLowerCase().contains(search) ||
          customer.company.toLowerCase().contains(search) ||
          customer.phone.toLowerCase().contains(search);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Customer'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Customers',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.trim();
                });
              },
            ),
          ),

          Expanded(
            child: customers.isEmpty
                ? const Center(
                    child: Text('No customers found'),
                  )
                : ListView.separated(
                    itemCount: customers.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final customer = customers[index];

                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(customer.name),
                        subtitle: customer.company.isEmpty
                            ? null
                            : Text(customer.company),
                        onTap: () {
                          Navigator.pop(context, customer);
                        },
                      );
                    },
                  ),
          ),

          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.person_add),
                  label: const Text('Search Customer'),
                  onPressed: () async {
                    final Customer? customer =
                        await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CustomerScreen(),
                      ),
                    );

                    if (customer == null) return;
if (!context.mounted) return;

Navigator.pop(context, customer);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}