enum VehicleStatus { active, onSite, maintenance }

class CurrentAssignment {
  final String description;
  final String route;

  CurrentAssignment({
    required this.description,
    required this.route,
  });
}

class Vehicle {
  final String id;
  final String numberPlate;
  final String type; // e.g., Tipper, JCB, Lorry
  final String manufacturer;
  final String capacity;
  final String rcNumber;
  final VehicleStatus status;
  final String insuranceExpiry;
  final String fcExpiry;
  final String serviceDue;
  final bool isServiceOverdue; // true if service is due soon/overdue
  final String assignedDriverName;
  final String assignedDriverPhone;
  final CurrentAssignment? currentAssignment;

  Vehicle({
    required this.id,
    required this.numberPlate,
    required this.type,
    required this.manufacturer,
    required this.capacity,
    required this.rcNumber,
    required this.status,
    required this.insuranceExpiry,
    required this.fcExpiry,
    required this.serviceDue,
    this.isServiceOverdue = false,
    required this.assignedDriverName,
    required this.assignedDriverPhone,
    this.currentAssignment,
  });
}

final List<Vehicle> mockVehicles = [
  Vehicle(
    id: 'V-001',
    numberPlate: 'TN-38 AK 4521',
    type: 'Tipper',
    manufacturer: 'TATA',
    capacity: '8T',
    rcNumber: 'TN38-2021-0047',
    status: VehicleStatus.active,
    insuranceExpiry: '12 Oct 2025',
    fcExpiry: '24 Aug 2025',
    serviceDue: 'In 450 km',
    isServiceOverdue: true,
    assignedDriverName: 'Murugan',
    assignedDriverPhone: '+91 98451 22340',
    currentAssignment: CurrentAssignment(
      description: 'Delivering 50 Bags Cement',
      route: 'Chennai Main Godown -> Metro Towers',
    ),
  ),
  Vehicle(
    id: 'V-002',
    numberPlate: 'TN-07 BM 9983',
    type: 'JCB',
    manufacturer: 'Mahindra',
    capacity: '10T',
    rcNumber: 'TN07-2020-0189',
    status: VehicleStatus.onSite,
    insuranceExpiry: '05 Jan 2026',
    fcExpiry: '10 Feb 2026',
    serviceDue: 'In 2000 km',
    isServiceOverdue: false,
    assignedDriverName: 'Senthil',
    assignedDriverPhone: '+91 98765 43210',
    currentAssignment: null,
  ),
];
