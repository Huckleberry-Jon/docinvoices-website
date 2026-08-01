import 'package:flutter/material.dart';

import '../models/labor_item.dart';
import '../models/operation.dart';
import '../models/part_item.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class OperationDetailsScreen extends StatefulWidget {
 const OperationDetailsScreen({
  super.key,
  required this.operation,
  required this.languageCode,
});

  final Operation operation;
  final String languageCode;


  @override
  State<OperationDetailsScreen> createState() =>
      _OperationDetailsScreenState();
}

class _OperationDetailsScreenState
    extends State<OperationDetailsScreen> {
      late final TextEditingController complaintController;
late final TextEditingController repairController;
late final stt.SpeechToText speech;
bool isListening = false;

@override
void initState() {
  super.initState();
  speech = stt.SpeechToText();

  complaintController = TextEditingController(
    text: widget.operation.title,
  );

  repairController = TextEditingController(
  text: widget.operation.repairDescription,
);
}

@override
void dispose() {
  complaintController.dispose();
  repairController.dispose();
  super.dispose();
}
  String _money(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  String _number(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(2);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
  Future<void> _toggleListening() async {
  if (isListening) {
    await speech.stop();

    if (!mounted) return;

    setState(() {
      isListening = false;
    });

    return;
  }

  final bool available = await speech.initialize();

  if (!available) {
    _showMessage('Voice recognition is not available.');
    return;
  }

  if (!mounted) return;

  setState(() {
    isListening = true;
  });

  final String existingText = repairController.text.trim();

  await speech.listen(
    onResult: (result) {
      if (!mounted) return;

      final String newWords = result.recognizedWords.trim();

      setState(() {
        repairController.text = existingText.isEmpty
            ? newWords
            : '$existingText\n$newWords';

        repairController.selection = TextSelection.fromPosition(
          TextPosition(
            offset: repairController.text.length,
          ),
        );

        if (result.finalResult) {
          isListening = false;
        }
      });
    },
  );
}

  Future<void> _showAddLaborDialog() async {
    final descriptionController = TextEditingController();
    final hoursController = TextEditingController();
    final rateController = TextEditingController(
      text: '125.00',
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Labor'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: descriptionController,
                    autofocus: true,
                    textCapitalization:
                        TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Example: Replace water pump',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: hoursController,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Hours',
                      hintText: 'Example: 2.5',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: rateController,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Hourly Rate',
                      hintText: 'Example: 125.00',
                      prefixText: '\$',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final description =
                    descriptionController.text.trim();

                final hours = double.tryParse(
                  hoursController.text.trim(),
                );

                final rate = double.tryParse(
                  rateController.text.trim(),
                );

                if (description.isEmpty ||
                    hours == null ||
                    hours <= 0 ||
                    rate == null ||
                    rate < 0) {
                  _showMessage(
                    'Enter a description, valid hours, and hourly rate.',
                  );
                  return;
                }

                setState(() {
                  widget.operation.labor.add(
                    LaborItem(
                      description: description,
                      hours: hours,
                      rate: rate,
                    ),
                  );
                });

                Navigator.pop(dialogContext);
              },
              child: const Text('Save Labor'),
            ),
          ],
        );
      },
    );

    descriptionController.dispose();
    hoursController.dispose();
    rateController.dispose();
  }

  Future<void> _showAddPartDialog() async {
    final descriptionController = TextEditingController();
    final quantityController = TextEditingController(
      text: '1',
    );
    final unitPriceController = TextEditingController();

    bool taxable = true;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Part'),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 420,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: descriptionController,
                        autofocus: true,
                        textCapitalization:
                            TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText: 'Example: Water pump',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: quantityController,
                        keyboardType:
                            const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          hintText: 'Example: 1',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: unitPriceController,
                        keyboardType:
                            const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Unit Price',
                          hintText: 'Example: 189.99',
                          prefixText: '\$',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 6),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Taxable'),
                        value: taxable,
                        onChanged: (value) {
                          setDialogState(() {
                            taxable = value ?? true;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final description =
                        descriptionController.text.trim();

                    final quantity = double.tryParse(
                      quantityController.text.trim(),
                    );

                    final unitPrice = double.tryParse(
                      unitPriceController.text.trim(),
                    );

                    if (description.isEmpty ||
                        quantity == null ||
                        quantity <= 0 ||
                        unitPrice == null ||
                        unitPrice < 0) {
                      _showMessage(
                        'Enter a description, valid quantity, and unit price.',
                      );
                      return;
                    }

                    setState(() {
                      widget.operation.parts.add(
                        PartItem(
                          description: description,
                          quantity: quantity,
                          unitPrice: unitPrice,
                          taxable: taxable,
                        ),
                      );
                    });

                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Save Part'),
                ),
              ],
            );
          },
        );
      },
    );

    descriptionController.dispose();
    quantityController.dispose();
    unitPriceController.dispose();
  }

  Future<void> _removeLabor(int index) async {
    final labor = widget.operation.labor[index];

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remove Labor?'),
          content: Text(
            'Remove "${labor.description}" from this operation?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    setState(() {
      widget.operation.labor.removeAt(index);
    });
  }

  Future<void> _removePart(int index) async {
    final part = widget.operation.parts[index];

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remove Part?'),
          content: Text(
            'Remove "${part.description}" from this operation?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    setState(() {
      widget.operation.parts.removeAt(index);
    });
  }

  Widget _sectionCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1624),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white12,
        ),
      ),
      child: child,
    );
  }

  Widget _sectionHeader({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onAdd,
    required String buttonLabel,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 27,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: onAdd,
          icon: Icon(
            Icons.add,
            color: color,
          ),
          label: Text(
            buttonLabel,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _laborItem(
    LaborItem labor,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white12,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.handyman_outlined,
            color: Colors.blueAccent,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  labor.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${_number(labor.hours)} hours × '
                  '${_money(labor.rate)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _money(labor.total),
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _removeLabor(index);
            },
            tooltip: 'Remove labor',
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _partItem(
    PartItem part,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white12,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            color: Colors.greenAccent,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  part.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${_number(part.quantity)} × '
                  '${_money(part.unitPrice)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      _money(part.total),
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: part.taxable
                            ? Colors.orange.withValues(alpha: 0.16)
                            : Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        part.taxable
                            ? 'Taxable'
                            : 'Non-taxable',
                        style: TextStyle(
                          color: part.taxable
                              ? Colors.orangeAccent
                              : Colors.white60,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _removePart(index);
            },
            tooltip: 'Remove part',
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalRow({
    required String label,
    required double amount,
    bool grandTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: grandTotal
                    ? Colors.white
                    : Colors.white70,
                fontSize: grandTotal ? 20 : 16,
                fontWeight: grandTotal
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
          Text(
            _money(amount),
            style: TextStyle(
              color: grandTotal
                  ? Colors.orangeAccent
                  : Colors.white,
              fontSize: grandTotal ? 25 : 17,
              fontWeight: grandTotal
                  ? FontWeight.bold
                  : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
Widget build(BuildContext context) {
  final bool isSpanish = widget.languageCode == 'es';

  return Scaffold(
      backgroundColor: const Color(0xFF050B14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050B14),
        foregroundColor: Colors.white,
        title: Text(
  isSpanish
      ? 'Detalles de la operación'
      : 'Operation Details',
),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            18,
            12,
            18,
            28,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _sectionCard(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Operation',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),

TextField(
  controller: complaintController,
  textCapitalization: TextCapitalization.sentences,
  style: const TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
  decoration: const InputDecoration(
    labelText: 'Complaint',
    border: OutlineInputBorder(),
  ),
),

const SizedBox(height: 16),

TextField(
  controller: repairController,
  minLines: 5,
  maxLines: 10,
  textCapitalization: TextCapitalization.sentences,
  decoration: InputDecoration(
    labelText: 'Repair Description',
    hintText: 'Describe how you repaired the complaint...',
    border: const OutlineInputBorder(),
   suffixIcon: IconButton(
  icon: Icon(
    isListening ? Icons.stop : Icons.mic,
  ),
  onPressed: _toggleListening,
),
  ),
),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _sectionCard(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    _sectionHeader(
                      title: 'Labor',
                      icon: Icons.handyman_outlined,
                      color: Colors.blueAccent,
                      onAdd: _showAddLaborDialog,
                      buttonLabel: 'Add Labor',
                    ),
                    if (widget.operation.labor.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text(
                          'No labor added yet.',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 16,
                          ),
                        ),
                      )
                    else
                      ...widget.operation.labor
                          .asMap()
                          .entries
                          .map(
                            (entry) => _laborItem(
                              entry.value,
                              entry.key,
                            ),
                          ),
                    if (widget.operation.labor.isNotEmpty) ...[
                      const Divider(
                        color: Colors.white12,
                        height: 30,
                      ),
                      _totalRow(
                        label: 'Labor Total',
                        amount:
                            widget.operation.laborTotal,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _sectionCard(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    _sectionHeader(
                      title: 'Parts',
                      icon: Icons.inventory_2_outlined,
                      color: Colors.greenAccent,
                      onAdd: _showAddPartDialog,
                      buttonLabel: 'Add Part',
                    ),
                    if (widget.operation.parts.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text(
                          'No parts added yet.',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 16,
                          ),
                        ),
                      )
                    else
                      ...widget.operation.parts
                          .asMap()
                          .entries
                          .map(
                            (entry) => _partItem(
                              entry.value,
                              entry.key,
                            ),
                          ),
                    if (widget.operation.parts.isNotEmpty) ...[
                      const Divider(
                        color: Colors.white12,
                        height: 30,
                      ),
                      _totalRow(
                        label: 'Parts Total',
                        amount:
                            widget.operation.partsTotal,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _sectionCard(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.notes_outlined,
                          color: Colors.amber,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Notes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.operation.notes.trim().isEmpty
                          ? 'No notes yet.'
                          : widget.operation.notes,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _sectionCard(
                child: Column(
                  children: [
                    _totalRow(
                      label: 'Labor',
                      amount: widget.operation.laborTotal,
                    ),
                    _totalRow(
                      label: 'Parts',
                      amount: widget.operation.partsTotal,
                    ),
                    const Divider(
                      color: Colors.white24,
                      height: 24,
                    ),
                    _totalRow(
                      label: 'Operation Total',
                      amount: widget.operation.total,
                      grandTotal: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
  widget.operation.title =
      complaintController.text.trim();

  widget.operation.repairDescription =
      repairController.text.trim();

  Navigator.pop(context);
},
                  icon: const Icon(
                    Icons.check,
                  ),
                  label: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}