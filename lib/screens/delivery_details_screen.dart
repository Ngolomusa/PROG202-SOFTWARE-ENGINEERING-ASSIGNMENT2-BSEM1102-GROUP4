import 'package:flutter/material.dart';

class DeliveryDetailsScreen extends StatelessWidget {
  const DeliveryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample delivery information for the screen preview.
    const medicine = 'Paracetamol 500 mg';
    const deliveryId = 'REC-001';
    const supplier = 'District Medical Store';
    const batchNumber = 'PCM-2608';
    const quantity = '100 tablets';
    const receivedDate = '23 November 2026';
    const expiryDate = '31 August 2027';
    const recordedBy = 'Facility medicine clerk';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delivery details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF137C72),
                    Color(0xFF1C9A86),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(width: 9),
                      Text(
                        'Stock received',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18),
                  Text(
                    medicine,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '$deliveryId • $receivedDate',
                    style: TextStyle(color: Color(0xFFE0F3EE)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            const Text(
              'Delivery summary',
              style: TextStyle(
                color: Color(0xFF16312D),
                fontSize: 19,
                fontWeight: FontWeight.bold,
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
                  _DeliveryInfoRow(
                    icon: Icons.inventory_2_outlined,
                    label: 'Quantity received',
                    value: quantity,
                  ),
                  Divider(height: 1, indent: 16, endIndent: 16),
                  _DeliveryInfoRow(
                    icon: Icons.local_shipping_outlined,
                    label: 'Supplier or source',
                    value: supplier,
                  ),
                  Divider(height: 1, indent: 16, endIndent: 16),
                  _DeliveryInfoRow(
                    icon: Icons.confirmation_number_outlined,
                    label: 'Batch number',
                    value: batchNumber,
                  ),
                  Divider(height: 1, indent: 16, endIndent: 16),
                  _DeliveryInfoRow(
                    icon: Icons.event_outlined,
                    label: 'Expiry date',
                    value: expiryDate,
                  ),
                  Divider(height: 1, indent: 16, endIndent: 16),
                  _DeliveryInfoRow(
                    icon: Icons.person_outline,
                    label: 'Recorded by',
                    value: recordedBy,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFE4F3EF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Color(0xFF137C72),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Keep the batch number and expiry date available when checking or issuing this stock.',
                      style: TextStyle(
                        color: Color(0xFF16312D),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            const Text(
              'This page shows sample delivery information for the preview.',
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

class _DeliveryInfoRow extends StatelessWidget {
  const _DeliveryInfoRow({
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF137C72),
            size: 21,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF62736E)),
            ),
          ),
          const SizedBox(width: 10),
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