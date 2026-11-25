import 'package:flutter/material.dart';
import 'medi_stock_store.dart';

void main() => runApp(const MediStockApp());

const Color brandGreen = Color(0xFF137C72);
const Color inkColor = Color(0xFF16312D);
const Color mutedColor = Color(0xFF62736E);
const Color paleGreen = Color(0xFFE4F3EF);

final MediStockStore mediStockStore = MediStockStore();

class MediStockApp extends StatelessWidget {
  const MediStockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DSalone MediStock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: brandGreen),
        scaffoldBackgroundColor: const Color(0xFFF7F9F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F9F8),
          surfaceTintColor: Colors.transparent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDCE5E2)),
          ),
        ),
      ),
      initialRoute: '/dashboard',
      routes: {
        '/dashboard': (_) => DashboardScreen(store: mediStockStore),
        '/inventory': (_) => InventoryScreen(store: mediStockStore),
        '/medicines': (_) => MedicineDirectoryScreen(store: mediStockStore),
        '/register': (_) => RegisterMedicineScreen(store: mediStockStore),
        '/receive': (_) => ReceiveStockScreen(store: mediStockStore),
        '/dispense': (_) => DispenseMedicineScreen(store: mediStockStore),
        '/stock-alerts': (_) => StockAlertsScreen(store: mediStockStore),
        '/stock-records': (_) => StockRecordsScreen(store: mediStockStore),
        '/search': (_) => MedicineSearchScreen(store: mediStockStore),
        '/dispensing-records': (_) => TransactionListScreen(
          store: mediStockStore,
          title: 'Dispensing records',
          type: 'Dispensed',
        ),
        '/received-records': (_) => TransactionListScreen(
          store: mediStockStore,
          title: 'Received stock records',
          type: 'Received',
        ),
        '/adjustment': (_) => const ExtraFormScreen(
          title: 'Stock adjustment',
          intro: 'Document damaged, expired, missing, or corrected stock.',
          fields: ['Medicine ID', 'Reason', 'Quantity affected', 'Notes'],
        ),
        '/suppliers': (_) => const StaticListScreen(
          title: 'Supplier directory',
          subtitle: 'Sample suppliers serving health facilities in Sierra Leone.',
          rows: [
            'District Medical Store • Bo District • +232 76 123 456',
            'Central Medical Stores • Freetown • +232 77 234 567',
            'Community Health Supply • Kenema District • +232 78 345 678',
          ],
          icon: Icons.local_shipping_outlined,
        ),
        '/add-supplier': (_) => const ExtraFormScreen(
          title: 'Add supplier',
          intro: 'Enter the supplier and contact details.',
          fields: ['Supplier name', 'Contact person', 'Phone number', 'District or location', 'Supplies provided'],
        ),
        '/delivery-details': (_) => const DeliveryDetailsScreen(),
        '/facility': (_) => const FacilityProfileScreen(),
        '/settings': (_) => const SettingsHelpScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final medicineId = settings.arguments is String
              ? settings.arguments! as String
              : 'MED001';
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => MedicineDetailScreen(
              store: mediStockStore,
              medicineId: medicineId,
            ),
          );
        }
        return null;
      },
    );
  }
}

class _NavItem {
  const _NavItem(this.title, this.icon, this.route);
  final String title;
  final IconData icon;
  final String route;
}

