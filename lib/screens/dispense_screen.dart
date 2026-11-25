import 'package:flutter/material.dart';

class DispenseScreen extends StatefulWidget {
  const DispenseScreen({super.key});

  @override
  State<DispenseScreen> createState() => _DispenseScreenState();
}

class _DispenseScreenState extends State<DispenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _recipientReferenceController = TextEditingController();

  String? _selectedMedicine;

  // Sample stock counts for preview. We’ll connect this to shared inventory
  // data later.
  final Map<String, int> _stock = {
    'Paracetamol 500 mg': 42,
    'Amoxicillin 250 mg': 5,
    'ORS sachets': 18,
    'Artemether-Lumefantrine': 12,
    'Zinc Sulphate 20 mg': 32,
  };

  @override
  void dispose() {
    _quantityController.dispose();
    _recipientReferenceController.dispose();
    super.dispose();
  }

  void _dispenseMedicine() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final medicine = _selectedMedicine!;
    final quantity = int.parse(_quantityController.text.trim());
    final available = _stock[medicine] ?? 0;

    if (quantity > available) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Only $available units of $medicine are available.'),
        ),
      );
      return;
    }

    setState(() {
      _stock[medicine] = available - quantity;
      _quantityController.clear();
      _recipientReferenceController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dispensed $quantity units of $medicine.'),
        backgroundColor: const Color(0xFF137C72),
      ),
    );
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
    final available = _selectedMedicine == null
        ? null
        : _stock[_selectedMedicine];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dispense medicine',
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
                  color: const Color(0xFFE4F3EF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.outbox_outlined,
                      color: Color(0xFF137C72),
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Record medicine dispensed',
                            style: TextStyle(
                              color: Color(0xFF16312D),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Choose the medicine and enter the amount given out at the health facility.',
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
                items: _stock.keys.map((medicine) {
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
              const SizedBox(height: 12),

              if (available != null)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE7EEEB)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.inventory_2_outlined,
                        color: Color(0xFF137C72),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Available stock: $available units',
                          style: const TextStyle(
                            color: Color(0xFF16312D),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: _decoration(
                  label: 'Quantity to dispense',
                  hint: 'Enter a whole number',
                  icon: Icons.numbers,
                ),
                validator: (value) {
                  final quantity = int.tryParse(value?.trim() ?? '');

                  if (quantity == null || quantity <= 0) {
                    return 'Enter a quantity greater than zero';
                  }

                  final currentStock = _selectedMedicine == null
                      ? 0
                      : _stock[_selectedMedicine] ?? 0;

                  if (quantity > currentStock) {
                    return 'Quantity cannot exceed available stock ($currentStock)';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _recipientReferenceController,
                textCapitalization: TextCapitalization.characters,
                decoration: _decoration(
                  label: 'Recipient reference',
                  hint: 'Example: clinic card number or initials',
                  icon: Icons.badge_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a recipient reference';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),

              const Text(
                'Use a clinic card number or initials rather than entering unnecessary personal details.',
                style: TextStyle(
                  color: Color(0xFF62736E),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: _dispenseMedicine,
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text(
                    'Confirm dispensing',
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
                'This preview updates the sample quantity on this screen only. We’ll connect it to the shared inventory later.',
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