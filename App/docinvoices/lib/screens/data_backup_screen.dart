
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../services/job_repository.dart';
class DataBackupScreen extends StatefulWidget {
  
  const DataBackupScreen({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  @override
  State<DataBackupScreen> createState() =>
      _DataBackupScreenState();
}

class _DataBackupScreenState
    extends State<DataBackupScreen> {
  bool isExporting = false;

  bool get isSpanish =>
      widget.languageCode == 'es';
  
Future<void> _exportBackup() async {
  if (isExporting) return;

  setState(() {
    isExporting = true;
  });

  try {
    final jsonText =
        JobRepository.instance.exportJobs();

    final temporaryDirectory =
        await getTemporaryDirectory();

    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');

    final file = File(
      '${temporaryDirectory.path}'
      '/docinvoices_backup_$timestamp.json',
    );

    await file.writeAsString(jsonText);

    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile(
            file.path,
            mimeType: 'application/json',
          ),
        ],
        subject: isSpanish
            ? 'Respaldo de DocInvoices'
            : 'DocInvoices Backup',
        text: isSpanish
            ? 'Archivo de respaldo de DocInvoices.'
            : 'DocInvoices backup file.',
      ),
    );
  } catch (error) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSpanish
              ? 'No se pudo exportar el respaldo: $error'
              : 'Could not export backup: $error',
        ),
      ),
    );
  } finally {
    if (mounted) {
      setState(() {
        isExporting = false;
      });
    }
  }
}
Future<void> _importBackup() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return;
    }

    final selectedFile = result.files.single;

    String jsonText;

    if (selectedFile.bytes != null) {
      jsonText = String.fromCharCodes(
        selectedFile.bytes!,
      );
    } else if (selectedFile.path != null) {
      jsonText = await File(
        selectedFile.path!,
      ).readAsString();
    } else {
      throw const FormatException(
        'Could not read the selected backup file.',
      );
    }

    if (!mounted) return;

    final bool? replaceExisting =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            isSpanish
                ? 'Importar respaldo'
                : 'Import Backup',
          ),
          content: Text(
            isSpanish
                ? '¿Desea reemplazar todos los trabajos actuales? Seleccione Combinar para conservar los trabajos existentes.'
                : 'Replace all current jobs? Choose Merge to keep the existing jobs.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: Text(
                isSpanish
                    ? 'Cancelar'
                    : 'Cancel',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: Text(
                isSpanish
                    ? 'Combinar'
                    : 'Merge',
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
                    ? 'Reemplazar'
                    : 'Replace',
              ),
            ),
          ],
        );
      },
    );

    if (replaceExisting == null) {
      return;
    }

    JobRepository.instance.importJobs(
      jsonText,
      replaceExisting: replaceExisting,
    );

    final jobCount =
        JobRepository.instance.jobs.length;

    if (!mounted) return;

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSpanish
              ? 'Respaldo importado. $jobCount trabajos disponibles.'
              : 'Backup imported. $jobCount jobs available.',
        ),
      ),
    );
  } catch (error) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSpanish
              ? 'No se pudo importar el respaldo: $error'
              : 'Could not import backup: $error',
        ),
      ),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    final isSpanish =
    widget.languageCode == 'es';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSpanish ? 'Datos y respaldo' : 'Data & Backup',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.upload_file_outlined,
              ),
              title: Text(
                isSpanish
                    ? 'Exportar respaldo'
                    : 'Export Backup',
              ),
              subtitle: Text(
                isSpanish
                    ? 'Guardar todos los trabajos en un archivo.'
                    : 'Save all jobs to a backup file.',
              ),
              trailing: isExporting
    ? const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      )
    : const Icon(
        Icons.chevron_right,
      ),
              onTap: isExporting
    ? null
    : _exportBackup,
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.download_outlined,
              ),
              title: Text(
                isSpanish
                    ? 'Importar respaldo'
                    : 'Import Backup',
              ),
              subtitle: Text(
                isSpanish
                    ? 'Restaurar trabajos desde un archivo.'
                    : 'Restore jobs from a backup file.',
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
             onTap: _importBackup,
            ),
          ),
        ],
      ),
    );
  }
}