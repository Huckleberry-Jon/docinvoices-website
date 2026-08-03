import 'package:flutter/material.dart';

import 'data_backup_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final isSpanish = languageCode == 'es';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSpanish ? 'Configuración' : 'Settings',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.storage_outlined,
              ),
              title: Text(
                isSpanish
                    ? 'Datos y respaldo'
                    : 'Data & Backup',
              ),
              subtitle: Text(
                isSpanish
                    ? 'Importar o exportar sus trabajos.'
                    : 'Import or export your jobs.',
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DataBackupScreen(
                      languageCode: languageCode,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}