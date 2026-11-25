import 'package:flutter/material.dart';

class StockAdjustmentScreen extends StatefulWidget {
  const StockAdjustmentScreen({super.key});

  @override
  State<StockAdjustmentScreen> createState() =>
      _StockAdjustmentScreenState();
}

class _StockAdjustmentScreenState extends State<StockAdjustmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedMedicine;
  String? _selectedReason;

  final List<String> _medicines = const [
    'Paracetamol 500 mg',
    'Amoxicillin 250 mg',
    'ORS sachets',
    'Artemether-Lumefantrine',
    'Zinc Sulphate 20 mg',
  ];

  final List<String> _reasons = const [
    'Damaged',
    'Expired',
    'Lost or missing',
    'Physical count correction',
  ];

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _recordAdjustment() {
    if (!_formKey.currentState!.validate()) return;

    final quantity = _quantityController.text.trim();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Recorded $quantity ${_selectedReason!.toLowerCase()} '
              'unit(s) of $_selectedMedicine.',
        ),
        backgroundColor: const Color(0xFF137C72),
      ),
    );

    _formKey.currentState!.reset();
    _quantityController.clear();
    _notesController.clear();

    setState(() {
      _selectedMedicine = null;
      _selectedReason = null;
    });
  }

  InputDecoration _decoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFDCE5E2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF137C72),
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stock adjustment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1DC),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.edit_note_outlined,
                      color: Color(0xFFB54708),
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Record a stock adjustment',
                            style: TextStyle(
                              color: Color(0xFF16312D),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Use this form to document damaged, expired, missing, or corrected stock.',
                            style: TextStyle(
                              color: Color(0xFF62736E),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              DropdownButtonFormField<String>(
                value: _selectedMedicine,
                decoration: _decoration(
                  label: 'Medicine',
                  hint: 'Choose a medicine',
                  icon: Icons.medication_outlined,
                ),
                items: _medicines.map((medicine) {
                  return DropdownMenuItem<String>(
                    value: medicine,
                    child: Text(medicine),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMedicine = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Choose a medicine';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedReason,
                decoration: _decoration(
                  label: 'Reason',
                  hint: 'Choose an adjustment reason',
                  icon: Icons.help_outline,
                ),
                items: _reasons.map((reason) {
                  return DropdownMenuItem<String>(
                    value: reason,
                    child: Text(reason),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedReason = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Choose a reason';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: _decoration(
                  label: 'Quantity affected',
                  hint: 'Enter a whole number',
                  icon: Icons.numbers,
                ),
                validator: (value) {
                  final quantity = int.tryParse(value?.trim() ?? '');
                  if (quantity == null || quantity <= 0) {
                    return 'Enter a quantity greater than zero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _notesController,
                minLines: 3,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: _decoration(
                  label: 'Notes',
                  hint: 'Add any useful details (optional)',
                  icon: Icons.notes_outlined,
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: _recordAdjustment,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text(
                    'Record adjustment',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF137C72),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              const Text(
                'Preview only: adjustments are not yet applied to the inventory quantity.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF62736E),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}