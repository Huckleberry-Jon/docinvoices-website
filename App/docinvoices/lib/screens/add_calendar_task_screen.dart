import 'package:flutter/material.dart';
import '../models/planner_item.dart';
import '../services/calendar_task_repository.dart';

class AddCalendarTaskScreen extends StatefulWidget {
  const AddCalendarTaskScreen({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  @override
  State<AddCalendarTaskScreen> createState() =>
      _AddCalendarTaskScreenState();
}

class _AddCalendarTaskScreenState
    extends State<AddCalendarTaskScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime? selectedDateTime;
  bool reminderEnabled = false;

  bool get isSpanish => widget.languageCode == 'es';

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDateAndTime() async {
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );

    if (selectedDate == null || !mounted) {
      return;
    }

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        selectedDateTime ?? now,
      ),
    );

    if (selectedTime == null) {
      return;
    }

    setState(() {
      selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
    });
  }

  void _saveTask() {
    final title = titleController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isSpanish
                ? 'Ingrese un título para la tarea.'
                : 'Enter a task title.',
          ),
        ),
      );

      return;
    }

    CalendarTaskRepository.instance.addTask(
      CalendarTask(
        title: title,
        description: descriptionController.text.trim(),
        dueDateTime: selectedDateTime,
        reminderDateTime:
            reminderEnabled ? selectedDateTime : null,
        reminderEnabled: reminderEnabled,
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final dateText = selectedDateTime == null
        ? isSpanish
            ? 'Seleccionar fecha y hora'
            : 'Select date and time'
        : MaterialLocalizations.of(context).formatFullDate(
            selectedDateTime!,
          );

    final timeText = selectedDateTime == null
        ? ''
        : MaterialLocalizations.of(context).formatTimeOfDay(
            TimeOfDay.fromDateTime(selectedDateTime!),
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSpanish ? 'Nueva tarea' : 'New Task',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: titleController,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText:
                  isSpanish ? 'Título' : 'Task Title',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: descriptionController,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 4,
            decoration: InputDecoration(
              labelText:
                  isSpanish ? 'Notas' : 'Notes',
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(
              Icons.calendar_month_outlined,
            ),
            title: Text(dateText),
            subtitle: timeText.isEmpty
                ? null
                : Text(timeText),
            trailing: const Icon(
              Icons.chevron_right,
            ),
            onTap: _selectDateAndTime,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              isSpanish
                  ? 'Activar recordatorio'
                  : 'Enable Reminder',
            ),
            value: reminderEnabled,
            onChanged: selectedDateTime == null
                ? null
                : (value) {
                    setState(() {
                      reminderEnabled = value;
                    });
                  },
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _saveTask,
            icon: const Icon(Icons.save_outlined),
            label: Text(
              isSpanish ? 'Guardar tarea' : 'Save Task',
            ),
          ),
        ],
      ),
    );
  }
}