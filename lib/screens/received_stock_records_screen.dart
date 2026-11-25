import 'package:flutter/material.dart';

class ReceivedStockRecordsScreen extends StatefulWidget {
  const ReceivedStockRecordsScreen({super.key});

  @override
  State<ReceivedStockRecordsScreen> createState() =>
      _ReceivedStockRecordsScreenState();
}

class _ReceivedStockRecordsScreenState
    extends State<ReceivedStockRecordsScreen> {
  String _selectedFilter = 'All';

  late final List<_DeliveryRecord> _records;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    // Sample delivery records for the screen preview.
    _records = [
      _DeliveryRecord(
        medicine: 'Paracetamol 500 mg',
        quantity: 100,
        unit: 'tablets',
        supplier: 'District Medical Store',
        batch: 'PCM-2608',
        date: now.subtract(const Duration(days: 1)),
      ),
      _DeliveryRecord(
        medicine: 'ORS sachets',
        quantity: 40,
        unit: 'sachets',
        supplier: 'District Medical Store',
        batch: 'ORS-2610',
        date: now.subtract(const Duration(days: 4)),
      ),
      _DeliveryRecord(
        medicine: 'Amoxicillin 250 mg',
        quantity: 60,
        unit: 'capsules',
        supplier: 'Central Medical Stores',
        batch: 'AMX-2605',
        date: now.subtract(const Duration(days: 12)),
      ),
      _DeliveryRecord(
        medicine: 'Zinc Sulphate 20 mg',
        quantity: 50,
        unit: 'tablets',
        supplier: 'District Medical Store',
        batch: 'ZNC-2603',
        date: now.subtract(const Duration(days: 38)),
      ),
    ];
  }

  List<_DeliveryRecord> get _filteredRecords {
    if (_selectedFilter == 'This month') {
      final now = DateTime.now();

      return _records.where((record) {
        return record.date.year == now.year &&
            record.date.month == now.month;
      }).toList();
    }

    return _records;
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final records = _filteredRecords;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Received stock records',
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
                'Delivery history',
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
                'Review stock deliveries received at this health facility.',
                style: TextStyle(
                  color: Color(0xFF62736E),
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Wrap(
                spacing: 8,
                children: ['All', 'This month'].map((filter) {
                  final selected = _selectedFilter == filter;

                  return ChoiceChip(
                    label: Text(filter),
                    selected: selected,
                    selectedColor: const Color(0xFFE4F3EF),
                    labelStyle: TextStyle(
                      color: selected
                          ? const Color(0xFF137C72)
                          : const Color(0xFF62736E),
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                '${records.length} delivery record${records.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  color: Color(0xFF62736E),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: records.isEmpty
                  ? const Center(
                child: Text('No delivery records for this filter.'),
              )
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                itemCount: records.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final record = records[index];

                  return _DeliveryRecordCard(
                    record: record,
                    formattedDate: _formatDate(record.date),
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

class _DeliveryRecord {
  const _DeliveryRecord({
    required this.medicine,
    required this.quantity,
    required this.unit,
    required this.supplier,
    required this.batch,
    required this.date,
  });

  final String medicine;
  final int quantity;
  final String unit;
  final String supplier;
  final String batch;
  final DateTime date;
}

class _DeliveryRecordCard extends StatelessWidget {
  const _DeliveryRecordCard({
    required this.record,
    required this.formattedDate,
  });

  final _DeliveryRecord record;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE7EEEB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFFE4F3EF),
              child: Icon(
                Icons.move_to_inbox_outlined,
                color: Color(0xFF137C72),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.medicine,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF16312D),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '+${record.quantity} ${record.unit}',
                    style: const TextStyle(
                      color: Color(0xFF137C72),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Source: ${record.supplier}',
                    style: const TextStyle(
                      color: Color(0xFF62736E),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Batch ${record.batch} • $formattedDate',
                    style: const TextStyle(
                      color: Color(0xFF62736E),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}