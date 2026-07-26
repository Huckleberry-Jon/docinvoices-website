import 'package:flutter/material.dart';
import '../models/job.dart';

class ScheduleJobScreen extends StatefulWidget {
  const ScheduleJobScreen({
    super.key,
    required this.job,
    required this.languageCode,
  });

  final Job job;
  final String languageCode;

  @override
  State<ScheduleJobScreen> createState() => _ScheduleJobScreenState();
}

class _ScheduleJobScreenState extends State<ScheduleJobScreen> {
  DateTime? selectedDateTime;
  String reminderOption = 'None';

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.job.scheduledDateTime;
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date == null) return;
    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        selectedDateTime ?? DateTime.now(),
      ),
    );

    if (time == null) return;

    setState(() {
      selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _save() {
  if (selectedDateTime == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.languageCode == 'es'
              ? 'Seleccione una fecha y hora.'
              : 'Select a date and time first.',
        ),
      ),
    );
    return;
  }

  widget.job.scheduledDateTime = selectedDateTime;
  widget.job.reminderEnabled = reminderOption != 'None';

  switch (reminderOption) {
    case '15 Minutes':
      widget.job.reminderDateTime =
          selectedDateTime!.subtract(const Duration(minutes: 15));
      break;

    case '30 Minutes':
      widget.job.reminderDateTime =
          selectedDateTime!.subtract(const Duration(minutes: 30));
      break;

    case '1 Hour':
      widget.job.reminderDateTime =
          selectedDateTime!.subtract(const Duration(hours: 1));
      break;

    case '1 Day':
      widget.job.reminderDateTime =
          selectedDateTime!.subtract(const Duration(days: 1));
      break;

    default:
      widget.job.reminderDateTime = null;
  }

  Navigator.pop(context, true);
}

  @override
  Widget build(BuildContext context) {
    final isSpanish = widget.languageCode == 'es';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSpanish ? 'Programar trabajo' : 'Schedule Job',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text(
                selectedDateTime == null
                    ? (isSpanish
                        ? 'Seleccionar fecha y hora'
                        : 'Select Date & Time')
                    : selectedDateTime.toString(),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDateTime,
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              initialValue: reminderOption,
              decoration: InputDecoration(
                labelText:
                    isSpanish ? 'Recordatorio' : 'Reminder',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'None',
                  child: Text('None'),
                ),
                DropdownMenuItem(
                  value: '15 Minutes',
                  child: Text('15 Minutes'),
                ),
                DropdownMenuItem(
                  value: '30 Minutes',
                  child: Text('30 Minutes'),
                ),
                DropdownMenuItem(
                  value: '1 Hour',
                  child: Text('1 Hour'),
                ),
                DropdownMenuItem(
                  value: '1 Day',
                  child: Text('1 Day'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  reminderOption = value!;
                });
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: Text(
                  isSpanish ? 'Guardar' : 'Save',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}