const List<_NavItem> _navItems = [
  _NavItem('Dashboard', Icons.dashboard_outlined, '/dashboard'),
  _NavItem('Current stock', Icons.inventory_2_outlined, '/inventory'),
  _NavItem('Medicine directory', Icons.medication_outlined, '/medicines'),
  _NavItem('Register medicine', Icons.add_box_outlined, '/register'),
  _NavItem('Medicine details', Icons.info_outline, '/detail'),
  _NavItem('Receive stock', Icons.move_to_inbox_outlined, '/receive'),
  _NavItem('Dispense medicine', Icons.outbox_outlined, '/dispense'),
  _NavItem('Low-stock and expiry alerts', Icons.warning_amber_rounded, '/stock-alerts'),
  _NavItem('Stock records', Icons.receipt_long_outlined, '/stock-records'),
  _NavItem('Search medicines', Icons.search, '/search'),
  _NavItem('Dispensing records', Icons.history, '/dispensing-records'),
  _NavItem('Received stock records', Icons.local_shipping_outlined, '/received-records'),
  _NavItem('Stock adjustment', Icons.edit_note_outlined, '/adjustment'),
  _NavItem('Supplier directory', Icons.business_outlined, '/suppliers'),
  _NavItem('Add supplier', Icons.person_add_alt_1_outlined, '/add-supplier'),
  _NavItem('Delivery details', Icons.assignment_outlined, '/delivery-details'),
  _NavItem('Facility profile', Icons.local_hospital_outlined, '/facility'),
  _NavItem('Settings & Help', Icons.settings_outlined, '/settings'),
];

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 18, 16, 16),
              child: Row(children: [
                CircleAvatar(
                  backgroundColor: paleGreen,
                  child: Icon(Icons.medical_services_outlined, color: brandGreen),
                ),
                SizedBox(width: 12),
                Text(
                  'DSalone MediStock',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: inkColor),
                ),
              ]),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _navItems.length,
                itemBuilder: (context, index) {
                  final item = _navItems[index];
                  final selected = item.route == currentRoute;
                  return ListTile(
                    selected: selected,
                    leading: Icon(item.icon, color: selected ? brandGreen : null),
                    title: Text(item.title),
                    onTap: () {
                      final navigator = Navigator.of(context);
                      navigator.pop();
                      if (item.route == '/detail') {
                        navigator.pushNamed(item.route, arguments: 'MED001');
                      } else if (item.route != currentRoute) {
                        navigator.pushNamed(item.route);
                      }
                    },
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

class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
    required this.title,
    required this.currentRoute,
    required this.body,
    this.showBottomNavigation = true,
    this.floatingActionButton,
  });

  final String title;
  final String currentRoute;
  final Widget body;
  final bool showBottomNavigation;
  final Widget? floatingActionButton;

  int get _selectedTab {
    if (currentRoute == '/dashboard') return 0;
    if (currentRoute == '/inventory' || currentRoute == '/medicines') return 1;
    if (currentRoute == '/receive') return 2;
    if (currentRoute == '/dispense') return 3;
    return 4;
  }

  void _goToTab(BuildContext context, int index) {
    const routes = ['/dashboard', '/inventory', '/receive', '/dispense', '/search'];
    if (routes[index] != currentRoute) {
      Navigator.pushReplacementNamed(context, routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    ),
    drawer: const AppDrawer(),
    body: SafeArea(child: body),
    floatingActionButton: floatingActionButton,
    bottomNavigationBar: showBottomNavigation
        ? NavigationBar(
      selectedIndex: _selectedTab,
      onDestinationSelected: (index) => _goToTab(context, index),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.inventory_2_outlined), label: 'Stock'),
        NavigationDestination(icon: Icon(Icons.move_to_inbox_outlined), label: 'Receive'),
        NavigationDestination(icon: Icon(Icons.outbox_outlined), label: 'Dispense'),
        NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
      ],
    )
        : null,
  );
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.store});
  final MediStockStore store;

  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Good day',
    currentRoute: '/dashboard',
    body: AnimatedBuilder(
      animation: store,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [brandGreen, Color(0xFF1C9A86)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('DSalone MediStock', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Medicine inventory at a glance', style: TextStyle(color: Color(0xFFE0F3EE))),
            ]),
          ),
          const SizedBox(height: 18),
          const Text('Stock overview', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: inkColor)),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: _MetricCard(label: 'Medicine types', value: '${store.medicines.length}', icon: Icons.medication_outlined)),
            const SizedBox(width: 10),
            Expanded(child: _MetricCard(label: 'Total units', value: '${store.totalUnits}', icon: Icons.inventory_2_outlined)),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: _MetricCard(label: 'Low stock', value: '${store.lowStockItems.length}', icon: Icons.warning_amber_rounded)),
            const SizedBox(width: 10),
            Expanded(child: _MetricCard(label: 'Expiry alerts', value: '${store.expiringItems.length}', icon: Icons.event_busy_outlined)),
          ]),
          const SizedBox(height: 18),
          const Text('Quick actions', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: inkColor)),
          _QuickLink(label: 'Current stock', icon: Icons.inventory_2_outlined, route: '/inventory'),
          _QuickLink(label: 'Register medicine', icon: Icons.add_box_outlined, route: '/register'),
          _QuickLink(label: 'Receive stock', icon: Icons.move_to_inbox_outlined, route: '/receive'),
          _QuickLink(label: 'Dispense medicine', icon: Icons.outbox_outlined, route: '/dispense'),
          _QuickLink(label: 'Stock alerts', icon: Icons.analytics_outlined, route: '/stock-alerts'),
        ],
      ),
    ),
  );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, color: brandGreen),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: inkColor)),
        Text(label, style: const TextStyle(color: mutedColor)),
      ]),
    ),
  );
}

