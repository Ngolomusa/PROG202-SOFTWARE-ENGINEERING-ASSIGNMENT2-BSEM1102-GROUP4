import 'package:flutter/material.dart';

class SettingsHelpScreen extends StatefulWidget {
  const SettingsHelpScreen({super.key});

  @override
  State<SettingsHelpScreen> createState() => _SettingsHelpScreenState();
}

class _SettingsHelpScreenState extends State<SettingsHelpScreen> {
  bool _lowStockNotifications = true;
  bool _expiryNotifications = true;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'DSalone MediStock',
      applicationVersion: '1.0.0',
      applicationLegalese:
      'Medicine inventory tracking for community health facilities in Sierra Leone.',
      children: const [
        SizedBox(height: 12),
        Text(
          'This assignment prototype helps facility staff keep track of medicine stock, deliveries, dispensing, and alerts.',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings & Help',
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
                color: const Color(0xFFE4F3EF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.settings_outlined,
                      color: Color(0xFF137C72),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'App preferences',
                          style: TextStyle(
                            color: Color(0xFF16312D),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Manage alerts and find help using MediStock.',
                          style: TextStyle(
                            color: Color(0xFF62736E),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            const _SectionTitle(title: 'Notifications'),
            Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFE7EEEB)),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    value: _lowStockNotifications,
                    activeThumbColor: const Color(0xFF137C72),
                    secondary: const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFB54708),
                    ),
                    title: const Text(
                      'Low-stock alerts',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text(
                      'Notify when stock reaches its reorder level.',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _lowStockNotifications = value;
                      });
                      _showMessage(
                        value
                            ? 'Low-stock alerts turned on.'
                            : 'Low-stock alerts turned off.',
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    value: _expiryNotifications,
                    activeThumbColor: const Color(0xFF137C72),
                    secondary: const Icon(
                      Icons.event_busy_outlined,
                      color: Color(0xFFB42318),
                    ),
                    title: const Text(
                      'Expiry alerts',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text(
                      'Notify about medicines nearing expiry.',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _expiryNotifications = value;
                      });
                      _showMessage(
                        value
                            ? 'Expiry alerts turned on.'
                            : 'Expiry alerts turned off.',
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            const _SectionTitle(title: 'Help and information'),
            Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFE7EEEB)),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.help_outline,
                      color: Color(0xFF137C72),
                    ),
                    title: const Text(
                      'Using MediStock',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text(
                      'Basic guidance for medicine stock tasks',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Using MediStock'),
                          content: const Text(
                            'Register a medicine before recording a delivery. '
                                'Use Receive Stock to add deliveries and Dispense '
                                'Medicine to record stock issued. Check the alerts '
                                'and records screens to review stock activity.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(dialogContext),
                              child: const Text('Got it'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: const Icon(
                      Icons.contact_support_outlined,
                      color: Color(0xFF137C72),
                    ),
                    title: const Text(
                      'Contact facility support',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text(
                      'Ask your facility supervisor for assistance',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _showMessage(
                        'Please contact your facility supervisor.',
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  ListTile(
                    leading: const Icon(
                      Icons.info_outline,
                      color: Color(0xFF137C72),
                    ),
                    title: const Text(
                      'About MediStock',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text('App details and version'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _showAbout,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            const Text(
              'Settings are stored for this preview only and will reset when the app restarts.',
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF16312D),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}