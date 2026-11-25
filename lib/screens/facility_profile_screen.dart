import 'package:flutter/material.dart';

class FacilityProfileScreen extends StatelessWidget {
  const FacilityProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample facility information for the screen preview.
    const facilityName = 'DSalone Community Health Centre';
    const facilityType = 'Community Health Centre';
    const district = 'Bo District';
    const chiefdom = 'Kakua Chiefdom';
    const facilityCode = 'FAC-001';
    const phone = '+232 76 123 456';
    const email = 'healthcentre@example.com';
    const address = 'Bo, Southern Province, Sierra Leone';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Facility profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF137C72),
                    Color(0xFF1C9A86),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.local_hospital_outlined,
                      color: Color(0xFF137C72),
                      size: 38,
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    facilityName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '$facilityType • $district',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFE0F3EE)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            const Text(
              'Facility information',
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
                  _ProfileInfoRow(
                    icon: Icons.badge_outlined,
                    label: 'Facility code',
                    value: facilityCode,
                  ),
                  Divider(height: 1, indent: 16, endIndent: 16),
                  _ProfileInfoRow(
                    icon: Icons.health_and_safety_outlined,
                    label: 'Facility type',
                    value: facilityType,
                  ),
                  Divider(height: 1, indent: 16, endIndent: 16),
                  _ProfileInfoRow(
                    icon: Icons.location_city_outlined,
                    label: 'District',
                    value: district,
                  ),
                  Divider(height: 1, indent: 16, endIndent: 16),
                  _ProfileInfoRow(
                    icon: Icons.map_outlined,
                    label: 'Chiefdom',
                    value: chiefdom,
                  ),
                  Divider(height: 1, indent: 16, endIndent: 16),
                  _ProfileInfoRow(
                    icon: Icons.location_on_outlined,
                    label: 'Address',
                    value: address,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            const Text(
              'Contact details',
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
                  _ProfileInfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: phone,
                  ),
                  Divider(height: 1, indent: 16, endIndent: 16),
                  _ProfileInfoRow(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: email,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Sample information for the assignment preview. Replace it with your assigned health facility details.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF62736E),
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({
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