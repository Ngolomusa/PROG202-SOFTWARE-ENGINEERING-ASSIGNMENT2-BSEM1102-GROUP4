import 'package:flutter/foundation.dart';

class Medicine {
  const Medicine({
    required this.id,
    required this.name,
    required this.category,
    required this.unit,
  });

  final String id;
  final String name;
  final String category;
  final String unit;
}

class StockItem {
  const StockItem({
    required this.medicine,
    required this.quantity,
    required this.reorderLevel,
    required this.expiryDate,
  });

  final Medicine medicine;
  final int quantity;
  final int reorderLevel;
  final DateTime expiryDate;

  bool get isLowStock => quantity <= reorderLevel;

  bool get isExpiringSoon {
    final daysLeft = expiryDate.difference(DateTime.now()).inDays;
    return daysLeft >= 0 && daysLeft <= 60;
  }

  StockItem copyWith({
    int? quantity,
    int? reorderLevel,
    DateTime? expiryDate,
  }) {
    return StockItem(
      medicine: medicine,
      quantity: quantity ?? this.quantity,
      reorderLevel: reorderLevel ?? this.reorderLevel,
      expiryDate: expiryDate ?? this.expiryDate,
    );
  }
}

class StockTransaction {
  const StockTransaction({
    required this.id,
    required this.type,
    required this.medicineName,
    required this.quantity,
    required this.unit,
    required this.reference,
    required this.date,
  });

  final String id;
  final String type;
  final String medicineName;
  final int quantity;
  final String unit;
  final String reference;
  final DateTime date;
}

class MediStockStore extends ChangeNotifier {
  MediStockStore() {
    final paracetamol = Medicine(
      id: 'MED001',
      name: 'Paracetamol 500 mg',
      category: 'Pain relief',
      unit: 'tablets',
    );
    final amoxicillin = Medicine(
      id: 'MED002',
      name: 'Amoxicillin 250 mg',
      category: 'Antibiotic',
      unit: 'capsules',
    );
    final ors = Medicine(
      id: 'MED003',
      name: 'ORS sachets',
      category: 'Rehydration',
      unit: 'sachets',
    );
    final malariaMedicine = Medicine(
      id: 'MED004',
      name: 'Artemether-Lumefantrine',
      category: 'Antimalarial',
      unit: 'packs',
    );
    final zinc = Medicine(
      id: 'MED005',
      name: 'Zinc Sulphate 20 mg',
      category: 'Supplement',
      unit: 'tablets',
    );

    _medicines.addAll([
      paracetamol,
      amoxicillin,
      ors,
      malariaMedicine,
      zinc,
    ]);

    final today = DateTime.now();
    _stock.addAll({
      'MED001': StockItem(
        medicine: paracetamol,
        quantity: 42,
        reorderLevel: 20,
        expiryDate: today.add(const Duration(days: 180)),
      ),
      'MED002': StockItem(
        medicine: amoxicillin,
        quantity: 5,
        reorderLevel: 20,
        expiryDate: today.add(const Duration(days: 240)),
      ),
      'MED003': StockItem(
        medicine: ors,
        quantity: 18,
        reorderLevel: 15,
        expiryDate: today.add(const Duration(days: 25)),
      ),
      'MED004': StockItem(
        medicine: malariaMedicine,
        quantity: 0,
        reorderLevel: 10,
        expiryDate: today.add(const Duration(days: 120)),
      ),
      'MED005': StockItem(
        medicine: zinc,
        quantity: 32,
        reorderLevel: 15,
        expiryDate: today.add(const Duration(days: 300)),
      ),
    });
  }

  final List<Medicine> _medicines = [];
  final Map<String, StockItem> _stock = {};
  final List<StockTransaction> _transactions = [];
  int _nextTransactionNumber = 1;

  List<Medicine> get medicines => List.unmodifiable(_medicines);
  List<StockItem> get stockItems => List.unmodifiable(_stock.values);
  List<StockTransaction> get transactions =>
      List.unmodifiable(_transactions);

  int get totalUnits =>
      _stock.values.fold(0, (total, item) => total + item.quantity);

  List<StockItem> get lowStockItems =>
      _stock.values.where((item) => item.isLowStock).toList();

  List<StockItem> get expiringItems =>
      _stock.values.where((item) => item.isExpiringSoon).toList();

  Medicine? findMedicine(String id) {
    for (final medicine in _medicines) {
      if (medicine.id == id) return medicine;
    }
    return null;
  }

  StockItem? findStock(String medicineId) => _stock[medicineId];

  void registerMedicine({
    required String id,
    required String name,
    required String category,
    required String unit,
  }) {
    final cleanId = id.trim().toUpperCase();

    if (cleanId.isEmpty ||
        name.trim().isEmpty ||
        category.trim().isEmpty ||
        unit.trim().isEmpty) {
      throw ArgumentError('Please complete all medicine fields.');
    }

    if (_medicines.any((medicine) => medicine.id == cleanId)) {
      throw ArgumentError('That medicine ID is already registered.');
    }

    _medicines.add(
      Medicine(
        id: cleanId,
        name: name.trim(),
        category: category.trim(),
        unit: unit.trim(),
      ),
    );
    notifyListeners();
  }

  void receiveStock({
    required String medicineId,
    required int quantity,
    required DateTime expiryDate,
    required int reorderLevel,
    required String supplier,
  }) {
    if (quantity <= 0) {
      throw ArgumentError('Quantity must be greater than zero.');
    }
    if (reorderLevel < 0) {
      throw ArgumentError('Reorder level cannot be negative.');
    }

    final medicine = findMedicine(medicineId);
    if (medicine == null) {
      throw ArgumentError('Medicine not found. Register it first.');
    }

    final current = _stock[medicineId];

    _stock[medicineId] = StockItem(
      medicine: medicine,
      quantity: (current?.quantity ?? 0) + quantity,
      reorderLevel: reorderLevel,
      expiryDate: expiryDate,
    );

    _addTransaction(
      type: 'Received',
      medicine: medicine,
      quantity: quantity,
      reference: supplier,
    );
    notifyListeners();
  }

  void dispense({
    required String medicineId,
    required int quantity,
    required String recipient,
  }) {
    if (quantity <= 0) {
      throw ArgumentError('Quantity must be greater than zero.');
    }

    final stockItem = _stock[medicineId];
    if (stockItem == null) {
      throw ArgumentError('No stock record exists for this medicine.');
    }
    if (quantity > stockItem.quantity) {
      throw ArgumentError(
        'Only ${stockItem.quantity} ${stockItem.medicine.unit} available.',
      );
    }

    _stock[medicineId] = stockItem.copyWith(
      quantity: stockItem.quantity - quantity,
    );

    _addTransaction(
      type: 'Dispensed',
      medicine: stockItem.medicine,
      quantity: quantity,
      reference: recipient,
    );
    notifyListeners();
  }

  void _addTransaction({
    required String type,
    required Medicine medicine,
    required int quantity,
    required String reference,
  }) {
    final number = _nextTransactionNumber.toString().padLeft(3, '0');

    _transactions.insert(
      0,
      StockTransaction(
        id: 'TXN-$number',
        type: type,
        medicineName: medicine.name,
        quantity: quantity,
        unit: medicine.unit,
        reference: reference,
        date: DateTime.now(),
      ),
    );

    _nextTransactionNumber++;
  }
}