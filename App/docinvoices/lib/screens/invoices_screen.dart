import 'package:flutter/material.dart';
import '../models/invoice.dart';
import '../services/invoice_repository.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  String selectedStatus = 'All';
  String searchText = '';

  bool get isSpanish => widget.languageCode == 'es';

  

  List<Invoice> get filteredInvoices {
  final invoices = InvoiceRepository.instance.invoices;

  return invoices.where((invoice) {
    final matchesStatus =
        selectedStatus == 'All' || invoice.status == selectedStatus;

    final search = searchText.toLowerCase();

    final matchesSearch =
        invoice.customerName.toLowerCase().contains(search) ||
        invoice.invoiceNumber.toLowerCase().contains(search);

    return matchesStatus && matchesSearch;
  }).toList();
}

  @override
  Widget build(BuildContext context) {
    final statuses = ['All', 'Draft', 'Sent', 'Paid', 'Overdue'];
  


    return Scaffold(
      backgroundColor: const Color(0xFF050B13),
      appBar: AppBar(
        backgroundColor: const Color(0xFF07111D),
        foregroundColor: Colors.white,
        title: Text(
          isSpanish ? 'Facturas' : 'Invoices',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: isSpanish
                      ? 'Buscar cliente o factura'
                      : 'Search customer or invoice',
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white70,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF07111D),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: statuses.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final status = statuses[index];
                  final selected = selectedStatus == status;

                  return ChoiceChip(
                    label: Text(_translatedStatus(status)),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        selectedStatus = status;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filteredInvoices.isEmpty
                  ? Center(
                      child: Text(
                        isSpanish
                            ? 'No se encontraron facturas.'
                            : 'No invoices found.',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: filteredInvoices.length,
                      itemBuilder: (context, index) {
                        final invoice = filteredInvoices[index];

                        return _invoiceCard(invoice);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

 Widget _invoiceCard(Invoice invoice) {
    final status = invoice.status;
final total = invoice.total;
final balance = invoice.balance;

    return Card(
      color: const Color(0xFF07111D),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: _statusColor(status).withValues(alpha: 0.55),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${invoice.invoiceNumber} selected',
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
  invoice.customerName,
  style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(status).withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _translatedStatus(status),
                      style: TextStyle(
                        color: _statusColor(status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                invoice.invoiceNumber,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
 
                _formatDate(invoice.createdDate),
                style: const TextStyle(
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _moneyColumn(
                      isSpanish ? 'Total' : 'Total',
                      total,
                    ),
                  ),
                  Expanded(
                    child: _moneyColumn(
                      isSpanish ? 'Saldo' : 'Balance',
                      balance,
                      
                      
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _moneyColumn(String label, double amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _translatedStatus(String status) {
    if (!isSpanish) {
      return status;
    }

    switch (status) {
      case 'All':
        return 'Todas';
      case 'Draft':
        return 'Borrador';
      case 'Sent':
        return 'Enviada';
      case 'Paid':
        return 'Pagada';
      case 'Overdue':
        return 'Vencida';
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Draft':
        return Colors.blue;
      case 'Sent':
        return Colors.orange;
      case 'Paid':
        return Colors.green;
      case 'Overdue':
        return Colors.redAccent;
      default:
        return Colors.white70;
    }
  }

String _formatDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');

  return '$month/$day/${date.year}';
}
}