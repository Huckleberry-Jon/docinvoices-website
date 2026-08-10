import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/customer_repository.dart';
import 'customer_screen.dart';
import 'customer_units_screen.dart';
class CustomerPickerScreen extends StatefulWidget {
  const CustomerPickerScreen({
  super.key,
  required this.languageCode,
  this.openUnitsOnTap = false,
});
final bool openUnitsOnTap;
  final String languageCode;

  @override
  State<CustomerPickerScreen> createState() =>
      _CustomerPickerScreenState();
}

class _CustomerPickerScreenState extends State<CustomerPickerScreen> {
  String searchText = '';
  
  bool get isSpanish => widget.languageCode == 'es';

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
        title: Text(
  isSpanish
      ? 'Seleccionar cliente'
      : 'Select Customer',
),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
             decoration: InputDecoration(
  labelText: isSpanish
      ? 'Buscar clientes'
      : 'Search Customers',
  prefixIcon: const Icon(Icons.search),
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
                ? Center(
  child: Text(
    isSpanish
        ? 'No se encontraron clientes.'
        : 'No customers found.',
  ),

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
  if (widget.openUnitsOnTap) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CustomerUnitsScreen(
          languageCode: widget.languageCode,
          customer: customer,
        ),
      ),
    );
  } else {
    Navigator.pop(context, customer);
  }
},

  trailing: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () async {
        final Customer? updatedCustomer =
            await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CustomerScreen(
              languageCode: widget.languageCode,
              customer: customer,
            ),
          ),
        );

        if (updatedCustomer == null) return;
        if (!mounted) return;

        setState(() {});
      },
    ),
    IconButton(
      icon: const Icon(
        Icons.delete_outline,
        color: Colors.redAccent,
      ),
      onPressed: () async {
        final bool? shouldDelete =
            await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: Text(
                widget.languageCode == 'es'
                    ? 'Eliminar cliente'
                    : 'Delete Customer',
              ),
              content: Text(
                widget.languageCode == 'es'
                    ? '¿Está seguro de que desea eliminar a ${customer.name}?'
                    : 'Are you sure you want to delete ${customer.name}?',
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.pop(dialogContext, false),
                  child: Text(
                    widget.languageCode == 'es'
                        ? 'Cancelar'
                        : 'Cancel',
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.pop(dialogContext, true),
                  child: Text(
                    widget.languageCode == 'es'
                        ? 'Eliminar'
                        : 'Delete',
                    style: const TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            );
          },
        );

        if (shouldDelete != true) return;

        await CustomerRepository.deleteCustomer(customer);

        if (!mounted) return;

        setState(() {});
      },
    ),
  ],
),
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
                  label: Text(
  widget.languageCode == 'es'
      ? 'Nuevo cliente'
      : 'New Customer',
),
                  onPressed: () async {
                    final Customer? customer =
                        await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CustomerScreen(
  languageCode: widget.languageCode,
),
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