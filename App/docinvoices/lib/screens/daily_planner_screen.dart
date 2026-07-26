import 'package:flutter/material.dart';
import '../models/planner_item.dart';
import '../services/calendar_task_repository.dart';
import 'add_calendar_task_screen.dart';

class CalendarTasksScreen extends StatefulWidget {
  const CalendarTasksScreen({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  @override
  State<CalendarTasksScreen> createState() =>
      _CalendarTasksScreenState();
}

class _CalendarTasksScreenState
    extends State<CalendarTasksScreen> {
  bool get isSpanish => widget.languageCode == 'es';

  List<CalendarTask> get tasks {
    final taskList = CalendarTaskRepository.instance.tasks.toList();

    taskList.sort((a, b) {
      if (a.dueDateTime == null && b.dueDateTime == null) {
        return 0;
      }

      if (a.dueDateTime == null) {
        return 1;
      }

      if (b.dueDateTime == null) {
        return -1;
      }

      return a.dueDateTime!.compareTo(b.dueDateTime!);
    });

    return taskList;
  }

  Future<void> _addTask() async {
    final taskAdded = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddCalendarTaskScreen(
          languageCode: widget.languageCode,
        ),
      ),
    );

    if (taskAdded == true && mounted) {
      setState(() {});
    }
  }

  void _toggleCompleted(int repositoryIndex) {
    CalendarTaskRepository.instance.toggleCompleted(
      repositoryIndex,
    );

    setState(() {});
  }

  void _deleteTask(int repositoryIndex) {
    CalendarTaskRepository.instance.deleteTask(
      repositoryIndex,
    );

    setState(() {});
  }

  String _formatDateTime(
    BuildContext context,
    DateTime dateTime,
  ) {
    final localizations = MaterialLocalizations.of(context);

    final date = localizations.formatFullDate(dateTime);
    final time = localizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(dateTime),
    );

    return '$date\n$time';
  }

  @override
  Widget build(BuildContext context) {
    final repositoryTasks =
        CalendarTaskRepository.instance.tasks;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSpanish ? 'Tareas' : 'Tasks',
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTask,
        icon: const Icon(Icons.add),
        label: Text(
          isSpanish ? 'Nueva tarea' : 'New Task',
        ),
      ),
      body: tasks.isEmpty
          ? Center(
              child: Text(
                isSpanish
                    ? 'No hay tareas todavía.'
                    : 'No tasks yet.',
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final task = tasks[index];
                final repositoryIndex =
                    repositoryTasks.indexOf(task);

                return Card(
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (_) {
                        _toggleCompleted(repositoryIndex);
                      },
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        if (task.description.isNotEmpty)
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 4),
                            child: Text(task.description),
                          ),
                        if (task.dueDateTime != null)
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8),
                            child: Text(
                              _formatDateTime(
                                context,
                                task.dueDateTime!,
                              ),
                            ),
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (task.reminderEnabled)
                          const Icon(
                            Icons.notifications_active_outlined,
                          ),
                        IconButton(
                          onPressed: () {
                            _deleteTask(repositoryIndex);
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}