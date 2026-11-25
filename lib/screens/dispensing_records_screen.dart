import 'package:flutter/material.dart';

class DispensingRecordsScreen extends StatefulWidget {
  const DispensingRecordsScreen({super.key});

  @override
  State<DispensingRecordsScreen> createState() =>
      _DispensingRecordsScreenState();
}

class _DispensingRecordsScreenState extends State<DispensingRecordsScreen> {
  String _selectedFilter = 'All';

  late final List<_DispensingEntry> _records;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    // Example records for preview. We’ll connect these to the app’s
    // shared inventory data later.
    _records = [
      _DispensingEntry(
        recordId: 'DSP-004',
        medicine: 'Paracetamol 500 mg',
        quantity: 10,
        unit: 'tablets',
        recipient: 'OPD-104',
        date: now.subtract(const Duration(minutes: 45)),
      ),
      _DispensingEntry(
        recordId: 'DSP-003',
        medicine: 'Amoxicillin 250 mg',
        quantity: 5,
        unit: 'capsules',
        recipient: 'OPD-102',
        date: now.subtract(const Duration(hours: 3)),
      ),
      _DispensingEntry(
        recordId: 'DSP-002',
        medicine: 'ORS sachets',
        quantity: 2,
        unit: 'sachets',
        recipient: 'OPD-098',
        date: now.subtract(const Duration(days: 2)),
      ),
      _DispensingEntry(
        recordId: 'DSP-001',
        medicine: 'Zinc Sulphate 20 mg',
        quantity: 10,
        unit: 'tablets',
        recipient: 'OPD-091',
        date: now.subtract(const Duration(days: 5)),
      ),
    ];
  }

  List<_DispensingEntry> get _filteredRecords {
    final now = DateTime.now();

    if (_selectedFilter == 'Today') {
      return _records.where((record) {
        return record.date.year == now.year &&
            record.date.month == now.month &&
            record.date.day == now.day;
      }).toList();
    }

    if (_selectedFilter == 'This week') {
      final today = DateTime(now.year, now.month, now.day);
      final weekStart = today.subtract(Duration(days: now.weekday - 1));

      return _records.where((record) {
        return !record.date.isBefore(weekStart);
      }).toList();
    }

    return _records;
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final now = DateTime.now();
    final isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;

    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final time = '$hour:$minute $period';

    if (isToday) {
      return 'Today • $time';
    }

    return '${date.day} ${months[date.month - 1]} ${date.year} • $time';
  }

  @override
  Widget build(BuildContext context) {
    final records = _filteredRecords;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dispensing records',
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
                'Dispensing history',
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
                'Review medicines issued to patients or departments at this facility.',
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
                children: ['All', 'Today', 'This week'].map((filter) {
                  final isSelected = _selectedFilter == filter;

                  return ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    selectedColor: const Color(0xFFE4F3EF),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? const Color(0xFF137C72)
                          : const Color(0xFF62736E),
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide(
                      color: isSelected
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
                child: Text('No dispensing records for this filter.'),
              )
                  : ListView.separated(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                itemCount: records.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final record = records[index];

                  return _DispensingRecordCard(
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

class _DispensingEntry {
  const _DispensingEntry({
    required this.recordId,
    required this.medicine,
    required this.quantity,
    required this.unit,
    required this.recipient,
    required this.date,
  });

  final String recordId;
  final String medicine;
  final int quantity;
  final String unit;
  final String recipient;
  final DateTime date;
}

class _DispensingRecordCard extends StatelessWidget {
  const _DispensingRecordCard({
    required this.record,
    required this.formattedDate,
  });

  final _DispensingEntry record;
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
              backgroundColor: Color(0xFFEAF0FF),
              child: Icon(
                Icons.outbox_outlined,
                color: Color(0xFF4355A6),
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
                    'Recipient: ${record.recipient}',
                    style: const TextStyle(
                      color: Color(0xFF62736E),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${record.recordId} • $formattedDate',
                    style: const TextStyle(
                      color: Color(0xFF62736E),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '−${record.quantity}',
              style: const TextStyle(
                color: Color(0xFF4355A6),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}