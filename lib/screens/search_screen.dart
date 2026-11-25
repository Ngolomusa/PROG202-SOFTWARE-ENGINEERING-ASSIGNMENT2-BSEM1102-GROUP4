import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Sample medicines for the screen preview.
  final List<SearchMedicine> _medicines = const [
    SearchMedicine(
      id: 'MED001',
      name: 'Paracetamol 500 mg',
      category: 'Pain relief',
      quantity: 42,
      unit: 'tablets',
    ),
    SearchMedicine(
      id: 'MED002',
      name: 'Amoxicillin 250 mg',
      category: 'Antibiotic',
      quantity: 5,
      unit: 'capsules',
    ),
    SearchMedicine(
      id: 'MED003',
      name: 'ORS sachets',
      category: 'Rehydration',
      quantity: 18,
      unit: 'sachets',
    ),
    SearchMedicine(
      id: 'MED004',
      name: 'Artemether-Lumefantrine',
      category: 'Antimalarial',
      quantity: 0,
      unit: 'packs',
    ),
    SearchMedicine(
      id: 'MED005',
      name: 'Zinc Sulphate 20 mg',
      category: 'Supplement',
      quantity: 32,
      unit: 'tablets',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SearchMedicine> get _results {
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

  void _showMedicineMessage(SearchMedicine medicine) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${medicine.name} selected.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search medicines',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search name, ID, or category',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
                    tooltip: 'Clear search',
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                    icon: const Icon(Icons.close),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color(0xFFDCE5E2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color(0xFF137C72),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                _searchController.text.trim().isEmpty
                    ? 'All medicines (${results.length})'
                    : '${results.length} result${results.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  color: Color(0xFF62736E),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: results.isEmpty
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 48,
                        color: Color(0xFF8A9994),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No medicines found',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF16312D),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Try searching with a different name, ID, or category.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF62736E),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                itemCount: results.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final medicine = results[index];

                  return _SearchMedicineCard(
                    medicine: medicine,
                    onTap: () => _showMedicineMessage(medicine),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchMedicine {
  const SearchMedicine({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
  });

  final String id;
  final String name;
  final String category;
  final int quantity;
  final String unit;
}

class _SearchMedicineCard extends StatelessWidget {
  const _SearchMedicineCard({
    required this.medicine,
    required this.onTap,
  });

  final SearchMedicine medicine;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = medicine.quantity == 0;
    final isLowStock = medicine.quantity > 0 && medicine.quantity <= 10;

    final status = isOutOfStock
        ? 'Out of stock'
        : isLowStock
        ? 'Low stock'
        : 'In stock';

    final statusColor = isOutOfStock
        ? const Color(0xFFB42318)
        : isLowStock
        ? const Color(0xFFB54708)
        : const Color(0xFF137C72);

    final statusBackground = isOutOfStock
        ? const Color(0xFFFFE9E7)
        : isLowStock
        ? const Color(0xFFFFF1DC)
        : const Color(0xFFE4F3EF);

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
        side: const BorderSide(color: Color(0xFFE7EEEB)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
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
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${medicine.id} • ${medicine.category}'),
              const SizedBox(height: 7),
              Text(
                'Stock: ${medicine.quantity} ${medicine.unit}',
                style: const TextStyle(
                  color: Color(0xFF16312D),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        isThreeLine: true,
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
      ),
    );
  }
}