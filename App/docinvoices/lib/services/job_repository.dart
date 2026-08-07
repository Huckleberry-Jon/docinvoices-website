import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/job.dart';

class JobRepository {
  JobRepository._();

  static final JobRepository instance = JobRepository._();

  static const String _storageKey = 'docinvoices_jobs';

  final List<Job> _jobs = [];

  int _nextEstimateNumber = 1001;
  int _nextRepairOrderNumber = 1001;
  int _nextInvoiceNumber = 1001;

  List<Job> get jobs => List.unmodifiable(_jobs);

  List<Job> get activeJobs {
    return _jobs.where((job) {
      return job.jobStatus != 'Completed' &&
          job.jobStatus != 'Invoiced' &&
          job.jobStatus != 'Sent' &&
          job.jobStatus != 'Partially Paid' &&
          job.jobStatus != 'Paid';
    }).toList();
  }

  List<Job> get invoicesWaiting {
    return _jobs.where((job) {
      return job.invoiceNumber.trim().isNotEmpty &&
          job.balanceDue > 0.01;
    }).toList();
  }

  List<Job> get paidInvoices {
    return _jobs.where((job) {
      return job.invoiceNumber.trim().isNotEmpty &&
          job.isPaidInFull;
    }).toList();
  }

  Future<void> load() async {
    final preferences =
        await SharedPreferences.getInstance();

    final savedData =
        preferences.getString(_storageKey);

    if (savedData == null || savedData.trim().isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(savedData);

      if (decoded is! Map<String, dynamic>) {
        return;
      }

      final rawJobs = decoded['jobs'];

      if (rawJobs is! List) {
        return;
      }

      final loadedJobs = rawJobs
          .map(
            (item) => Job.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();

      _jobs
        ..clear()
        ..addAll(loadedJobs);

      _refreshNextNumbers();
    } catch (_) {
      // Keep the app usable if previously saved data
      // cannot be read.
    }
  }

  Future<void> save() async {
    final preferences =
        await SharedPreferences.getInstance();

    final data = {
      'version': 1,
      'savedAt': DateTime.now().toIso8601String(),
      'jobs': _jobs.map((job) => job.toJson()).toList(),
    };

    await preferences.setString(
      _storageKey,
      jsonEncode(data),
    );
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
    save();
  }

  void updateJob(Job updatedJob) {
    final index = _jobs.indexWhere(
      (job) =>
          identical(job, updatedJob) ||
          (job.estimateNumber.trim().isNotEmpty &&
              job.estimateNumber ==
                  updatedJob.estimateNumber) ||
          (job.repairOrderNumber.trim().isNotEmpty &&
              job.repairOrderNumber ==
                  updatedJob.repairOrderNumber) ||
          (job.invoiceNumber.trim().isNotEmpty &&
              job.invoiceNumber ==
                  updatedJob.invoiceNumber),
    );

    if (index == -1) {
      addJob(updatedJob);
      return;
    }

    _jobs[index] = updatedJob;
    save();
  }

  String exportJobs() {
    final exportData = {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'jobs': _jobs.map((job) => job.toJson()).toList(),
    };

    return const JsonEncoder.withIndent(' ').convert(
      exportData,
    );
  }

  void importJobs(
    String jsonText, {
    bool replaceExisting = true,
  }) {
    final decoded = jsonDecode(jsonText);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid DocInvoices backup file.',
      );
    }

    final rawJobs = decoded['jobs'];

    if (rawJobs is! List) {
      throw const FormatException(
        'Backup file does not contain a jobs list.',
      );
    }

    final importedJobs = rawJobs
        .map(
          (item) => Job.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();

    if (replaceExisting) {
      _jobs
        ..clear()
        ..addAll(importedJobs);
    } else {
      for (final job in importedJobs) {
        updateJob(job);
      }
    }

    _refreshNextNumbers();
    save();
  }

  void _refreshNextNumbers() {
    int highestEstimate = 1000;
    int highestRepairOrder = 1000;
    int highestInvoice = 1000;

    for (final job in _jobs) {
      final estimate =
          int.tryParse(job.estimateNumber.trim());

      final repairOrder =
          int.tryParse(job.repairOrderNumber.trim());

      final invoice =
          int.tryParse(job.invoiceNumber.trim());

      if (estimate != null &&
          estimate > highestEstimate) {
        highestEstimate = estimate;
      }

      if (repairOrder != null &&
          repairOrder > highestRepairOrder) {
        highestRepairOrder = repairOrder;
      }

      if (invoice != null &&
          invoice > highestInvoice) {
        highestInvoice = invoice;
      }
    }

    _nextEstimateNumber = highestEstimate + 1;
    _nextRepairOrderNumber = highestRepairOrder + 1;
    _nextInvoiceNumber = highestInvoice + 1;
  }
}