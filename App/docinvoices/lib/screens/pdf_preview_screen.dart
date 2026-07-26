import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../models/job.dart';
import '../services/pdf_service.dart';

class PdfPreviewScreen extends StatelessWidget {
  const PdfPreviewScreen({
    super.key,
    required this.job,
  });

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice PDF'),
      ),
      body: PdfPreview(
        build: (format) {
          return PdfService.generateInvoice(job);
        },
      ),
    );
  }
}