class _QuickLink extends StatelessWidget {
  const _QuickLink({required this.label, required this.icon, required this.route});
  final String label;
  final IconData icon;
  final String route;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: CircleAvatar(backgroundColor: paleGreen, child: Icon(icon, color: brandGreen)),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.pushNamed(context, route),
    ),
  );
}

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key, required this.store});
  final MediStockStore store;
  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final _searchController = TextEditingController();
  String _filter = 'All';
  @override
  void dispose() { _searchController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Current stock',
    currentRoute: '/inventory',
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () => Navigator.pushNamed(context, '/receive'),
      icon: const Icon(Icons.move_to_inbox_outlined),
      label: const Text('Receive stock'),
    ),
    body: AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        final query = _searchController.text.trim().toLowerCase();
        final items = widget.store.stockItems.where((item) {
          final medicine = item.medicine;
          final textMatches = medicine.name.toLowerCase().contains(query) ||
              medicine.id.toLowerCase().contains(query) ||
              medicine.category.toLowerCase().contains(query);
          final filterMatches = _filter == 'All' ||
              (_filter == 'Low stock' && item.isLowStock) ||
              (_filter == 'Expiring' && item.isExpiringSoon);
          return textMatches && filterMatches;
        }).toList();
        return Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Find medicine, category, or ID'),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: ['All', 'Low stock', 'Expiring'].map((label) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(label: Text(label), selected: _filter == label, onSelected: (_) => setState(() => _filter = label)),
            )).toList()),
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('No matching stock.'))
                : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(child: ListTile(
                  leading: const CircleAvatar(backgroundColor: paleGreen, child: Icon(Icons.medication_outlined, color: brandGreen)),
                  title: Text(item.medicine.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${item.medicine.id} • ${item.medicine.category}\n${item.quantity} ${item.medicine.unit} • Reorder at ${item.reorderLevel}'),
                  isThreeLine: true,
                  trailing: Icon(item.isLowStock ? Icons.warning_amber_rounded : Icons.chevron_right, color: item.isLowStock ? Colors.orange : mutedColor),
                  onTap: () => Navigator.pushNamed(context, '/detail', arguments: item.medicine.id),
                ));
              },
            ),
          ),
        ]);
      },
    ),
  );
}

