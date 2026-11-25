import 'package:flutter/material.dart';

class ReceiveStockScreen extends StatefulWidget {
  const ReceiveStockScreen({super.key});

  @override
  State<ReceiveStockScreen> createState() => _ReceiveStockScreenState();
}

class _ReceiveStockScreenState extends State<ReceiveStockScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _supplierController = TextEditingController();
  final _batchController = TextEditingController();

  String? _selectedMedicine;
  String? _selectedUnit;
  DateTime? _expiryDate;

  final List<String> _medicines = const [
    'Paracetamol 500 mg',
    'Amoxicillin 250 mg',
    'ORS sachets',
    'Artemether-Lumefantrine',
    'Zinc Sulphate 20 mg',
  ];

  final List<String> _units = const [
    'Tablets',
    'Capsules',
    'Bottles',
    'Vials',
    'Sachets',
    'Packs',
  ];

  @override
  void dispose() {
    _quantityController.dispose();
    _supplierController.dispose();
    _batchController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _chooseExpiryDate() async {
    final today = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? today,
      firstDate: today,
      lastDate: DateTime(today.year + 20),
      helpText: 'Select medicine expiry date',
    );

    if (pickedDate != null) {
      setState(() {
        _expiryDate = pickedDate;
      });
    }
  }

  void _receiveStock() {
    if (!_formKey.currentState!.validate()) return;

    if (_expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an expiry date.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Received ${_quantityController.text.trim()} '
              '$_selectedUnit of $_selectedMedicine.',
        ),
        backgroundColor: const Color(0xFF137C72),
      ),
    );

    _formKey.currentState!.reset();
    _quantityController.clear();
    _supplierController.clear();
    _batchController.clear();

    setState(() {
      _selectedMedicine = null;
      _selectedUnit = null;
      _expiryDate = null;
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
          'Receive stock',
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
                      Icons.move_to_inbox_outlined,
                      color: Color(0xFF137C72),
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Record a delivery',
                            style: TextStyle(
                              color: Color(0xFF16312D),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Enter the medicine and delivery details received at this health facility.',
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

              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: _decoration(
                  label: 'Quantity received',
                  hint: 'Enter the amount delivered',
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

              DropdownButtonFormField<String>(
                value: _selectedUnit,
                decoration: _decoration(
                  label: 'Unit',
                  hint: 'Choose the stock unit',
                  icon: Icons.straighten_outlined,
                ),
                items: _units.map((unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedUnit = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Choose a unit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _supplierController,
                textCapitalization: TextCapitalization.words,
                decoration: _decoration(
                  label: 'Supplier or source',
                  hint: 'Example: District Medical Store',
                  icon: Icons.local_shipping_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter the supplier or source';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _batchController,
                textCapitalization: TextCapitalization.characters,
                decoration: _decoration(
                  label: 'Batch number',
                  hint: 'Enter the batch number',
                  icon: Icons.confirmation_number_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter the batch number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              InkWell(
                onTap: _chooseExpiryDate,
                borderRadius: BorderRadius.circular(14),
                child: InputDecorator(
                  decoration: _decoration(
                    label: 'Expiry date',
                    hint: 'Tap to choose the expiry date',
                    icon: Icons.event_outlined,
                  ),
                  child: Text(
                    _expiryDate == null
                        ? 'Tap to choose the expiry date'
                        : _formatDate(_expiryDate!),
                    style: TextStyle(
                      color: _expiryDate == null
                          ? const Color(0xFF62736E)
                          : const Color(0xFF16312D),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: _receiveStock,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text(
                    'Record delivery',
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
                'This screen currently validates the form and shows a confirmation. We’ll connect it to the stock list later.',
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