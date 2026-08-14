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
Future<void> _addTaskForSelectedDate() async {
  final titleController = TextEditingController();
  final notesController = TextEditingController();

  TimeOfDay selectedTime = TimeOfDay.now();

  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(
              isSpanish
                  ? 'Agregar tarea'
                  : 'Add Task',
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: isSpanish
                        ? 'Tarea'
                        : 'Task',
                    hintText: isSpanish
                        ? 'Ej. Recoger piezas'
                        : 'Example: Pick up parts',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: isSpanish
                        ? 'Notas'
                        : 'Notes',
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.access_time,
                  ),
                  title: Text(
                    selectedTime.format(context),
                  ),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );

                    if (picked != null) {
                      setDialogState(() {
                        selectedTime = picked;
                      });
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(
                    dialogContext,
                    false,
                  );
                },
                child: Text(
                  isSpanish
                      ? 'Cancelar'
                      : 'Cancel',
                ),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(
                    dialogContext,
                    true,
                  );
                },
                child: Text(
                  isSpanish
                      ? 'Guardar'
                      : 'Save',
                ),
              ),
            ],
          );
        },
      );
    },
  );

  if (result != true) return;

  final title = titleController.text.trim();

  if (title.isEmpty) return;

  final scheduledDateTime = DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    selectedTime.hour,
    selectedTime.minute,
  );

  final task = Job(
    location: '',
    customerPhone: '',
    customerEmail: '',
    customerName: title,
    equipment: 'TASK',
    unitNumber: '',
    vin: '',
    transcription: '',
    mileage: '',
    poNumber: '',
    completedDate: '',
    estimatedTotal: '0.00',
    laborHours: 0,
    laborRate: 0,
    partsCost: 0,
    markupPercent: 0,
    taxLabor: false,
    taxParts: false,
    isTaxExempt: false,
    discountAmount: 0,
    operations: [],
    generalCharges: [],
    jobStatus: 'Task',
notes: notesController.text.trim(),
scheduledDateTime: scheduledDateTime,
reminderDateTime: scheduledDateTime,
reminderEnabled: true,
  );

 JobRepository.instance.addJob(task);

  if (!mounted) return;

  setState(() {});
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
SizedBox(
  width: double.infinity,
  child: FilledButton.icon(
    onPressed: _addTaskForSelectedDate,
    icon: const Icon(
      Icons.add_task,
    ),
    label: Text(
      isSpanish
          ? 'Agregar tarea para este día'
          : 'Add Task for This Day',
    ),
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
    leading: Icon(
      job.jobStatus == 'Task'
          ? Icons.fact_check_outlined
          : Icons.calendar_month_outlined,
    ),
    title: Text(
      job.jobStatus == 'Task'
          ? job.customerName
          : job.customerName,
    ),
    subtitle: Text(
      job.jobStatus == 'Task'
          ? [
              if (job.notes.trim().isNotEmpty)
                job.notes,
              _formatTime(
                context,
                scheduledDate,
              ),
            ].join(' • ')
          : [
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
            Icons.notifications_active_outlined,
          )
        : null,
    onTap: job.jobStatus == 'Task'
        ? null
        : () {
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
          onLongPress: job.jobStatus == 'Task'
    ? () async {
        final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(
              isSpanish
                  ? 'Completar tarea'
                  : 'Complete Task',
            ),
            content: Text(
              isSpanish
                  ? '¿Marcar esta tarea como completada y eliminarla?'
                  : 'Mark this task complete and remove it?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext, false);
                },
                child: Text(
                  isSpanish ? 'Cancelar' : 'Cancel',
                ),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(dialogContext, true);
                },
                child: Text(
                  isSpanish ? 'Completar' : 'Complete',
                ),
              ),
            ],
          ),
        );

        if (shouldDelete != true) return;

        JobRepository.instance.jobs.remove(job);
        await JobRepository.instance.save();

        if (!mounted) return;

        setState(() {});
      }
    : null,
  ),
);
              },
            ),
        ],
      ),
    );
  }
}