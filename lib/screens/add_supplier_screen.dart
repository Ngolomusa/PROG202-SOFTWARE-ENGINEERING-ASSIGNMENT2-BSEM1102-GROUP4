import 'package:flutter/material.dart';

class AddSupplierScreen extends StatefulWidget {
  const AddSupplierScreen({super.key});

  @override
  State<AddSupplierScreen> createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _suppliesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _suppliesController.dispose();
    super.dispose();
  }

  void _saveSupplier() {
    if (!_formKey.currentState!.validate()) return;

    final supplierName = _nameController.text.trim();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$supplierName passed validation.'),
        backgroundColor: const Color(0xFF137C72),
      ),
    );

    _formKey.currentState!.reset();
    _nameController.clear();
    _contactController.clear();
    _phoneController.clear();
    _locationController.clear();
    _suppliesController.clear();
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

  String? _required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter $fieldName';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add supplier',
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
                      Icons.local_shipping_outlined,
                      color: Color(0xFF137C72),
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Supplier information',
                            style: TextStyle(
                              color: Color(0xFF16312D),
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Add the contact and supply details for a medicine supplier.',
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
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: _decoration(
                  label: 'Supplier name',
                  hint: 'Example: District Medical Store',
                  icon: Icons.business_outlined,
                ),
                validator: (value) => _required(value, 'the supplier name'),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _contactController,
                textCapitalization: TextCapitalization.words,
                decoration: _decoration(
                  label: 'Contact person',
                  hint: 'Name of the main contact',
                  icon: Icons.person_outline,
                ),
                validator: (value) => _required(value, 'a contact person'),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: _decoration(
                  label: 'Phone number',
                  hint: 'Example: +232 76 123 456',
                  icon: Icons.phone_outlined,
                ),
                validator: (value) {
                  final phone = value?.trim() ?? '';
                  if (phone.isEmpty) return 'Enter a phone number';

                  final digits = phone.replaceAll(RegExp(r'\D'), '');
                  if (digits.length < 7) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _locationController,
                textCapitalization: TextCapitalization.words,
                decoration: _decoration(
                  label: 'Location or district',
                  hint: 'Example: Bo District',
                  icon: Icons.location_on_outlined,
                ),
                validator: (value) => _required(value, 'a location'),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _suppliesController,
                textCapitalization: TextCapitalization.sentences,
                minLines: 2,
                maxLines: 3,
                decoration: _decoration(
                  label: 'Medicines or supplies provided',
                  hint: 'Example: Essential medicines',
                  icon: Icons.inventory_2_outlined,
                ),
                validator: (value) =>
                    _required(value, 'the supplies provided'),
              ),
              const SizedBox(height: 24),

              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: _saveSupplier,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text(
                    'Save supplier',
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
                'Preview only: this form validates the details but does not yet add the supplier to the directory.',
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