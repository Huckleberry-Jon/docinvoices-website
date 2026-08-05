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
  static Future<void> deleteCustomer(
  Customer customer,
) async {
  _customers.remove(customer);
  await _saveCustomers();
}
static Future<void> updateCustomer(
  Customer existingCustomer,
  Customer updatedCustomer,
) async {
  final int index = _customers.indexOf(existingCustomer);

  if (index == -1) {
    return;
  }

  _customers[index] = updatedCustomer;
  await _saveCustomers();
}
static String exportCustomers() {
  final customerData = _customers
      .map((customer) => customer.toJson())
      .toList();

  return jsonEncode(customerData);
}

static Future<void> importCustomers(
  String jsonText, {
  required bool replaceExisting,
}) async {
  final decoded = jsonDecode(jsonText);

  if (decoded is! List) {
    throw const FormatException(
      'Invalid customer backup file.',
    );
  }

  final importedCustomers = decoded
      .map(
        (item) => Customer.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
      .where(
        (customer) => customer.name.trim().isNotEmpty,
      )
      .toList();

  if (replaceExisting) {
    _customers
      ..clear()
      ..addAll(importedCustomers);
  } else {
    for (final importedCustomer in importedCustomers) {
      final duplicateExists = _customers.any(
        (existingCustomer) =>
            existingCustomer.name.trim().toLowerCase() ==
                importedCustomer.name.trim().toLowerCase() &&
            existingCustomer.phone.trim().toLowerCase() ==
                importedCustomer.phone.trim().toLowerCase() &&
            existingCustomer.email.trim().toLowerCase() ==
                importedCustomer.email.trim().toLowerCase(),
      );

      if (!duplicateExists) {
        _customers.add(importedCustomer);
      }
    }
  }

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