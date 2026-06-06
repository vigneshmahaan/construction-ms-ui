const List<Map<String, dynamic>> mockWarehouses = [
  {
    'id': 'w1',
    'name': 'Chennai Main Godown',
    'address': '14, Industrial Estate, Chennai – 600058',
    'type': 'Godown',
    'lat': '11.0168° N',
    'lng': '76.9558° E',
  },
  {
    'id': 'w2',
    'name': 'Metro Towers Site Store',
    'address': 'Plot 22, Anna Salai, Chennai',
    'type': 'Site',
    'lat': '13.0827° N',
    'lng': '80.2707° E',
  },
];

const Map<String, dynamic> mockWarehouseDetails = {
  'w1': {
    'currentStock': [
      {
        'material': 'OPC 53 Grade Cement',
        'brand': 'UltraTech',
        'quantity': 540,
        'unit': 'Bags',
        'isLowStock': false,
      },
      {
        'material': 'TMT Steel Bars (12mm)',
        'brand': 'JSW NeoSteel',
        'quantity': 15.5,
        'unit': 'Tons',
        'isLowStock': false,
      },
      {
        'material': 'M-Sand (Plastering)',
        'brand': 'Local Vendor',
        'quantity': 12,
        'unit': 'Units',
        'isLowStock': true,
      },
    ],
    'logs': [
      {
        'title': 'Received Cement (OPC 53)',
        'subtitle': 'PO: #PO-4091 · UltraTech Vendor',
        'type': 'in',
        'quantity': '+ 200 Bags',
        'date': 'Today, 10:30 AM',
      },
      {
        'title': 'Dispatched TMT Steel',
        'subtitle': 'Sent to: Metro Towers Site',
        'type': 'out',
        'quantity': '- 5.0 Tons',
        'date': 'Yesterday, 04:15 PM',
      },
    ],
  },
  'w2': {
    'currentStock': [
      {
        'material': 'OPC 53 Grade Cement',
        'brand': 'UltraTech',
        'quantity': 150,
        'unit': 'Bags',
        'isLowStock': true,
      },
      {
        'material': 'TMT Steel Bars (12mm)',
        'brand': 'JSW NeoSteel',
        'quantity': 5.0,
        'unit': 'Tons',
        'isLowStock': false,
      },
    ],
    'logs': [
      {
        'title': 'Received TMT Steel',
        'subtitle': 'From: Chennai Main Godown',
        'type': 'in',
        'quantity': '+ 5.0 Tons',
        'date': 'Yesterday, 05:00 PM',
      },
    ],
  }
};
