import 'package:flutter/material.dart';

import '../models/job.dart';
import '../services/job_repository.dart';
import 'review_work_screen.dart';

class ScheduledJobsScreen extends StatefulWidget {
  const ScheduledJobsScreen({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  @override
  State<ScheduledJobsScreen> createState() =>
      _ScheduledJobsScreenState();
}

class _ScheduledJobsScreenState
    extends State<ScheduledJobsScreen> {
  DateTime selectedDate = DateTime.now();

  bool get isSpanish =>
      widget.languageCode == 'es';

  bool _sameDay(
    DateTime a,
    DateTime b,
  ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  List<Job> get scheduledJobs {
    final jobs = JobRepository.instance.jobs
        .where(
          (job) => job.scheduledDateTime != null,
        )
        .toList();

    jobs.sort(
      (a, b) => a.scheduledDateTime!.compareTo(
        b.scheduledDateTime!,
      ),
    );

    return jobs;
  }

  List<Job> get selectedDayJobs {
    return scheduledJobs
        .where(
          (job) => _sameDay(
            job.scheduledDateTime!.toLocal(),
            selectedDate,
          ),
        )
        .toList();
  }

  String _formatTime(
    BuildContext context,
    DateTime date,
  ) {
    return TimeOfDay.fromDateTime(
      date.toLocal(),
    ).format(context);
  }

  @override
  Widget build(BuildContext context) {
    final jobs = scheduledJobs;
    final dayJobs = selectedDayJobs;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSpanish
              ? 'Trabajos programados'
              : 'Scheduled Jobs',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: CalendarDatePicker(
              initialDate: selectedDate,
              firstDate: DateTime(
                DateTime.now().year - 1,
              ),
              lastDate: DateTime(
                DateTime.now().year + 3,
              ),
              onDateChanged: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
          ),

          const SizedBox(height: 16),

          Text(
            isSpanish
                ? 'Trabajos para '
                    '${selectedDate.month}/'
                    '${selectedDate.day}/'
                    '${selectedDate.year}'
                : 'Jobs for '
                    '${selectedDate.month}/'
                    '${selectedDate.day}/'
                    '${selectedDate.year}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          if (jobs.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 32,
              ),
              child: Center(
                child: Text(
                  isSpanish
                      ? 'No hay trabajos programados.'
                      : 'No scheduled jobs yet.',
                ),
              ),
            )
          else if (dayJobs.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 32,
              ),
              child: Center(
                child: Text(
                  isSpanish
                      ? 'No hay trabajos para este día.'
                      : 'No jobs scheduled for this day.',
                ),
              ),
            )
          else
            ...dayJobs.map(
              (job) {
                final scheduledDate =
                    job.scheduledDateTime!;

                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.calendar_month_outlined,
                    ),
                    title: Text(
                      job.customerName,
                    ),
                    subtitle: Text(
                      [
                        if (job.equipment
                            .trim()
                            .isNotEmpty)
                          job.equipment,
                        if (job.unitNumber
                            .trim()
                            .isNotEmpty)
                          'Unit ${job.unitNumber}',
                        _formatTime(
                          context,
                          scheduledDate,
                        ),
                      ].join(' • '),
                    ),
                    trailing: job.reminderEnabled
                        ? const Icon(
                            Icons
                                .notifications_active_outlined,
                          )
                        : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ReviewWorkScreen(
                            languageCode:
                                widget.languageCode,
                            job: job,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}