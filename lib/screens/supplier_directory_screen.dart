import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class SupplierDirectoryScreen extends StatefulWidget {
  const SupplierDirectoryScreen({super.key});

  @override
  State<SupplierDirectoryScreen> createState() =>
      _SupplierDirectoryScreenState();
}

class _SupplierDirectoryScreenState extends State<SupplierDirectoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<_Supplier> _suppliers = const [
    _Supplier(
      name: 'District Medical Store',
      location: 'Bo District',
      phone: '+232 76 123 456',
      supplies: 'Essential medicines',
    ),
    _Supplier(
      name: 'Central Medical Stores',
      location: 'Freetown',
      phone: '+232 77 234 567',
      supplies: 'Medicines and medical supplies',
    ),
    _Supplier(
      name: 'Community Health Supply',
      location: 'Kenema District',
      phone: '+232 78 345 678',
      supplies: 'Basic medicines',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_Supplier> get _filteredSuppliers {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) return _suppliers;

    return _suppliers.where((supplier) {
      return supplier.name.toLowerCase().contains(query) ||
          supplier.location.toLowerCase().contains(query) ||
          supplier.supplies.toLowerCase().contains(query);
    }).toList();
  }

  void _showAddSupplierMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('The Add Supplier screen comes next.'),
      ),
    );
  }

  void _showSupplierMessage(_Supplier supplier) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${supplier.name} selected.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final suppliers = _filteredSuppliers;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Supplier directory',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 12, 18, 4),
              child: Text(
                'Medicine suppliers',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF16312D),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                'Find supplier contacts used by this health facility.',
                style: TextStyle(
                  color: Color(0xFF62736E),
                  height: 1.4,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search supplier or location',
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
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                '${suppliers.length} supplier${suppliers.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  color: Color(0xFF62736E),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: suppliers.isEmpty
                  ? const Center(
                child: Text('No suppliers match your search.'),
              )
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 90),
                itemCount: suppliers.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final supplier = suppliers[index];

                  return _SupplierCard(
                    supplier: supplier,
                    onTap: () => _showSupplierMessage(supplier),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSupplierMessage,
        backgroundColor: const Color(0xFF137C72),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add supplier'),
      ),
    );
  }
}

class _Supplier {
  const _Supplier({
    required this.name,
    required this.location,
    required this.phone,
    required this.supplies,
  });

  final String name;
  final String location;
  final String phone;
  final String supplies;
}

class _SupplierCard extends StatelessWidget {
  const _SupplierCard({
    required this.supplier,
    required this.onTap,
  });

  final _Supplier supplier;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
            Icons.local_shipping_outlined,
            color: Color(0xFF137C72),
          ),
        ),
        title: Text(
          supplier.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF16312D),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '${supplier.location}\n${supplier.phone}\n${supplier.supplies}',
          ),
        ),
        isThreeLine: true,
        trailing: const Icon(
          Icons.chevron_right,
          color: Color(0xFF62736E),
        ),
      ),
    );
  }
}