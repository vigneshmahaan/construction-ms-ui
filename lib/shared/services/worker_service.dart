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
      id: '1',
      name: 'Suresh Kannan',
      phone: '9876543210',
      role: 'Site Engineer',
      payType: 'Daily',
      wageAmount: '800',
      idProofType: 'Aadhar',
      idProofNumber: 'XXXX-XXXX-1234',
      state: 'Tamil Nadu',
      city: 'Chennai',
    ),
    Worker(
      id: '2',
      name: 'Priya Murugan',
      phone: '9876543211',
      role: 'Supervisor',
      payType: 'Daily',
      wageAmount: '600',
      idProofType: 'PAN',
      idProofNumber: 'ABCDE1234F',
      state: 'Karnataka',
      city: 'Bangalore',
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
