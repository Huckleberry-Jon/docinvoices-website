import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/customer.dart';

class CustomerRepository {
  CustomerRepository._();

  static const String _storageKey = 'customers';

  static final List<Customer> _customers = [];

  static List<Customer> get customers =>
      List.unmodifiable(_customers);

  static Future<void> loadCustomers() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCustomers = prefs.getStringList(_storageKey) ?? [];

    _customers
      ..clear()
      ..addAll(
        savedCustomers.map(
          (item) => Customer.fromJson(
            jsonDecode(item) as Map<String, dynamic>,
          ),
        ),
      );
  }

  static Future<void> addCustomer(Customer customer) async {
    _customers.add(customer);
    await _saveCustomers();
  }

  static Future<void> _saveCustomers() async {
    final prefs = await SharedPreferences.getInstance();

    final encodedCustomers = _customers
        .map(
          (customer) => jsonEncode(
            customer.toJson(),
          ),
        )
        .toList();

    await prefs.setStringList(
      _storageKey,
      encodedCustomers,
    );
  }
}