import 'package:flutter/material.dart';

import '../models/job.dart';
import '../services/job_repository.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  bool get isSpanish => languageCode == 'es';

  double _moneyValue(String value) {
    final cleanedValue = value.replaceAll(
      RegExp(r'[^0-9.-]'),
      '',
    );

    return double.tryParse(cleanedValue) ?? 0;
  }

  bool _isPaid(Job job) {
    final status = job.jobStatus.toLowerCase();

    return status.contains('paid') ||
        status.contains('payment received') ||
        status.contains('pagado') ||
        status.contains('pago recibido');
  }

  bool _isInProgress(Job job) {
    final status = job.jobStatus.toLowerCase();

    return status.contains('in progress') ||
        status.contains('en progreso');
  }

  Widget _reportCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              child: Icon(
                icon,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobs = JobRepository.instance.jobs;

    final paidJobs = jobs.where(_isPaid).toList();

    final totalRevenue = paidJobs.fold<double>(
      0,
      (total, job) => total + _moneyValue(job.estimatedTotal),
    );

    final totalInvoices = jobs
        .where(
          (job) => job.invoiceNumber.trim().isNotEmpty,
        )
        .length;

    final paidInvoices = jobs.where(_isPaid).length;

    final outstandingInvoices = jobs
        .where(
          (job) =>
              job.invoiceNumber.trim().isNotEmpty &&
              !_isPaid(job),
        )
        .length;

    final scheduledJobs = jobs
        .where(
          (job) => job.scheduledDateTime != null,
        )
        .length;

    final jobsInProgress = jobs.where(_isInProgress).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSpanish ? 'Reportes' : 'Reports',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _reportCard(
            icon: Icons.attach_money,
            title: isSpanish
                ? 'Ingresos totales'
                : 'Total Revenue',
            value: '\$${totalRevenue.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 10),
          _reportCard(
            icon: Icons.receipt_long_outlined,
            title: isSpanish
                ? 'Facturas totales'
                : 'Total Invoices',
            value: totalInvoices.toString(),
          ),
          const SizedBox(height: 10),
          _reportCard(
            icon: Icons.check_circle_outline,
            title: isSpanish
                ? 'Facturas pagadas'
                : 'Paid Invoices',
            value: paidInvoices.toString(),
          ),
          const SizedBox(height: 10),
          _reportCard(
            icon: Icons.pending_actions_outlined,
            title: isSpanish
                ? 'Facturas pendientes'
                : 'Outstanding Invoices',
            value: outstandingInvoices.toString(),
          ),
          const SizedBox(height: 10),
          _reportCard(
            icon: Icons.calendar_month_outlined,
            title: isSpanish
                ? 'Trabajos programados'
                : 'Scheduled Jobs',
            value: scheduledJobs.toString(),
          ),
          const SizedBox(height: 10),
          _reportCard(
            icon: Icons.build_outlined,
            title: isSpanish
                ? 'Trabajos en progreso'
                : 'Jobs In Progress',
            value: jobsInProgress.toString(),
          ),
        ],
      ),
    );
  }
}