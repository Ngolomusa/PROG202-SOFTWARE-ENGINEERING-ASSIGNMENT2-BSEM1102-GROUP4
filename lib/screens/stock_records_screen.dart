import 'package:flutter/material.dart';

class StockRecordsScreen extends StatefulWidget {
  const StockRecordsScreen({super.key});

  @override
  State<StockRecordsScreen> createState() => _StockRecordsScreenState();
}

class _StockRecordsScreenState extends State<StockRecordsScreen> {
  String _selectedFilter = 'All';

  // Sample records for the screen preview.
  final List<StockRecord> _records = [
    StockRecord(
      medicine: 'Paracetamol 500 mg',
      action: 'Received',
      quantity: 100,
      unit: 'tablets',
      reference: 'District Medical Store',
      date: DateTime(2026, 11, 23, 9, 30),
    ),
    StockRecord(
      medicine: 'Amoxicillin 250 mg',
      action: 'Dispensed',
      quantity: 5,
      unit: 'capsules',
      reference: 'Recipient: OPD-104',
      date: DateTime(2026, 11, 22, 14, 15),
    ),
    StockRecord(
      medicine: 'ORS sachets',
      action: 'Received',
      quantity: 40,
      unit: 'sachets',
      reference: 'District Medical Store',
      date: DateTime(2026, 11, 21, 10, 0),
    ),
    StockRecord(
      medicine: 'Zinc Sulphate 20 mg',
      action: 'Dispensed',
      quantity: 10,
      unit: 'tablets',
      reference: 'Recipient: OPD-098',
      date: DateTime(2026, 11, 20, 11, 45),
    ),
  ];

  List<StockRecord> get _filteredRecords {
    if (_selectedFilter == 'All') return _records;

    return _records
        .where((record) => record.action == _selectedFilter)
        .toList();
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '${date.day} ${months[date.month - 1]} ${date.year} • '
        '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final records = _filteredRecords;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stock records',
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
                'Medicine activity',
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
                'Review recent deliveries and dispensing at this facility.',
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
                children: ['All', 'Received', 'Dispensed'].map((filter) {
                  return ChoiceChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    selectedColor: const Color(0xFFE4F3EF),
                    labelStyle: TextStyle(
                      color: _selectedFilter == filter
                          ? const Color(0xFF137C72)
                          : const Color(0xFF62736E),
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide(
                      color: _selectedFilter == filter
                          ? const Color(0xFF137C72)
                          : const Color(0xFFE7EEEB),
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
                '${records.length} record${records.length == 1 ? '' : 's'}',
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
                child: Text('No records for this filter.'),
              )
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                itemCount: records.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return _StockRecordCard(
                    record: records[index],
                    formattedDate: _formatDate(records[index].date),
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

class StockRecord {
  const StockRecord({
    required this.medicine,
    required this.action,
    required this.quantity,
    required this.unit,
    required this.reference,
    required this.date,
  });

  final String medicine;
  final String action;
  final int quantity;
  final String unit;
  final String reference;
  final DateTime date;
}

class _StockRecordCard extends StatelessWidget {
  const _StockRecordCard({
    required this.record,
    required this.formattedDate,
  });

  final StockRecord record;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    final received = record.action == 'Received';
    final color = received
        ? const Color(0xFF137C72)
        : const Color(0xFF4355A6);
    final background = received
        ? const Color(0xFFE4F3EF)
        : const Color(0xFFEAF0FF);
    final icon = received
        ? Icons.move_to_inbox_outlined
        : Icons.outbox_outlined;
    final sign = received ? '+' : '-';

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
            CircleAvatar(
              backgroundColor: background,
              child: Icon(icon, color: color),
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
                    '$sign${record.quantity} ${record.unit} • ${record.action}',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    record.reference,
                    style: const TextStyle(
                      color: Color(0xFF62736E),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    formattedDate,
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