import 'package:flutter/material.dart';

import '../services/job_repository.dart';
import 'customer_invoice_screen.dart';

class InvoicesWaitingScreen extends StatefulWidget {
  const InvoicesWaitingScreen({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  @override
  State<InvoicesWaitingScreen> createState() =>
      _InvoicesWaitingScreenState();
}

class _InvoicesWaitingScreenState
    extends State<InvoicesWaitingScreen> {
  bool get isSpanish => widget.languageCode == 'es';

  @override
  Widget build(BuildContext context) {
    final waitingInvoices =
        JobRepository.instance.invoicesWaiting;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSpanish
              ? 'Facturas pendientes'
              : 'Invoices Waiting',
        ),
      ),
      body: waitingInvoices.isEmpty
          ? Center(
              child: Text(
                isSpanish
                    ? 'No hay facturas pendientes.'
                    : 'No invoices waiting.',
                style: const TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: waitingInvoices.length,
              itemBuilder: (context, index) {
                final job = waitingInvoices[index];

                return ListTile(
                  leading: const Icon(
                    Icons.receipt_long_outlined,
                    color: Colors.orange,
                  ),
                  title: Text(job.customerName),
                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      if (job.invoiceNumber.trim().isNotEmpty)
                        Text(
                          isSpanish
                              ? 'Factura #${job.invoiceNumber}'
                              : 'Invoice #${job.invoiceNumber}',
                        ),
                      if (job.equipment.trim().isNotEmpty)
                        Text(job.equipment),
                      const SizedBox(height: 4),
                      Text(
                        isSpanish
                            ? 'Saldo: \$${job.balanceDue.toStringAsFixed(2)}'
                            : 'Balance: \$${job.balanceDue.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CustomerInvoiceScreen(
                          languageCode:
                              widget.languageCode,
                          job: job,
                        ),
                      ),
                    );

                    if (mounted) {
                      setState(() {});
                    }
                  },
                );
              },
            ),
    );
  }
}