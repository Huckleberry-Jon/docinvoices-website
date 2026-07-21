import 'package:flutter/material.dart';
import '../models/operation.dart';

class OperationDetailsScreen extends StatelessWidget {
  const OperationDetailsScreen({
    super.key,
    required this.operation,
  });

  final Operation operation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Operation Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              operation.title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Labor',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text('No labor added yet.'),

            const SizedBox(height: 24),

            const Text(
              'Parts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text('No parts added yet.'),

            const SizedBox(height: 24),

            const Text(
              'Notes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              operation.notes.isEmpty
                  ? 'No notes yet.'
                  : operation.notes,
            ),
          ],
        ),
      ),
    );
  }
}