class MedicineDirectoryScreen extends StatelessWidget {
  const MedicineDirectoryScreen({super.key, required this.store});
  final MediStockStore store;
  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Medicine directory',
    currentRoute: '/medicines',
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () => Navigator.pushNamed(context, '/register'),
      icon: const Icon(Icons.add),
      label: const Text('Register'),
    ),
    body: AnimatedBuilder(
      animation: store,
      builder: (context, _) => ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
        itemCount: store.medicines.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final medicine = store.medicines[index];
          final stock = store.findStock(medicine.id);
          return Card(child: ListTile(
            leading: const CircleAvatar(backgroundColor: paleGreen, child: Icon(Icons.medication_outlined, color: brandGreen)),
            title: Text(medicine.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${medicine.id} • ${medicine.category}'),
            trailing: Text(stock == null ? medicine.unit : '${stock.quantity} ${medicine.unit}', textAlign: TextAlign.end),
            onTap: () => Navigator.pushNamed(context, '/detail', arguments: medicine.id),
          ));
        },
      ),
    ),
  );
}

class RegisterMedicineScreen extends StatefulWidget {
  const RegisterMedicineScreen({super.key, required this.store});
  final MediStockStore store;
  @override
  State<RegisterMedicineScreen> createState() => _RegisterMedicineScreenState();
}
class _RegisterMedicineScreenState extends State<RegisterMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _name = TextEditingController();
  final _category = TextEditingController();
  final _unit = TextEditingController();
  @override
  void dispose() { _id.dispose(); _name.dispose(); _category.dispose(); _unit.dispose(); super.dispose(); }
  void _save() {
    if (!_formKey.currentState!.validate()) return;
    try {
      widget.store.registerMedicine(id: _id.text, name: _name.text, category: _category.text, unit: _unit.text);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Medicine registered.')));
      Navigator.pop(context);
    } on ArgumentError catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message.toString())));
    }
  }
  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Register medicine', currentRoute: '/register',
    body: Form(key: _formKey, child: ListView(padding: const EdgeInsets.all(18), children: [
      const Text('Add a medicine to the facility directory. Complete all fields.', style: TextStyle(color: mutedColor)),
      const SizedBox(height: 16),
      _formField(_id, 'Medicine ID', 'e.g. MED006'),
      _formField(_name, 'Medicine name', 'Generic name and strength'),
      _formField(_category, 'Category', 'e.g. Antibiotic'),
      _formField(_unit, 'Unit of issue', 'e.g. tablets, bottles, packs'),
      FilledButton.icon(onPressed: _save, icon: const Icon(Icons.save_outlined), label: const Text('Save medicine')),
    ])),
  );
}

Widget _formField(TextEditingController controller, String label, String hint, {TextInputType keyboardType = TextInputType.text}) => Padding(
  padding: const EdgeInsets.only(bottom: 14),
  child: TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    textCapitalization: TextCapitalization.sentences,
    decoration: InputDecoration(labelText: label, hintText: hint),
    validator: (value) {
      if (value == null || value.trim().isEmpty) return 'Enter $label';
      if (keyboardType == TextInputType.number) {
        final number = int.tryParse(value.trim());
        if (number == null) return 'Enter a whole number';
        if (label.toLowerCase().contains('quantity') && number <= 0) {
          return 'Enter a number greater than zero';
        }
        if (label.toLowerCase().contains('reorder') && number < 0) {
          return 'The reorder level cannot be negative';
        }
      }
      return null;
    },
  ),
);

