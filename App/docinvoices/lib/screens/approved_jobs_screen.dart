import 'package:flutter/material.dart';

import '../models/job.dart';
import '../services/job_repository.dart';

class ApprovedJobsScreen extends StatelessWidget {
  const ApprovedJobsScreen({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final bool isSpanish = languageCode == 'es';

    final approvedJobs = JobRepository.instance.jobs
        .where(
          (job) => job.approvalStatus == 'Approved',
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSpanish
              ? 'Trabajos aprobados'
              : 'Approved Jobs',
        ),
      ),
      body: approvedJobs.isEmpty
          ? Center(
              child: Text(
                isSpanish
                    ? 'No hay trabajos aprobados.'
                    : 'No approved jobs.',
              ),
            )
          : ListView.separated(
              itemCount: approvedJobs.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1),
              itemBuilder: (context, index) {
                final Job job = approvedJobs[index];

                return ListTile(
                  leading: const Icon(
                    Icons.verified,
                    color: Colors.green,
                  ),
                  title: Text(job.customerName),
                  subtitle: Text(
                    '${job.equipment}\n${job.approvalMethod}',
                  ),
                  isThreeLine: true,
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    // Next we'll open the invoice/job.
                  },
                );
              },
            ),
    );
  }
}