import 'package:flutter/material.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  static const Color _brandGreen = Color(0xFF137C72);
  static const Color _ink = Color(0xFF16312D);
  static const Color _muted = Color(0xFF62736E);

  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  late final List<_InventoryMedicine> _medicines = [
    _InventoryMedicine(
      id: 'MED001',
      name: 'Paracetamol 500 mg',
      category: 'Pain relief',
      quantity: 42,
      unit: 'tablets',
      reorderLevel: 20,
      daysToExpiry: 180,
    ),
    _InventoryMedicine(
      id: 'MED002',
      name: 'Amoxicillin 250 mg',
      category: 'Antibiotic',
      quantity: 5,
      unit: 'capsules',
      reorderLevel: 20,
      daysToExpiry: 240,
    ),
    _InventoryMedicine(
      id: 'MED003',
      name: 'ORS sachets',
      category: 'Rehydration',
      quantity: 18,
      unit: 'sachets',
      reorderLevel: 15,
      daysToExpiry: 25,
    ),
    _InventoryMedicine(
      id: 'MED004',
      name: 'Artemether-Lumefantrine',
      category: 'Antimalarial',
      quantity: 0,
      unit: 'packs',
      reorderLevel: 10,
      daysToExpiry: 120,
    ),
    _InventoryMedicine(
      id: 'MED005',
      name: 'Zinc Sulphate 20 mg',
      category: 'Supplement',
      quantity: 32,
      unit: 'tablets',
      reorderLevel: 15,
      daysToExpiry: 300,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_InventoryMedicine> get _visibleMedicines {
    final query = _searchController.text.trim().toLowerCase();

    return _medicines.where((medicine) {
      final matchesSearch = medicine.name.toLowerCase().contains(query) ||
          medicine.id.toLowerCase().contains(query) ||
          medicine.category.toLowerCase().contains(query);

      final matchesFilter = switch (_selectedFilter) {
        'Low stock' => medicine.quantity <= medicine.reorderLevel,
        'Expiring soon' => medicine.daysToExpiry <= 60,
        _ => true,
      };

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final medicines = _visibleMedicines;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Current stock',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search by medicine, ID, or category',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
                    tooltip: 'Clear search',
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: ['All', 'Low stock', 'Expiring soon'].map((filter) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: _selectedFilter == filter,
                      selectedColor: const Color(0xFFE4F3EF),
                      onSelected: (_) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${medicines.length} medicines',
                  style: const TextStyle(
                    color: _muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: medicines.isEmpty
                  ? const Center(
                child: Text('No medicines match your search or filter.'),
              )
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                itemCount: medicines.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final medicine = medicines[index];
                  final isOutOfStock = medicine.quantity == 0;
                  final isLowStock =
                      medicine.quantity <= medicine.reorderLevel;
                  final isExpiring = medicine.daysToExpiry <= 60;

                  final status = isOutOfStock
                      ? 'Out of stock'
                      : isLowStock
                      ? 'Low stock'
                      : isExpiring
                      ? 'Expiring soon'
                      : 'In stock';

                  final statusColor = isOutOfStock
                      ? const Color(0xFFB42318)
                      : isLowStock || isExpiring
                      ? const Color(0xFFB54708)
                      : _brandGreen;

                  final statusBackground = isOutOfStock
                      ? const Color(0xFFFFE9E7)
                      : isLowStock || isExpiring
                      ? const Color(0xFFFFF1DC)
                      : const Color(0xFFE4F3EF);

                  return Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Color(0xFFE7EEEB)),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFE4F3EF),
                        child: Icon(
                          Icons.medication_outlined,
                          color: _brandGreen,
                        ),
                      ),
                      title: Text(
                        medicine.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _ink,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          '${medicine.id} • ${medicine.category}\n'
                              'Stock: ${medicine.quantity} ${medicine.unit}\n'
                              'Expires in ${medicine.daysToExpiry} days',
                        ),
                      ),
                      isThreeLine: true,
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: statusBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onTap: () {
                        _showMessage(
                          '${medicine.name} selected. '
                              'Medicine details will be connected later.',
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showMessage(
          'The Receive Stock screen will be connected later.',
        ),
        backgroundColor: _brandGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.move_to_inbox_outlined),
        label: const Text('Receive stock'),
      ),
    );
  }
}

class _InventoryMedicine {
  const _InventoryMedicine({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.reorderLevel,
    required this.daysToExpiry,
  });

  final String id;
  final String name;
  final String category;
  final int quantity;
  final String unit;
  final int reorderLevel;
  final int daysToExpiry;
}