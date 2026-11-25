import 'package:flutter/material.dart';

class MedicineDirectoryScreen extends StatefulWidget {
  const MedicineDirectoryScreen({super.key});

  @override
  State<MedicineDirectoryScreen> createState() =>
      _MedicineDirectoryScreenState();
}

class _MedicineDirectoryScreenState extends State<MedicineDirectoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<MedicineInfo> _medicines = const [
    MedicineInfo(
      id: 'MED001',
      name: 'Paracetamol 500 mg',
      category: 'Pain relief',
      unit: 'Tablets',
      stock: 42,
    ),
    MedicineInfo(
      id: 'MED002',
      name: 'Amoxicillin 250 mg',
      category: 'Antibiotic',
      unit: 'Capsules',
      stock: 5,
    ),
    MedicineInfo(
      id: 'MED003',
      name: 'ORS sachets',
      category: 'Rehydration',
      unit: 'Sachets',
      stock: 18,
    ),
    MedicineInfo(
      id: 'MED004',
      name: 'Artemether-Lumefantrine',
      category: 'Antimalarial',
      unit: 'Packs',
      stock: 0,
    ),
    MedicineInfo(
      id: 'MED005',
      name: 'Zinc Sulphate 20 mg',
      category: 'Supplement',
      unit: 'Tablets',
      stock: 32,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MedicineInfo> get _filteredMedicines {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return _medicines;
    }

    return _medicines.where((medicine) {
      return medicine.name.toLowerCase().contains(query) ||
          medicine.id.toLowerCase().contains(query) ||
          medicine.category.toLowerCase().contains(query);
    }).toList();
  }

  void _showRegisterMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('The Register Medicine screen comes next.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final medicines = _filteredMedicines;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Medicine directory',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search by name, ID, or category',
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
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${medicines.length} medicines',
                  style: const TextStyle(
                    color: Color(0xFF62736E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: medicines.isEmpty
                  ? const Center(
                child: Text('No medicines match your search.'),
              )
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 100),
                itemCount: medicines.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final medicine = medicines[index];

                  return MedicineDirectoryCard(
                    medicine: medicine,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${medicine.name} details come next.',
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showRegisterMessage,
        backgroundColor: const Color(0xFF137C72),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Register medicine'),
      ),
    );
  }
}

class MedicineInfo {
  const MedicineInfo({
    required this.id,
    required this.name,
    required this.category,
    required this.unit,
    required this.stock,
  });

  final String id;
  final String name;
  final String category;
  final String unit;
  final int stock;
}

class MedicineDirectoryCard extends StatelessWidget {
  const MedicineDirectoryCard({
    super.key,
    required this.medicine,
    required this.onTap,
  });

  final MedicineInfo medicine;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = medicine.stock == 0;

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFE7EEEB)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        onTap: onTap,
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE4F3EF),
          child: Icon(
            Icons.medication_outlined,
            color: Color(0xFF137C72),
          ),
        ),
        title: Text(
          medicine.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF16312D),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            '${medicine.id} • ${medicine.category}\n'
                'Stock: ${medicine.stock} ${medicine.unit.toLowerCase()}',
          ),
        ),
        isThreeLine: true,
        trailing: Icon(
          isOutOfStock ? Icons.error_outline : Icons.chevron_right,
          color: isOutOfStock
              ? const Color(0xFFB42318)
              : const Color(0xFF62736E),
        ),
      ),
    );
  }
}