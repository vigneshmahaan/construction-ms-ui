import 'package:flutter/foundation.dart';
import '../models/worker.dart';

class WorkerService extends ChangeNotifier {
  static final WorkerService _instance = WorkerService._internal();

  factory WorkerService() {
    return _instance;
  }

  WorkerService._internal();

  final List<Worker> _workers = [
    Worker(
      id: 'w1',
      name: 'Vicky',
      phone: '9876543210',
      role: 'Site Engineer',
      payType: 'Daily',
      wageAmount: '800',
      idProofType: 'Aadhar',
      idProofNumber: 'XXXX-XXXX-1111',
      state: 'Tamil Nadu',
      city: 'Chennai',
      assignedProjectIds: ['home1', 'home2'],
      permissions: {
        'warehouse': true, 'material_indent': true, 'purchase_orders': false,
        'stocks_hub': true, 'logistics': true, 'vehicles': true,
        'vendors': false, 'centralized_attendance': true,
      },
    ),
    Worker(
      id: 'w2',
      name: 'Dinesh',
      phone: '9876543211',
      role: 'Supervisor',
      payType: 'Daily',
      wageAmount: '600',
      idProofType: 'PAN',
      idProofNumber: 'ABCDE1111F',
      state: 'Tamil Nadu',
      city: 'Chennai',
      assignedProjectIds: ['home1'],
      permissions: {
        'warehouse': false, 'material_indent': false, 'purchase_orders': false,
        'stocks_hub': false, 'logistics': false, 'vehicles': true,
        'vendors': true, 'centralized_attendance': false,
      },
    ),
    Worker(
      id: 'w3',
      name: 'Pooja',
      phone: '9876543212',
      role: 'Project Manager',
      payType: 'Monthly',
      wageAmount: '35000',
      idProofType: 'Aadhar',
      idProofNumber: 'XXXX-XXXX-2222',
      state: 'Tamil Nadu',
      city: 'Chennai',
      assignedProjectIds: ['home2'],
      permissions: {
        'warehouse': true, 'material_indent': true, 'purchase_orders': true,
        'stocks_hub': true, 'logistics': true, 'vehicles': true,
        'vendors': true, 'centralized_attendance': true,
      },
    ),
    Worker(
      id: 'w4',
      name: 'Saranya',
      phone: '9876543213',
      role: 'Site Engineer',
      payType: 'Monthly',
      wageAmount: '25000',
      idProofType: 'Aadhar',
      idProofNumber: 'XXXX-XXXX-3333',
      state: 'Tamil Nadu',
      city: 'Chennai',
      assignedProjectIds: ['home2'],
      permissions: {
        'warehouse': true, 'material_indent': true, 'purchase_orders': false,
        'stocks_hub': true, 'logistics': true, 'vehicles': true,
        'vendors': false, 'centralized_attendance': true,
      },
    ),
    Worker(
      id: 'w5',
      name: 'Sruthi',
      phone: '9876543214',
      role: 'Supervisor',
      payType: 'Daily',
      wageAmount: '550',
      idProofType: 'Aadhar',
      idProofNumber: 'XXXX-XXXX-4444',
      state: 'Tamil Nadu',
      city: 'Chennai',
      assignedProjectIds: ['home1'],
      permissions: {
        'warehouse': true, 'material_indent': false, 'purchase_orders': false,
        'stocks_hub': false, 'logistics': false, 'vehicles': true,
        'vendors': false, 'centralized_attendance': true,
      },
    ),
  ];

  List<Worker> get workers => List.unmodifiable(_workers);

  void addWorker(Worker worker) {
    _workers.add(worker);
    notifyListeners();
  }

  void updateWorker(Worker worker) {
    final index = _workers.indexWhere((w) => w.id == worker.id);
    if (index != -1) {
      _workers[index] = worker;
      notifyListeners();
    }
  }

  void deleteWorker(String id) {
    _workers.removeWhere((w) => w.id == id);
    notifyListeners();
  }
}