class ReceiveStockScreen extends StatefulWidget {
  const ReceiveStockScreen({super.key, required this.store});
  final MediStockStore store;
  @override
  State<ReceiveStockScreen> createState() => _ReceiveStockScreenState();
}
class _ReceiveStockScreenState extends State<ReceiveStockScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantity = TextEditingController();
  final _reorder = TextEditingController(text: '10');
  final _supplier = TextEditingController();
  String? _medicineId;
  DateTime? _expiryDate;
  @override
  void dispose() { _quantity.dispose(); _reorder.dispose(); _supplier.dispose(); super.dispose(); }
  Future<void> _chooseExpiry() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? now.add(const Duration(days: 180)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 3650)),
    );
    if (selected != null && mounted) setState(() => _expiryDate = selected);
  }
  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_medicineId == null || _expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a medicine and expiry date.')));
      return;
    }
    try {
      widget.store.receiveStock(
        medicineId: _medicineId!,
        quantity: int.parse(_quantity.text),
        expiryDate: _expiryDate!,
        reorderLevel: int.parse(_reorder.text),
        supplier: _supplier.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Stock received; inventory updated.')));
      Navigator.pop(context);
    } on ArgumentError catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message.toString())));
    }
  }
  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Receive stock', currentRoute: '/receive',
    body: AnimatedBuilder(animation: widget.store, builder: (context, _) => Form(key: _formKey, child: ListView(padding: const EdgeInsets.all(18), children: [
      const Text('Record a delivery received at this health facility.', style: TextStyle(color: mutedColor)),
      const SizedBox(height: 16),
      DropdownButtonFormField<String>(
        value: _medicineId,
        decoration: const InputDecoration(labelText: 'Medicine'),
        items: widget.store.medicines.map((m) => DropdownMenuItem(value: m.id, child: Text(m.name, overflow: TextOverflow.ellipsis))).toList(),
        onChanged: (value) => setState(() => _medicineId = value),
        validator: (value) => value == null ? 'Select a medicine' : null,
      ),
      const SizedBox(height: 14),
      _formField(_quantity, 'Quantity received', 'Enter a whole number', keyboardType: TextInputType.number),
      _formField(_reorder, 'Reorder level', 'Alert threshold', keyboardType: TextInputType.number),
      _formField(_supplier, 'Supplier or source', 'e.g. District Medical Store'),
      OutlinedButton.icon(onPressed: _chooseExpiry, icon: const Icon(Icons.event_outlined), label: Text(_expiryDate == null ? 'Choose expiry date' : 'Expiry: ${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}')),
      const SizedBox(height: 14),
      FilledButton.icon(onPressed: _save, icon: const Icon(Icons.check), label: const Text('Confirm stock received')),
    ]))),
  );
}

class DispenseMedicineScreen extends StatefulWidget {
  const DispenseMedicineScreen({super.key, required this.store});
  final MediStockStore store;
  @override
  State<DispenseMedicineScreen> createState() => _DispenseMedicineScreenState();
}
class _DispenseMedicineScreenState extends State<DispenseMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantity = TextEditingController();
  final _recipient = TextEditingController();
  String? _medicineId;
  @override
  void dispose() { _quantity.dispose(); _recipient.dispose(); super.dispose(); }
  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_medicineId == null) return;
    try {
      widget.store.dispense(medicineId: _medicineId!, quantity: int.parse(_quantity.text), recipient: _recipient.text);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dispensing recorded; inventory updated.')));
      Navigator.pop(context);
    } on ArgumentError catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message.toString())));
    }
  }
  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Dispense medicine', currentRoute: '/dispense',
    body: AnimatedBuilder(animation: widget.store, builder: (context, _) => Form(key: _formKey, child: ListView(padding: const EdgeInsets.all(18), children: [
      const Text('Record medicine issued to a patient or department.', style: TextStyle(color: mutedColor)),
      const SizedBox(height: 16),
      DropdownButtonFormField<String>(
        value: _medicineId,
        decoration: const InputDecoration(labelText: 'Medicine in stock'),
        items: widget.store.stockItems.map((item) => DropdownMenuItem(value: item.medicine.id, child: Text('${item.medicine.name} (${item.quantity})', overflow: TextOverflow.ellipsis))).toList(),
        onChanged: (value) => setState(() => _medicineId = value),
        validator: (value) => value == null ? 'Select a medicine' : null,
      ),
      const SizedBox(height: 14),
      _formField(_quantity, 'Quantity to dispense', 'Enter a whole number', keyboardType: TextInputType.number),
      _formField(_recipient, 'Recipient reference', 'Patient, clinic card, or department ID'),
      FilledButton.icon(onPressed: _save, icon: const Icon(Icons.check), label: const Text('Confirm dispensing')),
    ]))),
  );
}

