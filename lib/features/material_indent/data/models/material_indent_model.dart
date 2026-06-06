class MaterialItem {
  final String category;
  final String name;
  final String quantity;

  MaterialItem({
    required this.category,
    required this.name,
    required this.quantity,
  });
}

enum IndentPriority { high, low }

enum IndentStatus { pending, approved, rejected }

class MaterialIndent {
  final String id;
  final String siteName;
  final String assignedTo;
  final IndentPriority priority;
  IndentStatus status;
  final DateTime endDate;
  final List<MaterialItem> materials;
  final String description;

  MaterialIndent({
    required this.id,
    required this.siteName,
    required this.assignedTo,
    required this.priority,
    required this.status,
    required this.endDate,
    required this.materials,
    this.description = '',
  });

  String get summaryText {
    if (materials.isEmpty) return 'No materials requested';
    return materials.map((m) => '${m.name} - ${m.quantity}').join(', ');
  }
}

// Mock Data
final List<MaterialIndent> mockIndents = [
  MaterialIndent(
    id: '#IND-2025-041',
    siteName: 'Metro Towers Site',
    assignedTo: 'Raj Kumar',
    priority: IndentPriority.high,
    status: IndentStatus.pending,
    endDate: DateTime(2025, 6, 15),
    materials: [
      MaterialItem(category: 'Cement', name: 'Cement', quantity: '200 bags'),
      MaterialItem(category: 'Steel', name: 'Steel Rod 12mm', quantity: '2 Tons'),
    ],
  ),
  MaterialIndent(
    id: '#IND-2025-039',
    siteName: 'Sunrise Villa Site',
    assignedTo: 'Suresh K.',
    priority: IndentPriority.low,
    status: IndentStatus.approved,
    endDate: DateTime(2025, 6, 20),
    materials: [
      MaterialItem(category: 'Sand', name: 'Sand', quantity: '50 bags'),
      MaterialItem(category: 'Bricks', name: 'Bricks', quantity: '500 units'),
    ],
  ),
  MaterialIndent(
    id: '#IND-2025-037',
    siteName: 'Lakeside Phase 2',
    assignedTo: 'Amit Patel',
    priority: IndentPriority.high,
    status: IndentStatus.rejected,
    endDate: DateTime(2025, 6, 10),
    materials: [
      MaterialItem(category: 'Electrical', name: 'Wiring Cable 2.5mm', quantity: '10 coils'),
    ],
    description: 'Urgent wiring required',
  ),
  MaterialIndent(
    id: '#IND-2025-035',
    siteName: 'Metro Towers Site',
    assignedTo: 'Raj Kumar',
    priority: IndentPriority.low,
    status: IndentStatus.pending,
    endDate: DateTime(2025, 6, 25),
    materials: [
      MaterialItem(category: 'Plumbing', name: 'PVC Pipe 4 inch', quantity: '100 pipes'),
      MaterialItem(category: 'Plumbing', name: 'Fittings Set', quantity: '50 boxes'),
    ],
  ),
];
