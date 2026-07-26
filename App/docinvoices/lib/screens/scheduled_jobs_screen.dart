import 'package:flutter/material.dart';
import '../services/job_repository.dart';
import 'review_work_screen.dart';
class ScheduledJobsScreen extends StatelessWidget {
  const ScheduledJobsScreen({
    super.key,
    required this.languageCode,
    
  });

  final String languageCode;
  

  @override
  Widget build(BuildContext context) {
    final isSpanish = languageCode == 'es';

    final scheduledJobs = JobRepository.instance.jobs
        .where((job) => job.scheduledDateTime != null)
        .toList()
      ..sort(
        (a, b) => a.scheduledDateTime!.compareTo(
          b.scheduledDateTime!,
        ),
      );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSpanish
              ? 'Trabajos programados'
              : 'Scheduled Jobs',
        ),
      ),
      body: scheduledJobs.isEmpty
          ? Center(
              child: Text(
                isSpanish
                    ? 'No hay trabajos programados.'
                    : 'No scheduled jobs yet.',
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: scheduledJobs.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
               itemBuilder: (context, index) {
                final job = scheduledJobs[index];
                final scheduledDate = job.scheduledDateTime!;

                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.calendar_month_outlined,
                    ),
                    title: Text(job.customerName),
                    subtitle: Text(
                      '${job.equipment}\n'
                      '${scheduledDate.toLocal()}',
                    ),
                    isThreeLine: true,
                    trailing: job.reminderEnabled
                        ? const Icon(
                            Icons.notifications_active_outlined,
                          )
                        : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewWorkScreen(
                            languageCode: languageCode,
                            job: job,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}