class MedicineDetailScreen extends StatelessWidget {
  const MedicineDetailScreen({super.key, required this.store, required this.medicineId});
  final MediStockStore store;
  final String medicineId;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: store,
    builder: (context, _) {
      final medicine = store.findMedicine(medicineId);
      if (medicine == null) {
        return const AppPage(title: 'Medicine details', currentRoute: '/inventory', body: Center(child: Text('Medicine not found.')));
      }
      final item = store.findStock(medicineId);
      return AppPage(
        title: 'Medicine details', currentRoute: '/inventory',
        body: ListView(padding: const EdgeInsets.all(18), children: [
          Card(child: ListTile(leading: const CircleAvatar(backgroundColor: paleGreen, child: Icon(Icons.medication_outlined, color: brandGreen)), title: Text(medicine.name, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('${medicine.id} • ${medicine.category}'))),
          const SizedBox(height: 12),
          Card(child: Column(children: [
            _detailRow('Available quantity', item == null ? 'No stock' : '${item.quantity} ${medicine.unit}'),
            _detailRow('Reorder level', item == null ? 'Not set' : '${item.reorderLevel} ${medicine.unit}'),
            _detailRow('Expiry date', item == null ? 'Not recorded' : '${item.expiryDate.day}/${item.expiryDate.month}/${item.expiryDate.year}'),
            _detailRow('Status', item == null ? 'No stock record' : item.isLowStock ? 'Low stock' : item.isExpiringSoon ? 'Expiring soon' : 'In stock'),
          ])),
          const SizedBox(height: 12),
          _QuickLink(label: 'Receive stock', icon: Icons.move_to_inbox_outlined, route: '/receive'),
          _QuickLink(label: 'Dispense this medicine', icon: Icons.outbox_outlined, route: '/dispense'),
        ]),
      );
    },
  );
}

Widget _detailRow(String label, String value) => ListTile(title: Text(label, style: const TextStyle(color: mutedColor)), trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: inkColor)));

class StockAlertsScreen extends StatelessWidget {
  const StockAlertsScreen({super.key, required this.store});
  final MediStockStore store;
  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Stock alerts', currentRoute: '/stock-alerts',
    body: AnimatedBuilder(animation: store, builder: (context, _) => DefaultTabController(
      length: 2,
      child: Column(children: [
        const TabBar(tabs: [Tab(text: 'Low stock'), Tab(text: 'Expiring soon')]),
        Expanded(child: TabBarView(children: [
          _stockAlertList(store.lowStockItems, 'No medicines are currently at or below reorder level.'),
          _stockAlertList(store.expiringItems, 'No stock is expiring within the next 60 days.'),
        ])),
      ]),
    )),
  );
}

Widget _stockAlertList(List<StockItem> items, String emptyText) => items.isEmpty
    ? Center(child: Text(emptyText, textAlign: TextAlign.center))
    : ListView(padding: const EdgeInsets.all(16), children: [for (final item in items) Card(child: ListTile(
  leading: const Icon(Icons.warning_amber_rounded, color: Color(0xFFB54708)),
  title: Text(item.medicine.name),
  subtitle: Text('${item.quantity} ${item.medicine.unit} • Reorder at ${item.reorderLevel} • Expiry ${item.expiryDate.day}/${item.expiryDate.month}/${item.expiryDate.year}'),
  onTap: null,
))]);

class StockRecordsScreen extends StatelessWidget {
  const StockRecordsScreen({super.key, required this.store});
  final MediStockStore store;
  @override
  Widget build(BuildContext context) => TransactionListScreen(store: store, title: 'Stock records');
}

