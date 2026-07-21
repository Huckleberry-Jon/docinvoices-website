import 'package:flutter/material.dart';
import '../models/operation.dart';

class OperationDetailsScreen extends StatefulWidget {
  const OperationDetailsScreen({
  super.key,
  required this.operation,
});

final Operation operation;

@override
State<OperationDetailsScreen> createState() =>
    _OperationDetailsScreenState();
}

class _OperationDetailsScreenState
    extends State<OperationDetailsScreen> {
  

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
 ElevatedButton.icon(
  onPressed: () {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add Labor coming next...'),
      ),
    );
  },
  icon: const Icon(Icons.add),
  label: const Text('Add Labor'),
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
              widget.operation.notes.isEmpty
                  ? 'No notes yet.'
                  : widget.operation.notes,
            ),
          ],
        ),
      ),
    );
  }
}