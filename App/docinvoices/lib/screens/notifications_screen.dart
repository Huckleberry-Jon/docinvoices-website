import 'package:flutter/material.dart';

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
                ? 'Los pagos aparecerán aquí.'
                : 'Payments will appear here.',
          ),
          _notificationTile(
            icon: Icons.verified_outlined,
            color: Colors.blue,
            title: isSpanish
                ? 'Trabajo aprobado'
                : 'Job Approved',
            subtitle: isSpanish
                ? 'Las aprobaciones aparecerán aquí.'
                : 'Approvals will appear here.',
          ),
          _notificationTile(
            icon: Icons.calendar_month_outlined,
            color: Colors.orange,
            title: isSpanish
                ? 'Trabajos programados'
                : 'Scheduled Jobs',
            subtitle: isSpanish
                ? 'Los próximos trabajos aparecerán aquí.'
                : 'Upcoming scheduled jobs.',
          ),
          _notificationTile(
            icon: Icons.task_alt_outlined,
            color: Colors.purple,
            title: isSpanish
                ? 'Recordatorios'
                : 'Task Reminders',
            subtitle: isSpanish
                ? 'Los recordatorios aparecerán aquí.'
                : 'Task reminders will appear here.',
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
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: .15),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}