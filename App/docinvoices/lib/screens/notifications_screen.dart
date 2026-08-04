import 'package:flutter/material.dart';
import '../services/job_repository.dart';
import 'scheduled_jobs_screen.dart';
import 'approved_jobs_screen.dart';
import 'payments_history_screen.dart';
import 'reminder_jobs_screen.dart';
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final bool isSpanish = languageCode == 'es';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSpanish ? 'Notificaciones' : 'Notifications',
        ),
      ),
      body: ListView(
        children: [
          _notificationTile(
  icon: Icons.payments_outlined,
  color: Colors.green,
  title: isSpanish
      ? 'Pago recibido'
      : 'Payment Received',
  subtitle: isSpanish
      ? 'Ver historial de pagos.'
      : 'View payment history.',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentsHistoryScreen(
          languageCode: languageCode,
        ),
      ),
    );
  },
),
         _notificationTile(
  icon: Icons.verified_outlined,
  color: Colors.blue,
  title: isSpanish
      ? 'Trabajo aprobado'
      : 'Job Approved',
  subtitle: isSpanish
      ? 'Ver todos los trabajos aprobados.'
      : 'View all approved jobs.',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ApprovedJobsScreen(
          languageCode: languageCode,
        ),
      ),
    );
  },
),
          _notificationTile(
  icon: Icons.task_alt_outlined,
  color: Colors.purple,
  title: isSpanish
      ? 'Recordatorios'
      : 'Task Reminders',
  subtitle: isSpanish
      ? 'Ver todos los recordatorios activos.'
      : 'View all active reminders.',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReminderJobsScreen(
          languageCode: languageCode,
        ),
      ),
    );
  },
),
        ],
      ),
    );
  }

 Widget _notificationTile({
  required IconData icon,
  required Color color,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: CircleAvatar(
      backgroundColor: color.withValues(alpha: .15),
      child: Icon(icon, color: color),
    ),
    title: Text(title),
    subtitle: Text(subtitle),
    trailing: const Icon(Icons.chevron_right),
    onTap: onTap,
  );
}
}