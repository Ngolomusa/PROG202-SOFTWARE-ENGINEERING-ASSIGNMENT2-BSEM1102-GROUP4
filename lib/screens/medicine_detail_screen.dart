import 'package:flutter/material.dart';

class MedicineDetailScreen extends StatelessWidget {
  const MedicineDetailScreen({super.key});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sample values for preview. Later, we’ll pass real medicine data here.
    const medicineName = 'Paracetamol 500 mg';
    const medicineId = 'MED001';
    const category = 'Pain relief';
    const unit = 'Tablets';
    const quantity = 42;
    const reorderLevel = 20;
    const expiryDate = '25 July 2027';

    final isLowStock = quantity <= reorderLevel;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Medicine details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
          children: [
            Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFFE7EEEB)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 27,
                      backgroundColor: Color(0xFFE4F3EF),
                      child: Icon(
                        Icons.medication_outlined,
                        color: Color(0xFF137C72),
                        size: 29,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            medicineName,
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF16312D),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            '$medicineId • $category',
                            style: TextStyle(color: Color(0xFF62736E)),
                          ),
                          const SizedBox(height: 10),
                          _MedicineStatus(isLowStock: isLowStock),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Stock summary',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF16312D),
              ),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    label: 'Available',
                    value: '$quantity',
                    unit: unit.toLowerCase(),
                    icon: Icons.inventory_2_outlined,
                    color: const Color(0xFF137C72),
                    background: const Color(0xFFE4F3EF),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    label: 'Reorder level',
                    value: '$reorderLevel',
                    unit: unit.toLowerCase(),
                    icon: Icons.flag_outlined,
                    color: const Color(0xFF4355A6),
                    background: const Color(0xFFEAF0FF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),

            const Text(
              'Medicine information',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF16312D),
              ),
            ),
            const SizedBox(height: 10),

            Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: Color(0xFFE7EEEB)),
              ),
              child: const Column(
                children: [
                  _InformationRow(
                    icon: Icons.tag,
                    label: 'Medicine ID',
                    value: medicineId,
                  ),
                  Divider(height: 1, indent: 16, endIndent: 16),
                  _InformationRow(
                    icon: Icons.category_outlined,
                    label: 'Category',
                    value: category,
                  ),
                  Divider(height: 1, indent: 16, endIndent: 16),
                  _InformationRow(
                    icon: Icons.straighten_outlined,
                    label: 'Stock unit',
                    value: unit,
                  ),
                  Divider(height: 1, indent: 16, endIndent: 16),
                  _InformationRow(
                    icon: Icons.event_outlined,
                    label: 'Expiry date',
                    value: expiryDate,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            const Text(
              'Actions',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF16312D),
              ),
            ),
            const SizedBox(height: 10),

            OutlinedButton.icon(
              onPressed: () {
                _showMessage(
                  context,
                  'The Receive Stock screen comes next.',
                );
              },
              icon: const Icon(Icons.move_to_inbox_outlined),
              label: const Text('Receive stock'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF137C72),
                minimumSize: const Size.fromHeight(48),
                side: const BorderSide(color: Color(0xFF137C72)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 10),

            FilledButton.icon(
              onPressed: () {
                _showMessage(
                  context,
                  'The Dispense Medicine screen comes next.',
                );
              },
              icon: const Icon(Icons.outbox_outlined),
              label: const Text('Dispense medicine'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF137C72),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 12),

            const Text(
              'This screen is using sample medicine information for now.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF62736E),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MedicineStatus extends StatelessWidget {
  const _MedicineStatus({required this.isLowStock});

  final bool isLowStock;

  @override
  Widget build(BuildContext context) {
    final color = isLowStock
        ? const Color(0xFFB54708)
        : const Color(0xFF137C72);
    final background = isLowStock
        ? const Color(0xFFFFF1DC)
        : const Color(0xFFE4F3EF);
    final label = isLowStock ? 'Low stock' : 'In stock';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.background,
  });

  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFE7EEEB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 19,
              backgroundColor: background,
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF16312D),
              ),
            ),
            Text(
              unit,
              style: const TextStyle(
                color: Color(0xFF62736E),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF62736E),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InformationRow extends StatelessWidget {
  const _InformationRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF137C72), size: 21),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF62736E)),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF16312D),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}