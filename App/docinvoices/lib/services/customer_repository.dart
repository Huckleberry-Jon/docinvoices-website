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
    final savedCustomers =
        prefs.getStringList(_storageKey) ?? [];

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

  static Future<void> addCustomer(
    Customer customer,
  ) async {
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
    final int index =
        _customers.indexOf(existingCustomer);

    if (index == -1) {
      return;
    }

    _customers[index] = updatedCustomer;
    await _saveCustomers();
  }

  // --------------------------------------------------
  // JSON EXPORT
  // --------------------------------------------------

  static String exportCustomers() {
    final customerData = _customers
        .map((customer) => customer.toJson())
        .toList();

    return jsonEncode(customerData);
  }

  // --------------------------------------------------
  // JSON IMPORT
  // --------------------------------------------------

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
          (customer) =>
              customer.name.trim().isNotEmpty,
        )
        .toList();

    await _applyImportedCustomers(
      importedCustomers,
      replaceExisting: replaceExisting,
    );
  }

  // --------------------------------------------------
  // CSV IMPORT
  // --------------------------------------------------

  static Future<int> importCustomersCsv(
    String csvText, {
    required bool replaceExisting,
  }) async {
    final rows = _parseCsv(csvText);

    if (rows.length < 2) {
      throw const FormatException(
        'The CSV file does not contain customer data.',
      );
    }

    final headers = rows.first
        .map(_normalizeHeader)
        .toList();

    final importedCustomers = <Customer>[];

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];

      if (row.every(
        (value) => value.trim().isEmpty,
      )) {
        continue;
      }

      String valueFor(List<String> possibleHeaders) {
        for (final possible in possibleHeaders) {
          final index = headers.indexOf(
            _normalizeHeader(possible),
          );

          if (index >= 0 && index < row.length) {
            final value = row[index].trim();

            if (value.isNotEmpty) {
              return value;
            }
          }
        }

        return '';
      }

      String name = valueFor([
        'name',
        'customer name',
        'contact name',
        'full name',
        'display name',
      ]);

      // Google Contacts often exports first/last name separately.
      if (name.isEmpty) {
        final firstName = valueFor([
          'first name',
          'given name',
        ]);

        final lastName = valueFor([
          'last name',
          'family name',
          'surname',
        ]);

        name = '$firstName $lastName'.trim();
      }

      final company = valueFor([
        'company',
        'company name',
        'organization',
        'organization name',
        'business',
        'business name',
      ]);

      final phone = valueFor([
        'phone',
        'phone number',
        'mobile',
        'mobile phone',
        'cell',
        'cell phone',
        'telephone',
        'phone 1 - value',
        'phone 1 value',
        'primary phone',
      ]);

      final email = valueFor([
        'email',
        'email address',
        'e-mail',
        'e-mail address',
        'e-mail 1 - value',
        'email 1 - value',
        'primary email',
      ]);

      final street = valueFor([
        'street',
        'street address',
        'address',
        'address 1',
        'address 1 - street',
      ]);

      final city = valueFor([
        'city',
        'address 1 - city',
      ]);

      final state = valueFor([
        'state',
        'province',
        'region',
        'address 1 - region',
      ]);

      final zip = valueFor([
        'zip',
        'zipcode',
        'zip code',
        'postal',
        'postal code',
        'address 1 - postal code',
      ]);

      final notes = valueFor([
        'notes',
        'note',
        'comments',
      ]);

      // We need either a person's name or a company.
      if (name.isEmpty && company.isEmpty) {
        continue;
      }

      // If this is a company-only contact, use company as
      // the display name so it can still appear in DocInvoices.
      if (name.isEmpty) {
        name = company;
      }

      importedCustomers.add(
        Customer(
          name: name,
          company: company,
          phone: phone,
          email: email,
          street: street,
          city: city,
          state: state,
          zip: zip,
          notes: notes,
          preferredLanguage: 'en',
        ),
      );
    }

    if (importedCustomers.isEmpty) {
      throw const FormatException(
        'No customers could be found in the CSV file.',
      );
    }

    final beforeCount = _customers.length;

    await _applyImportedCustomers(
      importedCustomers,
      replaceExisting: replaceExisting,
    );

    if (replaceExisting) {
      return _customers.length;
    }

    return _customers.length - beforeCount;
  }

  // --------------------------------------------------
  // APPLY IMPORT / DUPLICATE CHECK
  // --------------------------------------------------

  static Future<void> _applyImportedCustomers(
    List<Customer> importedCustomers, {
    required bool replaceExisting,
  }) async {
    if (replaceExisting) {
      _customers
        ..clear()
        ..addAll(importedCustomers);
    } else {
      for (final importedCustomer
          in importedCustomers) {
        final duplicateExists = _customers.any(
          (existingCustomer) =>
              _isDuplicate(
                existingCustomer,
                importedCustomer,
              ),
        );

        if (!duplicateExists) {
          _customers.add(importedCustomer);
        }
      }
    }

    await _saveCustomers();
  }

  static bool _isDuplicate(
    Customer existing,
    Customer incoming,
  ) {
    final existingName =
        existing.name.trim().toLowerCase();
    final incomingName =
        incoming.name.trim().toLowerCase();

    final existingPhone =
        existing.phone.trim().toLowerCase();
    final incomingPhone =
        incoming.phone.trim().toLowerCase();

    final existingEmail =
        existing.email.trim().toLowerCase();
    final incomingEmail =
        incoming.email.trim().toLowerCase();

    // Same email = duplicate.
    if (existingEmail.isNotEmpty &&
        incomingEmail.isNotEmpty &&
        existingEmail == incomingEmail) {
      return true;
    }

    // Same phone = duplicate.
    if (existingPhone.isNotEmpty &&
        incomingPhone.isNotEmpty &&
        existingPhone == incomingPhone) {
      return true;
    }

    // Same name + matching phone/email.
    return existingName == incomingName &&
        existingPhone == incomingPhone &&
        existingEmail == incomingEmail;
  }

  // --------------------------------------------------
  // SIMPLE CSV PARSER
  // Handles commas inside quoted values.
  // --------------------------------------------------

  static List<List<String>> _parseCsv(
    String text,
  ) {
    final rows = <List<String>>[];
    var row = <String>[];
    var field = StringBuffer();
    var insideQuotes = false;

    for (int i = 0; i < text.length; i++) {
      final char = text[i];

      if (char == '"') {
        if (insideQuotes &&
            i + 1 < text.length &&
            text[i + 1] == '"') {
          field.write('"');
          i++;
        } else {
          insideQuotes = !insideQuotes;
        }
      } else if (char == ',' && !insideQuotes) {
        row.add(field.toString());
        field = StringBuffer();
      } else if ((char == '\n' || char == '\r') &&
          !insideQuotes) {
        if (char == '\r' &&
            i + 1 < text.length &&
            text[i + 1] == '\n') {
          i++;
        }

        row.add(field.toString());
        field = StringBuffer();

        if (row.any(
          (value) => value.trim().isNotEmpty,
        )) {
          rows.add(row);
        }

        row = <String>[];
      } else {
        field.write(char);
      }
    }

    row.add(field.toString());

    if (row.any(
      (value) => value.trim().isNotEmpty,
    )) {
      rows.add(row);
    }

    return rows;
  }

  static String _normalizeHeader(
    String value,
  ) {
    return value
        .replaceAll('\ufeff', '')
        .trim()
        .toLowerCase();
  }

  // --------------------------------------------------
  // SAVE
  // --------------------------------------------------

  static Future<void> _saveCustomers() async {
    final prefs =
        await SharedPreferences.getInstance();

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