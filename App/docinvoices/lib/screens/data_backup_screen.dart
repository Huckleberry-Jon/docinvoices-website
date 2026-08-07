
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../services/customer_repository.dart';
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
Future<void> _exportCustomers() async {
  try {
    final jsonText =
        CustomerRepository.exportCustomers();

    final temporaryDirectory =
        await getTemporaryDirectory();

    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');

    final file = File(
      '${temporaryDirectory.path}'
      '/docinvoices_customers_$timestamp.json',
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
            ? 'Clientes de DocInvoices'
            : 'DocInvoices Customers',
        text: isSpanish
            ? 'Archivo de respaldo de clientes.'
            : 'Customer backup file.',
      ),
    );
  } catch (error) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSpanish
              ? 'No se pudieron exportar los clientes: $error'
              : 'Could not export customers: $error',
        ),
      ),
    );
  }
}
Future<void> _importCustomers() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json', 'csv'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return;
    }

    final selectedFile = result.files.single;
final extension =
    selectedFile.extension?.toLowerCase() ?? '';
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
        'Could not read the selected customer file.',
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
                ? 'Importar clientes'
                : 'Import Customers',
          ),
          content: Text(
            isSpanish
                ? '¿Desea reemplazar todos los clientes actuales? Seleccione Combinar para conservar los clientes existentes.'
                : 'Replace all current customers? Choose Merge to keep the existing customers.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text(
                isSpanish ? 'Cancelar' : 'Cancel',
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
                isSpanish ? 'Combinar' : 'Merge',
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
                isSpanish ? 'Reemplazar' : 'Replace',
              ),
            ),
          ],
        );
      },
    );

    if (replaceExisting == null) {
      return;
    }

    if (extension == 'csv') {
  await CustomerRepository.importCustomersCsv(
    jsonText,
    replaceExisting: replaceExisting,
  );
} else {
  await CustomerRepository.importCustomers(
    jsonText,
    replaceExisting: replaceExisting,
  );
}

    final customerCount =
        CustomerRepository.customers.length;

    if (!mounted) return;

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSpanish
              ? 'Clientes importados. $customerCount clientes disponibles.'
              : 'Customers imported. $customerCount customers available.',
        ),
      ),
    );
  } catch (error) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSpanish
              ? 'No se pudieron importar los clientes: $error'
              : 'Could not import customers: $error',
        ),
      ),
    );
  }
}
Future<void> _importBackup() async {
  try {
    final result = await FilePicker.platform.pickFiles(
  type: FileType.custom,
  allowedExtensions: [
    'json',
    'csv',
  ],
  withData: true,
);

    if (result == null || result.files.isEmpty) {
      return;
    }

    final selectedFile = result.files.single;
final extension =
    selectedFile.extension?.toLowerCase() ?? '';
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
if (extension == 'csv') {
  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        isSpanish
            ? 'La importación de archivos CSV estará disponible en la próxima actualización.'
            : 'CSV customer import will be available in the next update.',
      ),
    ),
  );
  return;
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
  actions: [
    IconButton(
      icon: const Icon(Icons.help_outline),
      tooltip: isSpanish
          ? 'Ayuda de importación y exportación'
          : 'Import and export help',
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: Text(
                isSpanish
                    ? 'Cómo importar y exportar'
                    : 'How Import and Export Work',
              ),
              content: SingleChildScrollView(
                child: Text(
  isSpanish
      ? 'Cómo exportar clientes:\n\n'
          '1. Toque "Exportar clientes".\n'
          '2. Elija dónde guardar el archivo.\n'
          '3. Guarde el respaldo en un lugar seguro.\n\n'
          'Cómo importar clientes:\n\n'
          '1. Toque "Importar clientes".\n'
          '2. Seleccione un archivo de respaldo de DocInvoices.\n'
          '3. Elija "Combinar" para agregar clientes nuevos o "Reemplazar" para usar solamente el respaldo.\n'
          '4. Confirme la importación.\n\n'
          'Los respaldos de trabajos se administran por separado.'
      : 'How to Export Customers:\n\n'
          '1. Tap "Export Customers".\n'
          '2. Choose where to save the backup file.\n'
          '3. Keep the backup somewhere safe.\n\n'
          'How to Import Customers:\n\n'
          '1. Tap "Import Customers".\n'
          '2. Select a DocInvoices backup file.\n'
          '3. Choose "Merge" to add new customers or "Replace" to use only the backup file.\n'
          '4. Confirm the import.\n\n'
          'Job backups are managed separately.',
                ),
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: Text(
                    isSpanish ? 'Entendido' : 'Got It',
                  ),
                ),
              ],
            );
          },
        );
      },
    ),
  ],
),
      body: ListView(
        padding: const EdgeInsets.all(16),
        
        children: [
          Card(
  child: ListTile(
    leading: const Icon(
      Icons.people_alt_outlined,
    ),
    title: Text(
      isSpanish
          ? 'Exportar clientes'
          : 'Export Customers',
    ),
    subtitle: Text(
      isSpanish
          ? 'Guardar todos los clientes en un archivo.'
          : 'Save all customers to a backup file.',
    ),
    trailing: const Icon(
      Icons.chevron_right,
    ),
    onTap: _exportCustomers,
  ),
),

const SizedBox(height: 12),

Card(
  child: ListTile(
    leading: const Icon(
      Icons.person_add_alt_1_outlined,
    ),
    title: Text(
      isSpanish
          ? 'Importar clientes'
          : 'Import Customers',
    ),
    subtitle: Text(
      isSpanish
          ? 'Agregar o reemplazar clientes desde un archivo.'
          : 'Merge or replace customers from a backup file.',
    ),
    trailing: const Icon(
      Icons.chevron_right,
    ),
    onTap: _importCustomers,
  ),
),

const SizedBox(height: 24),

Text(
  isSpanish
      ? 'Respaldo de trabajos'
      : 'Job Backup',
  style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 12),
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