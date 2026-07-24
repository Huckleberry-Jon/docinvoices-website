import 'package:flutter/material.dart';
import 'voice_capture_screen.dart';



final TextEditingController customerController = TextEditingController();
final TextEditingController equipmentController =
    TextEditingController();
    final TextEditingController unitController = TextEditingController();
    final TextEditingController vinController = TextEditingController();
class NewJobScreen extends StatelessWidget {
  const NewJobScreen({
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
        isSpanish ? 'Nuevo trabajo' : 'New Job',
      ),
    ),
    body: SingleChildScrollView(
  padding:  EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      TextField(
  controller: customerController,
  decoration: InputDecoration(
  labelText: isSpanish
      ? 'Nombre del cliente'
      : 'Customer Name',
),
      ),
       SizedBox(height: 16),

      TextField(
  controller: equipmentController,
  decoration: InputDecoration(
  labelText: isSpanish
      ? 'Equipo'
      : 'Equipment',
),
),
       SizedBox(height: 16),

      TextField(
        controller: unitController,
        decoration: InputDecoration(
  labelText: isSpanish
      ? 'Unidad #'
      : 'Unit #',
),
      ),
       SizedBox(height: 16),

      TextField(
  controller: vinController,
  decoration: InputDecoration(
  labelText: isSpanish
      ? 'VIN / Número de serie'
      : 'VIN / Serial Number',
),
),
       SizedBox(height: 32),

     ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VoiceCaptureScreen(
                languageCode: languageCode,
                customerName: customerController.text.trim(),
                equipment: equipmentController.text.trim(),
                unitNumber: unitController.text.trim(),
                vin: vinController.text.trim(),
                mileage: '',
                poNumber: '',
                completedDate: '',
              ),
            ),
          );
        },
        child: Text(
          isSpanish
              ? 'Iniciar captura de voz'
              : 'Start Voice Capture',
        ),
      ),
    ],
  ),
),
  );
}
}