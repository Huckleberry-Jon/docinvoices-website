import 'package:flutter/material.dart';
import 'job_history_screen.dart';
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

  void _openReport(
    BuildContext context, {
    required String title,
    required List<Job> jobs,
    String? summary,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _ReportDetailsScreen(
          languageCode: languageCode,
          title: title,
          jobs: jobs,
          summary: summary,
        ),
      ),
    );
  }

  Widget _reportCard({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
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
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobs = JobRepository.instance.jobs;

    final paidJobs = jobs.where(_isPaid).toList();

    final invoicedJobs = jobs
        .where(
          (job) => job.invoiceNumber.trim().isNotEmpty,
        )
        .toList();

    final outstandingJobs = jobs
        .where(
          (job) =>
              job.invoiceNumber.trim().isNotEmpty &&
              !_isPaid(job),
        )
        .toList();

    final scheduledJobList = jobs
        .where(
          (job) => job.scheduledDateTime != null,
        )
        .toList();

    final jobsInProgressList =
        jobs.where(_isInProgress).toList();

    final totalRevenue = paidJobs.fold<double>(
      0,
      (total, job) =>
          total + _moneyValue(job.estimatedTotal),
    );

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
            onTap: () {
              _openReport(
                context,
                title: isSpanish
                    ? 'Ingresos totales'
                    : 'Total Revenue',
                jobs: paidJobs,
                summary:
                    '\$${totalRevenue.toStringAsFixed(2)}',
              );
            },
          ),
          const SizedBox(height: 10),
          _reportCard(
  icon: Icons.history,
  title: isSpanish
      ? 'Historial de trabajos'
      : 'Job History',
  value: jobs
      .where((job) => job.invoiceNumber.trim().isNotEmpty)
      .length
      .toString(),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JobHistoryScreen(
          languageCode: languageCode,
          onlyCompleted: true,
        ),
      ),
    );
  },
),
          _reportCard(
            icon: Icons.receipt_long_outlined,
            title: isSpanish
                ? 'Facturas totales'
                : 'Total Invoices',
            value: invoicedJobs.length.toString(),
            onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => JobHistoryScreen(
        languageCode: languageCode,
      ),
    ),
  );
},
          ),
          const SizedBox(height: 10),
          _reportCard(
            icon: Icons.check_circle_outline,
            title: isSpanish
                ? 'Facturas pagadas'
                : 'Paid Invoices',
            value: paidJobs.length.toString(),
            onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => JobHistoryScreen(
        languageCode: languageCode,
        onlyPaid: true,
      ),
    ),
  );
},
          ),
          const SizedBox(height: 10),
          _reportCard(
            icon: Icons.pending_actions_outlined,
            title: isSpanish
                ? 'Facturas pendientes'
                : 'Outstanding Invoices',
            value: outstandingJobs.length.toString(),
           onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => JobHistoryScreen(
        languageCode: languageCode,
        onlyOutstanding: true,
      ),
    ),
  );
},
          ),
          const SizedBox(height: 10),
          _reportCard(
            icon: Icons.calendar_month_outlined,
            title: isSpanish
                ? 'Trabajos programados'
                : 'Scheduled Jobs',
            value: scheduledJobList.length.toString(),
            onTap: () {
              _openReport(
                context,
                title: isSpanish
                    ? 'Trabajos programados'
                    : 'Scheduled Jobs',
                jobs: scheduledJobList,
              );
            },
          ),
          const SizedBox(height: 10),
          _reportCard(
            icon: Icons.build_outlined,
            title: isSpanish
                ? 'Trabajos en progreso'
                : 'Jobs In Progress',
            value: jobsInProgressList.length.toString(),
            onTap: () {
              _openReport(
                context,
                title: isSpanish
                    ? 'Trabajos en progreso'
                    : 'Jobs In Progress',
                jobs: jobsInProgressList,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ReportDetailsScreen extends StatelessWidget {
  const _ReportDetailsScreen({
    required this.languageCode,
    required this.title,
    required this.jobs,
    this.summary,
  });

  final String languageCode;
  final String title;
  final List<Job> jobs;
  final String? summary;

  bool get isSpanish => languageCode == 'es';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: jobs.isEmpty
          ? Center(
              child: Text(
                isSpanish
                    ? 'No hay registros para este reporte.'
                    : 'No records found for this report.',
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (summary != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            isSpanish
                                ? 'Total'
                                : 'Report Total',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            summary!,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                ...jobs.map(
                  (job) => Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(
                          Icons.description_outlined,
                        ),
                      ),
                      title: Text(
                        job.customerName.trim().isEmpty
                            ? (isSpanish
                                ? 'Cliente sin nombre'
                                : 'Unnamed Customer')
                            : job.customerName,
                      ),
                      subtitle: Text(
                        [
                          if (job.equipment.trim().isNotEmpty)
                            job.equipment,
                          if (job.invoiceNumber.trim().isNotEmpty)
                            '${isSpanish ? 'Factura' : 'Invoice'} '
                                '${job.invoiceNumber}',
                          job.jobStatus,
                        ].join(' • '),
                      ),
                      trailing: Text(
                        job.estimatedTotal.trim().isEmpty
                            ? '\$0.00'
                            : '\$${job.estimatedTotal.replaceAll('\$', '')}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}