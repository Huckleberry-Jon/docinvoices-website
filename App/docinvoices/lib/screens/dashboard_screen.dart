import 'package:flutter/material.dart';

import 'create_screen.dart';
import 'invoices_screen.dart';
import 'active_jobs_screen.dart';
import 'scheduled_jobs_screen.dart';
import '../models/job.dart';
import 'reports_screen.dart';
import 'estimates_screen.dart';
import '../services/job_repository.dart';
import 'invoices_waiting_screen.dart';
import 'notifications_screen.dart';
import 'business_profile_screen.dart';
import 'customer_screen.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    required this.languageCode,
  });

  final String languageCode;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Job> jobs = [];

  String get languageCode => widget.languageCode;
  
  bool? get isSpanish => languageCode == 'es';

  void _openCreate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateScreen(
  languageCode: languageCode,
),
               ),
    );
  }

  void _showComingSoon(
  BuildContext context,
  String feature,
  bool isSpanish,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        isSpanish
            ? '$feature estará disponible en una futura actualización.'
            : '$feature will be available in a future update.',
      ),
    ),
  );
}

 Widget _summaryCard({
  required BuildContext context,
  required String title,
  required String value,
  required String subtitle,
  required IconData icon,
  required Color color,
  VoidCallback? onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 180),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withValues(alpha: 0.45),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withValues(alpha: 0.18),
                      border: Border.all(color: color),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 31,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.white70,
                    size: 32,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _workflowItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ??
    () => _showComingSoon(
          context,
          title,
          isSpanish == true,
        ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: color.withValues(alpha: 0.20),
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 15,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.white70,
              size: 31,
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomItem({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap ?? () => _showComingSoon(context, label, isSpanish == true),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.17),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isSpanish = languageCode == 'es';
    return Scaffold(
      drawer: Drawer(
  child: SafeArea(
    child: ListView(
      children: [
        const DrawerHeader(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.description,
                size: 48,
                color: Colors.blue,
              ),
              SizedBox(height: 12),
              Text(
                'DocInvoices',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        ListTile(
          leading: const Icon(Icons.business),
          title: Text(
            isSpanish
                ? 'Configuración comercial'
                : 'Business Settings',
          ),
          onTap: () {
            Navigator.pop(context);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BusinessProfileScreen(
                  languageCode: widget.languageCode,
                ),
              ),
            );
          },
        ),

        ListTile(
          leading: const Icon(Icons.person_add_alt_1_outlined),
          title: Text(
            isSpanish
                ? 'Crear cliente'
                : 'Create Customer',
          ),
          onTap: () {
            Navigator.pop(context);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CustomerScreen(
                  languageCode: widget.languageCode,
                ),
              ),
            );
          },
        ),

        const Divider(),

        ListTile(
          leading: const Icon(Icons.build_outlined),
          title: Text(
            isSpanish
                ? 'Trabajos activos'
                : 'Active Jobs',
          ),
          onTap: () {
            Navigator.pop(context);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ActiveJobsScreen(
                  languageCode: widget.languageCode,
                ),
              ),
            );
          },
        ),

        ListTile(
          leading: const Icon(Icons.calendar_month_outlined),
          title: Text(
            isSpanish
                ? 'Trabajos programados'
                : 'Scheduled Jobs',
          ),
          onTap: () {
            Navigator.pop(context);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ScheduledJobsScreen(
                  languageCode: widget.languageCode,
                ),
              ),
            );
          },
        ),

        ListTile(
          leading: const Icon(Icons.description_outlined),
          title: Text(
            isSpanish ? 'Cotizaciones' : 'Estimates',
          ),
          onTap: () {
            Navigator.pop(context);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EstimatesScreen(
                  languageCode: widget.languageCode,
                ),
              ),
            );
          },
        ),

        ListTile(
          leading: const Icon(Icons.receipt_long_outlined),
          title: Text(
            isSpanish
                ? 'Facturas pendientes'
                : 'Invoices Waiting',
          ),
          onTap: () {
            Navigator.pop(context);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => InvoicesWaitingScreen(
                  languageCode: widget.languageCode,
                ),
              ),
            );
          },
        ),

        ListTile(
          leading: const Icon(Icons.notifications_none),
          title: Text(
            isSpanish
                ? 'Notificaciones'
                : 'Notifications',
          ),
          onTap: () {
            Navigator.pop(context);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NotificationsScreen(
                  languageCode: widget.languageCode,
                ),
              ),
            );
          },
        ),

        const Divider(),

        ListTile(
          leading: const Icon(Icons.bar_chart_outlined),
          title: Text(
            isSpanish ? 'Reportes' : 'Reports',
          ),
          onTap: () {
            Navigator.pop(context);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReportsScreen(
                  languageCode: widget.languageCode,
                ),
              ),
            );
          },
        ),

        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(
            isSpanish ? 'Acerca de' : 'About',
          ),
          onTap: () {
            Navigator.pop(context);

            showAboutDialog(
              context: context,
              applicationName: 'DocInvoices',
              applicationVersion: '1.0.0 (9)',
              applicationLegalese: '© 2026 DocInvoices',
            );
          },
        ),
      ],
    ),
  ),
),
      backgroundColor: const Color(0xFF050B14),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Builder(
  builder: (menuContext) {
    return IconButton(
      onPressed: () {
        Scaffold.of(menuContext).openDrawer();
      },
      icon: const Icon(
        Icons.menu,
        color: Colors.white,
        size: 34,
      ),
    );
  },
),
                            const Spacer(),
                            Column(
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Doc',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Invoices',
                                        style: TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'From Job to Payment.',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                IconButton(
                                  onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => NotificationsScreen(
        languageCode: widget.languageCode,
      ),
    ),
  );
},
                                  icon: const Icon(
                                    Icons.notifications_none,
                                    color: Colors.white,
                                    size: 31,
                                  ),
                                ),
                                Positioned(
                                  right: 4,
                                  top: 1,
                                  child: Container(
                                    width: 22,
                                    height: 22,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.redAccent,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '0',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 34),
                        Text(
  isSpanish ? '¡Bienvenido de nuevo! 👋' : 'Welcome Back! 👋',
  style: const TextStyle(
    color: Colors.white,
    fontSize: 31,
    fontWeight: FontWeight.bold,
  ),
),
const SizedBox(height: 8),
Text(
  isSpanish
      ? 'Vamos a poner manos a la obra.'
      : 'Let’s get some work done.',
  style: const TextStyle(
    color: Colors.white60,
    fontSize: 19,
  ),
),
const SizedBox(height: 28),
Row(
  children: [
   _summaryCard(
  context: context,
  title: isSpanish
      ? 'Trabajos activos'
      : 'Active Work Orders',
  value: JobRepository.instance.activeJobs.length.toString(),
  subtitle: isSpanish
      ? 'Ver trabajos activos'
      : 'View active work orders',
  icon: Icons.work_outline,
  color: Colors.blue,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ActiveJobsScreen(
          languageCode: widget.languageCode,
        ),
      ),
    );
  },
),
    const SizedBox(width: 16),
   _summaryCard(
  context: context,
  title: isSpanish
      ? 'Facturas pendientes'
      : 'Invoices Waiting',
  value: JobRepository.instance.invoicesWaiting.length.toString(),
  subtitle:
      '\$${JobRepository.instance.invoicesWaiting.fold<double>(
        0,
        (total, job) => total + job.balanceDue,
      ).toStringAsFixed(2)}',
  icon: Icons.receipt_long_outlined,
  color: Colors.orange,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InvoicesWaitingScreen(
          languageCode: widget.languageCode,
        ),
      ),
    );
  },
),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF07111D),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                               Padding(
                                padding: EdgeInsets.fromLTRB(
                                  22,
                                  22,
                                  22,
                                  14,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.hub_outlined,
                                      color: Colors.orange,
                                      size: 37,
                                    ),
                                    SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                          isSpanish ? 'Flujo de trabajo'
                                                     : 'Choose what you\'d like to do.',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                               isSpanish ? 'Todo lo que necesita para completar el trabajo.'
    : 'Everything you need to get the job done.',
                                            style: TextStyle(
                                              color: Colors.white60,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                color: Colors.white12,
                                height: 1,
                              ),
                              _workflowItem(
                                context: context,
                                title: isSpanish?'Nueva Orden de Servicio'
    : 'New Service Order',
                                subtitle:
                                    isSpanish? 'Crear un nuevo trabajo u orden de trabajo.'
    : 'Start a new service call or repair order.',
                                icon: Icons.note_add_outlined,
                                color: Colors.blue,
                                onTap: () => _openCreate(context),
                              ),
                              const Divider(
                                color: Colors.white12,
                                height: 1,
                              ),
                              _workflowItem(
  context: context,
  title: isSpanish
    ? 'Continuar trabajo'
    : 'Continue Work',
  subtitle: isSpanish
    ? 'Ver trabajos activos'
    : 'Find unfinished work order',
  icon: Icons.update,
  color: Colors.lightGreen,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
       builder: (context) => ActiveJobsScreen(
  languageCode: languageCode,
),
      ),
    );
  },
),
                              const Divider(
                                color: Colors.white12,
                                height: 1,
                              ),
                             _workflowItem(
  context: context,
  title: isSpanish
      ? 'Trabajos programados'
      : 'Scheduled Jobs',
  subtitle: isSpanish
      ? 'Ver sus próximos trabajos.'
      : 'View your upcoming jobs.',
  icon: Icons.calendar_month_outlined,
  color: Colors.purpleAccent,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
       builder: (_) => ScheduledJobsScreen(
  languageCode: languageCode,
),
      ),
    );
  },
),
                              const Divider(
                                color: Colors.white12,
                                height: 1,
                              ),
                              _workflowItem(
  context: context,
  title: isSpanish
      ? 'Tareas'
      : 'Tasks',
  subtitle: isSpanish
      ? 'Tareas y seguimientos.'
      : 'Tasks and follow-ups.',
  icon: Icons.fact_check_outlined,
  color: Colors.lightBlueAccent,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationsScreen(
          languageCode: widget.languageCode,
        ),
      ),
    );
  },
),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF07111D),
                border: Border(
                  top: BorderSide(color: Colors.white12),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                  _bottomItem(
  context: context,
  label: 'Payments',
  icon: Icons.attach_money,
  color: Colors.lightGreen,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InvoicesScreen(
          languageCode: widget.languageCode,
        ),
      ),
    );
  },
),
                   _bottomItem(
  context: context,
  icon: Icons.description_outlined,
  label: isSpanish ? 'Cotizaciones' : 'Estimates',
  color: Colors.orange,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EstimatesScreen(
          languageCode: widget.languageCode,
        ),
      ),
    );
  },
),
                    Expanded(
                      child: InkWell(
                        onTap: () => _openCreate(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 74,
                                height: 74,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue.withValues(
                                    alpha: 0.18,
                                  ),
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 3,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.blue,
                                      blurRadius: 18,
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  'assets/images/docinvoices_logo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
  isSpanish ? 'Crear' : 'Create',
  style: const TextStyle(
    color: Colors.blue,
    fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _bottomItem(
  context: context,
  label: languageCode == 'es' ? 'Facturas' : 'Invoices',
  icon: Icons.receipt_long_outlined,
  color: Colors.purpleAccent,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InvoicesScreen(
          languageCode: languageCode,
        ),
      ),
    );
  },
),
                    _bottomItem(
  context: context,
  label: 'Reports',
  icon: Icons.bar_chart,
  color: Colors.lightGreen,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportsScreen(
          languageCode: languageCode,
        ),
      ),
    );
  },
),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}