enum LogisticStatus { inTransit, delivered }

class TransportedMaterial {
  final String name;
  final String quantityValue;
  final String quantityUnit;

  TransportedMaterial({
    required this.name,
    required this.quantityValue,
    required this.quantityUnit,
  });
}

class LogisticTrip {
  final String id;
  final String fromLocation;
  final String toLocation;
  final String vehicleNumber;
  final String vehicleType;
  final String driverName;
  final String driverPhone;
  final LogisticStatus status;
  final List<TransportedMaterial> materials;

  LogisticTrip({
    required this.id,
    required this.fromLocation,
    required this.toLocation,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.driverName,
    required this.driverPhone,
    required this.status,
    required this.materials,
  });
}

final List<LogisticTrip> mockLogistics = [
  LogisticTrip(
    id: '#TR-089',
    fromLocation: 'Chennai Main Godown',
    toLocation: 'Metro Towers Site',
    vehicleNumber: 'TN-38 AK 4521',
    vehicleType: 'Tipper',
    driverName: 'Murugan',
    driverPhone: '+91 98451 22340',
    status: LogisticStatus.inTransit,
    materials: [
      TransportedMaterial(name: 'OPC 53 Grade Cement', quantityValue: '50', quantityUnit: 'Bags'),
      TransportedMaterial(name: 'River Sand', quantityValue: '15', quantityUnit: 'Units'),
    ],
  ),
  LogisticTrip(
    id: '#TR-090',
    fromLocation: 'RK Steel Industries',
    toLocation: 'Chennai Main Godown',
    vehicleNumber: 'TN-07 BM 9983',
    vehicleType: 'Truck',
    driverName: 'Senthil',
    driverPhone: '+91 98765 43210',
    status: LogisticStatus.delivered,
    materials: [
      TransportedMaterial(name: 'Steel Rod 12mm', quantityValue: '1.5', quantityUnit: 'Tons'),
    ],
  ),
];
