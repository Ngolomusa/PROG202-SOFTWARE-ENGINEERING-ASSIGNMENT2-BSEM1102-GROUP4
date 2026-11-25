import 'package:flutter/material.dart';

class RegisterMedicineScreen extends StatefulWidget {
  const RegisterMedicineScreen({super.key});

  @override
  State<RegisterMedicineScreen> createState() =>
      _RegisterMedicineScreenState();
}

class _RegisterMedicineScreenState extends State<RegisterMedicineScreen> {
  final _formKey = GlobalKey<FormState>();

  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();

  String? _selectedUnit;

  final List<String> _units = const [
    'Tablets',
    'Capsules',
    'Bottles',
    'Vials',
    'Sachets',
    'Packs',
    'Other',
  ];

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _registerMedicine() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${_nameController.text.trim()} passed validation.',
        ),
        backgroundColor: const Color(0xFF137C72),
      ),
    );

    _formKey.currentState!.reset();
    _idController.clear();
    _nameController.clear();
    _categoryController.clear();

    setState(() {
      _selectedUnit = null;
    });
  }

  InputDecoration _fieldDecoration({
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
        borderSide: const BorderSide(color: Color(0xFFDCE5E2)),
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
          'Register medicine',
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
                      Icons.medication_outlined,
                      color: Color(0xFF137C72),
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add a medicine',
                            style: TextStyle(
                              color: Color(0xFF16312D),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Enter the medicine details below. All fields are required.',
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

              TextFormField(
                controller: _idController,
                textCapitalization: TextCapitalization.characters,
                decoration: _fieldDecoration(
                  label: 'Medicine ID',
                  hint: 'Example: MED006',
                  icon: Icons.tag,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a medicine ID';
                  }
                  if (value.trim().length < 3) {
                    return 'ID must contain at least 3 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: _fieldDecoration(
                  label: 'Medicine name',
                  hint: 'Example: Paracetamol 500 mg',
                  icon: Icons.medication,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter the medicine name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _categoryController,
                textCapitalization: TextCapitalization.words,
                decoration: _fieldDecoration(
                  label: 'Category',
                  hint: 'Example: Pain relief',
                  icon: Icons.category_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedUnit,
                decoration: _fieldDecoration(
                  label: 'Stock unit',
                  hint: 'Choose a unit',
                  icon: Icons.inventory_2_outlined,
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
                    return 'Choose a stock unit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: _registerMedicine,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text(
                    'Save medicine',
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
              const SizedBox(height: 10),

              const Text(
                'This screen currently checks the form and displays a confirmation. We’ll connect it to the medicine list later.',
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