class TransactionListScreen extends StatelessWidget {
  const TransactionListScreen({super.key, required this.store, required this.title, this.type});
  final MediStockStore store;
  final String title;
  final String? type;
  @override
  Widget build(BuildContext context) => AppPage(
    title: title,
    currentRoute: type == 'Received' ? '/received-records' : type == 'Dispensed' ? '/dispensing-records' : '/stock-records',
    body: AnimatedBuilder(animation: store, builder: (context, _) {
      final records = store.transactions.where((record) => type == null || record.type == type).toList();
      if (records.isEmpty) return const Center(child: Text('No transactions recorded yet.'));
      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: records.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final record = records[index];
          final isReceived = record.type == 'Received';
          return Card(child: ListTile(
            leading: CircleAvatar(backgroundColor: isReceived ? paleGreen : const Color(0xFFEAF0FF), child: Icon(isReceived ? Icons.move_to_inbox_outlined : Icons.outbox_outlined, color: isReceived ? brandGreen : const Color(0xFF4355A6))),
            title: Text(record.medicineName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${record.type} • ${record.reference}\n${record.date} • ${record.id}'),
            isThreeLine: true,
            trailing: Text('${isReceived ? '+' : '−'}${record.quantity}\n${record.unit}', textAlign: TextAlign.end),
          ));
        },
      );
    }),
  );
}

class MedicineSearchScreen extends StatefulWidget {
  const MedicineSearchScreen({super.key, required this.store});
  final MediStockStore store;
  @override
  State<MedicineSearchScreen> createState() => _MedicineSearchScreenState();
}
class _MedicineSearchScreenState extends State<MedicineSearchScreen> {
  final _controller = TextEditingController();
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AppPage(
    title: 'Search medicines', currentRoute: '/search',
    body: AnimatedBuilder(animation: widget.store, builder: (context, _) {
      final query = _controller.text.toLowerCase().trim();
      final matches = widget.store.medicines.where((medicine) => medicine.name.toLowerCase().contains(query) || medicine.id.toLowerCase().contains(query) || medicine.category.toLowerCase().contains(query)).toList();
      return Column(children: [
        Padding(padding: const EdgeInsets.all(16), child: TextField(controller: _controller, onChanged: (_) => setState(() {}), decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: 'Search name, ID, or category', suffixIcon: _controller.text.isEmpty ? null : IconButton(onPressed: () { _controller.clear(); setState(() {}); }, icon: const Icon(Icons.close))))),
        Expanded(child: matches.isEmpty ? const Center(child: Text('No matching medicines.')) : ListView(padding: const EdgeInsets.symmetric(horizontal: 16), children: [for (final medicine in matches) Card(child: ListTile(
          leading: const Icon(Icons.medication_outlined, color: brandGreen),
          title: Text(medicine.name),
          subtitle: Text('${medicine.id} • ${medicine.category} • ${widget.store.findStock(medicine.id)?.quantity ?? 0} ${medicine.unit}'),
          onTap: () => Navigator.pushNamed(context, '/detail', arguments: medicine.id),
        ))])),
      ]);
    }),
  );
}

class ExtraFormScreen extends StatefulWidget {
  const ExtraFormScreen({super.key, required this.title, required this.intro, required this.fields});
  final String title;
  final String intro;
  final List<String> fields;
  @override
  State<ExtraFormScreen> createState() => _ExtraFormScreenState();
}
class _ExtraFormScreenState extends State<ExtraFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final List<TextEditingController> _controllers = List.generate(widget.fields.length, (_) => TextEditingController());
  @override
  void dispose() { for (final controller in _controllers) { controller.dispose(); } super.dispose(); }
  @override
  Widget build(BuildContext context) => AppPage(
    title: widget.title,
    currentRoute: widget.title == 'Add supplier' ? '/add-supplier' : '/adjustment',
    body: Form(key: _formKey, child: ListView(padding: const EdgeInsets.all(18), children: [
      Text(widget.intro, style: const TextStyle(color: mutedColor)),
      const SizedBox(height: 16),
      for (var i = 0; i < widget.fields.length; i++) _formField(_controllers[i], widget.fields[i], 'Enter ${widget.fields[i].toLowerCase()}'),
      FilledButton(onPressed: () {
        if (!_formKey.currentState!.validate()) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${widget.title} details validated.')));
      }, child: const Text('Save')),
    ])),
  );
}

