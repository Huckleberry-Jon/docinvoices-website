import 'package:flutter/material.dart';

import '../models/customer.dart';
import '../models/customer_unit.dart';
import '../services/customer_unit_repository.dart';

class CustomerUnitsScreen extends StatefulWidget {
  const CustomerUnitsScreen({
    super.key,
    required this.languageCode,
    required this.customer,
  });

  final String languageCode;
  final Customer customer;

  @override
  State<CustomerUnitsScreen> createState() =>
      _CustomerUnitsScreenState();
}

class _CustomerUnitsScreenState
    extends State<CustomerUnitsScreen> {
  bool get isSpanish => widget.languageCode == 'es';

  List<CustomerUnit> get customerUnits {
    return CustomerUnitRepository.units
        .where(
          (unit) =>
              unit.customerName.trim().toLowerCase() ==
              widget.customer.name.trim().toLowerCase(),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final units = customerUnits;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSpanish
              ? 'Unidades - ${widget.customer.name}'
              : 'Units - ${widget.customer.name}',
        ),
      ),
      body: units.isEmpty
          ? Center(
              child: Text(
                isSpanish
                    ? 'Este cliente no tiene unidades guardadas.'
                    : 'This customer has no saved units.',
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: units.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final unit = units[index];

                final equipment = [
                  unit.year,
                  unit.make,
                  unit.model,
                ].where((value) => value.trim().isNotEmpty).join(' ');

                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.local_shipping_outlined,
                    ),
                    title: Text(
                      unit.unitNumber.isNotEmpty
                          ? 'Unit ${unit.unitNumber}'
                          : (unit.vin.isNotEmpty
                              ? unit.vin
                              : 'Unit'),
                    ),
                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        if (equipment.isNotEmpty)
                          Text(equipment),
                        if (unit.vin.isNotEmpty)
                          Text('VIN: ${unit.vin}'),
                        if (unit.mileage.isNotEmpty)
                          Text('Mileage: ${unit.mileage}'),
                        if (unit.esn.isNotEmpty)
                          Text('ESN: ${unit.esn}'),
                        if (unit.tsn.isNotEmpty)
                          Text('TSN: ${unit.tsn}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}