import 'package:flutter/material.dart';

import '../models/job.dart';
import '../services/job_repository.dart';
import 'work_board_screen.dart';

class ReminderJobsScreen extends StatelessWidget {
  const ReminderJobsScreen({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final bool isSpanish = languageCode == 'es';

    final reminderJobs = JobRepository.instance.jobs
        .where(
          (job) =>
              job.reminderEnabled &&
              job.reminderDateTime != null,
        )
        .toList()
      ..sort(
        (a, b) => a.reminderDateTime!.compareTo(
          b.reminderDateTime!,
        ),
      );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSpanish
              ? 'Recordatorios'
              : 'Task Reminders',
        ),
      ),
      body: reminderJobs.isEmpty
          ? Center(
              child: Text(
                isSpanish
                    ? 'No hay recordatorios activos.'
                    : 'No active reminders.',
              ),
            )
          : ListView.separated(
              itemCount: reminderJobs.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1),
              itemBuilder: (context, index) {
                final Job job = reminderJobs[index];
                final DateTime reminder =
                    job.reminderDateTime!;

                final String date =
                    '${reminder.month}/'
                    '${reminder.day}/'
                    '${reminder.year}';

                final String time =
                    '${reminder.hour.toString().padLeft(2, '0')}:'
                    '${reminder.minute.toString().padLeft(2, '0')}';

                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Icon(
                      Icons.notifications_active_outlined,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(job.customerName),
                  subtitle: Text(
                    '${job.equipment}\n'
                    '$date • $time',
                  ),
                  isThreeLine: true,
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WorkBoardScreen(
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