class StaticListScreen extends StatelessWidget {
  const StaticListScreen({super.key, required this.title, required this.subtitle, required this.rows, required this.icon});
  final String title;
  final String subtitle;
  final List<String> rows;
  final IconData icon;
  @override
  Widget build(BuildContext context) => AppPage(title: title, currentRoute: title == 'Supplier directory' ? '/suppliers' : '/inventory', body: ListView(padding: const EdgeInsets.all(16), children: [Text(subtitle, style: const TextStyle(color: mutedColor)), const SizedBox(height: 12), for (final row in rows) Card(child: ListTile(leading: Icon(icon, color: brandGreen), title: Text(row)))]));
}

class DeliveryDetailsScreen extends StatelessWidget {
  const DeliveryDetailsScreen({super.key});
  @override
  Widget build(BuildContext context) => AppPage(title: 'Delivery details', currentRoute: '/delivery-details', body: ListView(padding: const EdgeInsets.all(18), children: [
    const Card(child: ListTile(leading: CircleAvatar(backgroundColor: paleGreen, child: Icon(Icons.move_to_inbox_outlined, color: brandGreen)), title: Text('Sample delivery', style: TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('Delivery details preview'))),
    Card(child: Column(children: [_detailRow('Supplier', 'District Medical Store'), _detailRow('Batch number', 'PCM-2608'), _detailRow('Quantity', '100 tablets'), _detailRow('Expiry date', '31 August 2027')])),
  ]));
}

class FacilityProfileScreen extends StatelessWidget {
  const FacilityProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => AppPage(title: 'Facility profile', currentRoute: '/facility', body: ListView(padding: const EdgeInsets.all(18), children: [
    Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(gradient: const LinearGradient(colors: [brandGreen, Color(0xFF1C9A86)]), borderRadius: BorderRadius.circular(20)), child: const Column(children: [CircleAvatar(radius: 30, backgroundColor: Colors.white, child: Icon(Icons.local_hospital_outlined, color: brandGreen)), SizedBox(height: 12), Text('DSalone Community Health Centre', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)), Text('Bo District • Sierra Leone', style: TextStyle(color: Colors.white))])),
    const SizedBox(height: 12),
    Card(child: Column(children: [_detailRow('Facility code', 'FAC-001'), _detailRow('Facility type', 'Community Health Centre'), _detailRow('District', 'Bo District'), _detailRow('Chiefdom', 'Kakua Chiefdom'), _detailRow('Phone', '+232 76 123 456')])),
  ]));
}

class SettingsHelpScreen extends StatefulWidget {
  const SettingsHelpScreen({super.key});

  @override
  State<SettingsHelpScreen> createState() => _SettingsHelpScreenState();
}

class _SettingsHelpScreenState extends State<SettingsHelpScreen> {
  bool _lowStock = true;
  bool _expiry = true;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Settings & Help',
      currentRoute: '/settings',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Notifications',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  value: _lowStock,
                  title: const Text('Low-stock alerts'),
                  onChanged: (value) {
                    setState(() {
                      _lowStock = value;
                    });
                  },
                ),
                SwitchListTile(
                  value: _expiry,
                  title: const Text('Expiry alerts'),
                  onChanged: (value) {
                    setState(() {
                      _expiry = value;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const Card(
            child: ListTile(
              leading: Icon(Icons.help_outline, color: brandGreen),
              title: Text('Using MediStock'),
              subtitle: Text(
                'Register medicines, record stock received or dispensed, and review alerts and records.',
              ),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline, color: brandGreen),
              title: Text('About DSalone MediStock'),
              subtitle: Text(
                'Medicine inventory prototype for Sierra Leone health facilities.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
