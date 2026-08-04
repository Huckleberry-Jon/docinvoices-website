import 'package:flutter/material.dart';

import '../models/job.dart';
import '../services/job_repository.dart';
import 'payment_received_screen.dart';

class PaymentsHistoryScreen extends StatelessWidget {
  const PaymentsHistoryScreen({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final bool isSpanish = languageCode == 'es';

    final paidJobs = JobRepository.instance.jobs
        .where((job) => job.payments.isNotEmpty)
        .toList()
      ..sort(
        (a, b) => b.payments.last.date.compareTo(
          a.payments.last.date,
        ),
      );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSpanish
              ? 'Historial de pagos'
              : 'Payment History',
        ),
      ),
      body: paidJobs.isEmpty
          ? Center(
              child: Text(
                isSpanish
                    ? 'No hay pagos registrados.'
                    : 'No payments have been recorded.',
              ),
            )
          : ListView.separated(
              itemCount: paidJobs.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1),
              itemBuilder: (context, index) {
                final Job job = paidJobs[index];
                final payment =
                    job.payments.last;

                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.payments,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(job.customerName),
                  subtitle: Text(
                    '${job.invoiceNumber.isEmpty ? (isSpanish ? "Factura pendiente" : "Invoice Pending") : job.invoiceNumber}\n'
                    '\$${payment.amount.toStringAsFixed(2)} • ${payment.method}',
                  ),
                  isThreeLine: true,
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PaymentReceivedScreen(
                          languageCode:
                              languageCode,
                          job: job,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}