import '../models/job.dart';

class JobRepository {
  JobRepository._();

  static final JobRepository instance = JobRepository._();

  final List<Job> _jobs = [];

  List<Job> get jobs => List.unmodifiable(_jobs);

  List<Job> get activeJobs {
    return _jobs.where((job) {
      return job.jobStatus != 'Completed' &&
          job.jobStatus != 'Invoiced';
    }).toList();
  }

 void addJob(Job job) {
  _jobs.add(job);
  
}

  void updateJob(Job updatedJob) {
    final index = _jobs.indexWhere(
      (job) =>
          job.repairOrderNumber == updatedJob.repairOrderNumber &&
          job.customerName == updatedJob.customerName,
    );
    

    if (index == -1) {
       _jobs.add(updatedJob);
      return;
    }

    _jobs[index] = updatedJob;
  }

  void deleteJob(Job jobToDelete) {
    _jobs.remove(jobToDelete);
  }
}