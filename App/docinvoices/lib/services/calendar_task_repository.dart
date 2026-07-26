import '../models/planner_item.dart';

class CalendarTaskRepository {
  CalendarTaskRepository._();

  static final CalendarTaskRepository instance =
      CalendarTaskRepository._();

  final List<CalendarTask> _tasks = [];

  List<CalendarTask> get tasks =>
      List.unmodifiable(_tasks);

  void addTask(CalendarTask task) {
    _tasks.add(task);
  }

  void updateTask(
    int index,
    CalendarTask updatedTask,
  ) {
    if (index < 0 || index >= _tasks.length) {
      return;
    }

    _tasks[index] = updatedTask;
  }

  void deleteTask(int index) {
    if (index < 0 || index >= _tasks.length) {
      return;
    }

    _tasks.removeAt(index);
  }

  void toggleCompleted(int index) {
    if (index < 0 || index >= _tasks.length) {
      return;
    }

    _tasks[index].isCompleted =
        !_tasks[index].isCompleted;
  }
}