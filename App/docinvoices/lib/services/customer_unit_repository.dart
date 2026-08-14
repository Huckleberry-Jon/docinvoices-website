import 'dart:convert';
import '../models/customer.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../services/customer_repository.dart';
import '../models/customer_unit.dart';

class CustomerUnitRepository {
  CustomerUnitRepository._();

  static const String _storageKey = 'customer_units';

  static final List<CustomerUnit> _units = [];

  static List<CustomerUnit> get units =>
      List.unmodifiable(_units);

  static Future<void> loadUnits() async {
    final prefs = await SharedPreferences.getInstance();

    final savedUnits =
        prefs.getStringList(_storageKey) ?? [];

    _units
      ..clear()
      ..addAll(
        savedUnits.map(
          (item) => CustomerUnit.fromJson(
            jsonDecode(item) as Map<String, dynamic>,
          ),
        ),
      );
  }

  static Future<void> addUnit(
    CustomerUnit unit,
  ) async {
    _units.add(unit);
    await _saveUnits();
  }

  static Future<void> deleteUnit(
    CustomerUnit unit,
  ) async {
    _units.remove(unit);
    await _saveUnits();
  }

  static Future<void> updateUnit(
    CustomerUnit existingUnit,
    CustomerUnit updatedUnit,
  ) async {
    final index = _units.indexOf(existingUnit);

    if (index == -1) {
      return;
    }

    _units[index] = updatedUnit;

    await _saveUnits();
  }

  static Future<void> replaceAll(
    List<CustomerUnit> units,
  ) async {
    _units
      ..clear()
      ..addAll(units);

    await _saveUnits();
  }

  static Future<void> mergeUnits(
    List<CustomerUnit> units,
  ) async {
    for (final incoming in units) {
      final duplicateExists = _units.any(
        (existing) =>
            existing.vin.trim().isNotEmpty &&
            incoming.vin.trim().isNotEmpty &&
            existing.vin.trim().toLowerCase() ==
                incoming.vin.trim().toLowerCase(),
      );

      if (!duplicateExists) {
        _units.add(incoming);
      }
    }

    await _saveUnits();
  }
static Future<int> importUnitsCsv(
  String csvText, {
  required bool replaceExisting,
}) async {
  final rows = _parseCsv(csvText);

  if (rows.length < 2) {
    throw const FormatException(
      'The CSV file does not contain unit data.',
    );
  }

  final headers = rows.first
      .map(_normalizeHeader)
      .toList();

  final importedUnits = <CustomerUnit>[];

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

    final customerName = valueFor([
      'customer',
      'customer name',
      'company',
      'company name',
    ]);
Customer? matchedCustomer;

for (final customer in CustomerRepository.customers) {
  final searchName = customerName.trim().toLowerCase();

  if (customer.name.trim().toLowerCase() == searchName ||
      customer.company.trim().toLowerCase() == searchName) {
    matchedCustomer = customer;
    break;
  }
}
    final unitNumber = valueFor([
  'number',
  'unit',
  'unit number',
  'unit #',
  'fleet #',
  'fleet number',
  'nickname',
  'unit external id',
]);

   final vin = valueFor([
  'vin',
  'serial # / vin',
  'serial/vin',
  'serial number',
  'serial #',
  'serial # / serial# / vin',
]);

    final year = valueFor([
      'year',
      'chassis year',
      'model year',
    ]);

    final make = valueFor([
      'make',
      'chassis make',
      'manufacturer',
    ]);

    final model = valueFor([
      'model',
      'chassis model',
    ]);

    final mileage = valueFor([
      'mileage',
      'odometer',
      'miles',
    ]);

    final esn = valueFor([
      'esn',
      'engine serial',
      'engine serial #',
      'engine serial number',
    ]);

    final tsn = valueFor([
      'tsn',
      'transmission serial',
      'transmission serial #',
      'transmission serial number',
    ]);

    if (customerName.isEmpty &&
        unitNumber.isEmpty &&
        vin.isEmpty) {
      continue;
    }

    importedUnits.add(
      CustomerUnit(
  customerId: matchedCustomer?.id ?? '',
  customerName: customerName,
        unitNumber: unitNumber,
        vin: vin,
        year: year,
        make: make,
        model: model,
        mileage: mileage,
        esn: esn,
        tsn: tsn,
      ),
    );
  }

  if (importedUnits.isEmpty) {
    throw const FormatException(
      'No units could be found in the CSV file.',
    );
  }

  if (replaceExisting) {
    await replaceAll(importedUnits);
  } else {
    await mergeUnits(importedUnits);
  }

 return importedUnits.length;
}

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

static Future<void> _saveUnits() async {
  final prefs =
      await SharedPreferences.getInstance();

  final encodedUnits = _units
      .map(
        (unit) => jsonEncode(
          unit.toJson(),
        ),
      )
      .toList();

  await prefs.setStringList(
    _storageKey,
    encodedUnits,
  );
}
}