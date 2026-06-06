enum StockStatus { good, low }

enum HistoryType { dispatch, receive }

class StockHistory {
  final DateTime date;
  final HistoryType type;
  final String actionTitle; // e.g. "Dispatched to Site", "Received from Vendor"
  final String actionSubtitle; // e.g. "0.5 Tons to Metro Towers"

  StockHistory({
    required this.date,
    required this.type,
    required this.actionTitle,
    required this.actionSubtitle,
  });
}

class StockItem {
  final String id;
  final String name;
  final String category; // "Raw Materials", "Machinery", "Tools"
  final String quantityValue; // e.g. "320", "0.5"
  final String quantityUnit; // e.g. "Bags", "Tons"
  final StockStatus status;
  final String utilizedValue;
  final String utilizedUnit;
  final String wastedValue;
  final String wastedUnit;
  final List<StockHistory> history;

  StockItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantityValue,
    required this.quantityUnit,
    required this.status,
    required this.utilizedValue,
    required this.utilizedUnit,
    required this.wastedValue,
    required this.wastedUnit,
    required this.history,
  });
}

final List<StockItem> mockStocks = [
  StockItem(
    id: 'STK-001',
    name: 'OPC Cement 53G',
    category: 'Raw Materials',
    quantityValue: '320',
    quantityUnit: 'Bags',
    status: StockStatus.good,
    utilizedValue: '1200',
    utilizedUnit: 'Bags',
    wastedValue: '15',
    wastedUnit: 'Bags',
    history: [
      StockHistory(
        date: DateTime.now().subtract(const Duration(hours: 2)),
        type: HistoryType.receive,
        actionTitle: 'Received from Vendor',
        actionSubtitle: '320 Bags from UltraTech',
      ),
    ],
  ),
  StockItem(
    id: 'STK-002',
    name: 'Steel Rod 12mm',
    category: 'Raw Materials',
    quantityValue: '0.5',
    quantityUnit: 'Tons',
    status: StockStatus.low,
    utilizedValue: '4.5',
    utilizedUnit: 'Tons',
    wastedValue: '0.2',
    wastedUnit: 'Tons',
    history: [
      StockHistory(
        date: DateTime(2026, 6, 6, 10, 30), // Today, 10:30 AM
        type: HistoryType.dispatch,
        actionTitle: 'Dispatched to Site',
        actionSubtitle: '0.5 Tons to Metro Towers',
      ),
      StockHistory(
        date: DateTime(2026, 6, 5, 14, 15), // Yesterday, 02:15 PM
        type: HistoryType.receive,
        actionTitle: 'Received from Vendor',
        actionSubtitle: '1.0 Tons from RK Steel Industries',
      ),
      StockHistory(
        date: DateTime(2026, 6, 2, 9, 00), // Jun 02, 09:00 AM
        type: HistoryType.dispatch,
        actionTitle: 'Dispatched to Site',
        actionSubtitle: '1.5 Tons to Sunrise Villa',
      ),
    ],
  ),
  StockItem(
    id: 'STK-003',
    name: 'River Sand',
    category: 'Raw Materials',
    quantityValue: '80',
    quantityUnit: 'Bags',
    status: StockStatus.good,
    utilizedValue: '500',
    utilizedUnit: 'Bags',
    wastedValue: '10',
    wastedUnit: 'Bags',
    history: [],
  ),
  StockItem(
    id: 'STK-004',
    name: 'Wheelbarrow',
    category: 'Tools',
    quantityValue: '2',
    quantityUnit: 'Units',
    status: StockStatus.low,
    utilizedValue: '15',
    utilizedUnit: 'Units',
    wastedValue: '3',
    wastedUnit: 'Units',
    history: [],
  ),
];
