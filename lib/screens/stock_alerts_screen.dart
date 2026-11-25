import 'package:flutter/material.dart';

class StockAlertsScreen extends StatelessWidget {
  const StockAlertsScreen({super.key});

  static const List<StockAlert> _lowStockAlerts = [
    StockAlert(
      medicineName: 'Amoxicillin 250 mg',
      details: '5 capsules remaining • Reorder level: 20',
      status: 'Low stock',
      icon: Icons.warning_amber_rounded,
      color: Color(0xFFB54708),
      background: Color(0xFFFFF1DC),
    ),
    StockAlert(
      medicineName: 'ORS sachets',
      details: '8 sachets remaining • Reorder level: 15',
      status: 'Low stock',
      icon: Icons.warning_amber_rounded,
      color: Color(0xFFB54708),
      background: Color(0xFFFFF1DC),
    ),
    StockAlert(
      medicineName: 'Artemether-Lumefantrine',
      details: '3 packs remaining • Reorder level: 10',
      status: 'Very low',
      icon: Icons.error_outline,
      color: Color(0xFFB42318),
      background: Color(0xFFFFE9E7),
    ),
  ];

  static const List<StockAlert> _expiryAlerts = [
    StockAlert(
      medicineName: 'Paracetamol 500 mg',
      details: 'Batch PCM2408 • Expires in 12 days',
      status: 'Expiring soon',
      icon: Icons.event_busy_outlined,
      color: Color(0xFFB42318),
      background: Color(0xFFFFE9E7),
    ),
    StockAlert(
      medicineName: 'Zinc Sulphate 20 mg',
      details: 'Batch ZNC2411 • Expires in 25 days',
      status: 'Expiring soon',
      icon: Icons.event_busy_outlined,
      color: Color(0xFFB54708),
      background: Color(0xFFFFF1DC),
    ),
    StockAlert(
      medicineName: 'ORS sachets',
      details: 'Batch ORS2502 • Expires in 40 days',
      status: 'Upcoming expiry',
      icon: Icons.event_outlined,
      color: Color(0xFF4355A6),
      background: Color(0xFFEAF0FF),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Stock alerts',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.warning_amber_rounded),
                text: 'Low stock',
              ),
              Tab(
                icon: Icon(Icons.event_busy_outlined),
                text: 'Expiring soon',
              ),
            ],
          ),
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [
              _AlertList(
                alerts: _lowStockAlerts,
                heading: 'Medicines to reorder',
                description:
                'These medicines are at or below their sample reorder levels.',
              ),
              _AlertList(
                alerts: _expiryAlerts,
                heading: 'Check these expiry dates',
                description:
                'Review these batches and follow your facility’s stock procedures.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StockAlert {
  const StockAlert({
    required this.medicineName,
    required this.details,
    required this.status,
    required this.icon,
    required this.color,
    required this.background,
  });

  final String medicineName;
  final String details;
  final String status;
  final IconData icon;
  final Color color;
  final Color background;
}

class _AlertList extends StatelessWidget {
  const _AlertList({
    required this.alerts,
    required this.heading,
    required this.description,
  });

  final List<StockAlert> alerts;
  final String heading;
  final String description;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
      children: [
        Text(
          heading,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF16312D),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: const TextStyle(
            color: Color(0xFF62736E),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFE4F3EF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.assessment_outlined,
                color: Color(0xFF137C72),
              ),
              const SizedBox(width: 10),
              Text(
                '${alerts.length} alert${alerts.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  color: Color(0xFF16312D),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ...alerts.map((alert) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _AlertCard(alert: alert),
        )),
        const SizedBox(height: 4),
        const Text(
          'Alert information shown here is sample data for the screen preview.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF62736E),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert});

  final StockAlert alert;

  @override
  Widget build(BuildContext context) {
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
        leading: CircleAvatar(
          backgroundColor: alert.background,
          child: Icon(alert.icon, color: alert.color),
        ),
        title: Text(
          alert.medicineName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF16312D),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(alert.details),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: alert.background,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            alert.status,
            style: TextStyle(
              color: alert.color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}