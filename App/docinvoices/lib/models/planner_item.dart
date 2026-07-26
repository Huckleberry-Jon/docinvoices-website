enum PlannerItemType {
  job,
  task,
  reminder,
  followUp,
  partsEstimate,
  partsPickup,
  coreReturn,
  bill,
  quarterlyTax,
  yearlyTax,
}

class CalendarTask {
  CalendarTask({
    required this.title,
    this.description = '',
    this.dueDateTime,
    this.reminderDateTime,
    this.reminderEnabled = false,
    this.isCompleted = false,
    this.relatedJobId = '',
    this.type = PlannerItemType.task,
  });

  String title;
  String description;

  DateTime? dueDateTime;
  DateTime? reminderDateTime;

  bool reminderEnabled;
  bool isCompleted;

  String relatedJobId;

  PlannerItemType type;
}