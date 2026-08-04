import 'dart:convert';

import 'package:http/http.dart' as http;

class VinLookupResult {
  const VinLookupResult({
    required this.year,
    required this.make,
    required this.model,
    required this.engineManufacturer,
    required this.engineModel,
    required this.vehicleType,
    required this.bodyClass,
    required this.fuelType,
    required this.gvwrClass,
  });

  final String year;
  final String make;
  final String model;
  final String engineManufacturer;
  final String engineModel;
  final String vehicleType;
  final String bodyClass;
  final String fuelType;
  final String gvwrClass;

  String get equipmentDescription {
    return [
      year,
      make,
      model,
    ].where((value) => value.trim().isNotEmpty).join(' ');
  }
}

class VinLookupService {
  VinLookupService._();

  static Future<VinLookupResult> lookupVin(
    String vin,
  ) async {
    final cleanedVin = vin
        .trim()
        .toUpperCase()
        .replaceAll(' ', '');

    if (cleanedVin.length != 17) {
      throw const FormatException(
        'VIN must contain 17 characters.',
      );
    }

    final uri = Uri.https(
      'vpic.nhtsa.dot.gov',
      '/api/vehicles/DecodeVinValuesExtended/$cleanedVin',
      {
        'format': 'json',
      },
    );

    final response = await http
        .get(uri)
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        'VIN lookup failed with status ${response.statusCode}.',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid VIN lookup response.',
      );
    }

    final results = decoded['Results'];

    if (results is! List || results.isEmpty) {
      throw const FormatException(
        'No vehicle information was found.',
      );
    }

    final vehicle = Map<String, dynamic>.from(
      results.first as Map,
    );

    final errorCode =
        (vehicle['ErrorCode'] ?? '').toString();

    if (errorCode.isNotEmpty &&
        errorCode != '0' &&
        !errorCode.startsWith('0,')) {
      final errorText =
          (vehicle['ErrorText'] ?? '').toString();

      throw FormatException(
        errorText.trim().isEmpty
            ? 'The VIN could not be decoded.'
            : errorText,
      );
    }

    return VinLookupResult(
      year: _value(vehicle, 'ModelYear'),
      make: _value(vehicle, 'Make'),
      model: _value(vehicle, 'Model'),
      engineManufacturer:
          _value(vehicle, 'EngineManufacturer'),
      engineModel: _value(vehicle, 'EngineModel'),
      vehicleType: _value(vehicle, 'VehicleType'),
      bodyClass: _value(vehicle, 'BodyClass'),
      fuelType: _value(vehicle, 'FuelTypePrimary'),
      gvwrClass: _value(vehicle, 'GVWR'),
    );
  }

  static String _value(
    Map<String, dynamic> data,
    String key,
  ) {
    final value = data[key]?.toString().trim() ?? '';

    if (value.toLowerCase() == 'not applicable' ||
        value.toLowerCase() == 'null') {
      return '';
    }

    return value;
  }
}