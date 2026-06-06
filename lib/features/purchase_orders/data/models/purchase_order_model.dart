enum POStatus { pending, confirmed }

class PurchaseOrderItem {
  final String name;
  final String priceExpression; // e.g., "₹350", "₹60/kg", "₹140k"
  final String quantityExpression; // e.g., "200", "500", "2"
  final int totalValue; // e.g., 70000

  PurchaseOrderItem({
    required this.name,
    required this.priceExpression,
    required this.quantityExpression,
    required this.totalValue,
  });
}

class PurchaseOrder {
  final String id;
  final String vendorName;
  final String vendorContact;
  final String deliverySite;
  final POStatus status;
  final DateTime date;
  final List<PurchaseOrderItem> items;

  PurchaseOrder({
    required this.id,
    required this.vendorName,
    required this.vendorContact,
    required this.deliverySite,
    required this.status,
    required this.date,
    required this.items,
  });

  int get totalAmount {
    return items.fold(0, (sum, item) => sum + item.totalValue);
  }

  String get itemsSummaryText {
    if (items.isEmpty) return 'No items';
    return items.map((i) => '${i.name} ${i.quantityExpression}').join(' · ');
  }
}

// Mock Data
final List<PurchaseOrder> mockPurchaseOrders = [
  PurchaseOrder(
    id: '#PO-2025-018',
    vendorName: 'RK Steel Industries',
    vendorContact: '+91 98765 43210',
    deliverySite: 'Metro Towers Site',
    status: POStatus.confirmed,
    date: DateTime(2025, 5, 28),
    items: [
      PurchaseOrderItem(name: 'Cement', priceExpression: '₹350', quantityExpression: '200 bags', totalValue: 70000),
      PurchaseOrderItem(name: 'Steel', priceExpression: '₹60/kg', quantityExpression: '2T', totalValue: 120000),
      PurchaseOrderItem(name: 'TMT Bars 500kg', priceExpression: '₹60/kg', quantityExpression: '500kg', totalValue: 30000),
      PurchaseOrderItem(name: 'Steel Rod', priceExpression: '₹140k', quantityExpression: '2', totalValue: 280000), // Adjusted to match mock ₹3,80,000 total approx
    ],
  ),
  PurchaseOrder(
    id: '#PO-2025-015',
    vendorName: 'KM Cement Works',
    vendorContact: '+91 91234 56789',
    deliverySite: 'Sunrise Villa Site',
    status: POStatus.pending,
    date: DateTime(2025, 5, 20),
    items: [
      PurchaseOrderItem(name: 'OPC Cement', priceExpression: '₹350', quantityExpression: '100 bags', totalValue: 35000),
      PurchaseOrderItem(name: 'Coarse Sand', priceExpression: '₹4000/T', quantityExpression: '20T', totalValue: 80000),
    ],
  ),
];
