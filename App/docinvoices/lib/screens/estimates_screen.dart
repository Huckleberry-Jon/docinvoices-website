import 'package:flutter/material.dart';

import '../services/job_repository.dart';
import 'review_work_screen.dart';

class EstimatesScreen extends StatelessWidget {
  const EstimatesScreen({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final bool isSpanish = languageCode == 'es';

    final estimates = JobRepository.instance.activeJobs
        .where((job) => job.jobStatus == 'Estimate')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSpanish ? 'Cotizaciones' : 'Estimates',
        ),
      ),
      body: estimates.isEmpty
          ? Center(
              child: Text(
                isSpanish
                    ? 'No hay cotizaciones abiertas.'
                    : 'No open estimates.',
                style: const TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: estimates.length,
              itemBuilder: (context, index) {
                final job = estimates[index];

                return ListTile(
                  leading: const Icon(
                    Icons.description_outlined,
                    color: Colors.orange,
                  ),
                  title: Text(job.customerName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job.equipment),
                      if (job.unitNumber.trim().isNotEmpty)
                        Text(
                          isSpanish
                              ? 'Unidad: ${job.unitNumber}'
                              : 'Unit: ${job.unitNumber}',
                        ),
                      if (job.operations.isNotEmpty)
                        Text(job.operations.first.title),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReviewWorkScreen(
                          languageCode: languageCode,
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