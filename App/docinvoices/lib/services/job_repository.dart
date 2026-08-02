import '../models/job.dart';

class JobRepository {
  JobRepository._();

  static final JobRepository instance = JobRepository._();

  final List<Job> _jobs = [];

  int _nextEstimateNumber = 1001;
  int _nextRepairOrderNumber = 1001;
  int _nextInvoiceNumber = 1001;

  List<Job> get jobs => List.unmodifiable(_jobs);

  List<Job> get activeJobs {
    return _jobs.where((job) {
      return job.jobStatus != 'Completed' &&
          job.jobStatus != 'Invoiced';
    }).toList();
  }

  String nextEstimateNumber() {
    final number = _nextEstimateNumber;
    _nextEstimateNumber++;

    return number.toString();
  }

  String nextRepairOrderNumber() {
    final number = _nextRepairOrderNumber;
    _nextRepairOrderNumber++;

    return number.toString();
  }

  String nextInvoiceNumber() {
    final number = _nextInvoiceNumber;
    _nextInvoiceNumber++;

    return number.toString();
  }

  void addJob(Job job) {
    if (job.estimateNumber.trim().isEmpty) {
      job.estimateNumber = nextEstimateNumber();
    }

    _jobs.add(job);
  }

  void updateJob(Job updatedJob) {
  final index = _jobs.indexWhere(
    (job) =>
        identical(job, updatedJob) ||
        (
          job.estimateNumber.trim().isNotEmpty &&
          job.estimateNumber == updatedJob.estimateNumber
        ) ||
        (
          job.repairOrderNumber.trim().isNotEmpty &&
          job.repairOrderNumber ==
              updatedJob.repairOrderNumber
        ) ||
        (
          job.invoiceNumber.trim().isNotEmpty &&
          job.invoiceNumber ==
              updatedJob.invoiceNumber
        ),
  );

  if (index == -1) {
    addJob(updatedJob);
    return;
  }

  _jobs[index] = updatedJob;
}
}