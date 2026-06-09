import 'package:flutter/foundation.dart';
import '../models/project_models.dart';

class ClientProjectService extends ChangeNotifier {
  static final ClientProjectService _instance = ClientProjectService._internal();

  factory ClientProjectService() => _instance;

  ClientProjectService._internal();

  final List<ProjectInvite> _invites = [
    ProjectInvite(
      id: 'inv_1',
      projectName: 'Dream Home Villa',
      adminName: 'Aatzy Build (Suresh)',
      propertyType: 'Residential',
      location: 'Chennai, Tamil Nadu',
    )
  ];

  final List<ClientProject> _activeProjects = [];

  List<ProjectInvite> get pendingInvites => _invites.where((i) => i.status == 'Pending').toList();
  List<ClientProject> get activeProjects => List.unmodifiable(_activeProjects);

  void acceptInvite(String inviteId) {
    final inviteIndex = _invites.indexWhere((i) => i.id == inviteId);
    if (inviteIndex != -1) {
      _invites[inviteIndex].status = 'Accepted';
      
      // Convert invite to an active project
      final invite = _invites[inviteIndex];
      _activeProjects.add(ClientProject(
        id: 'proj_${invite.id}',
        name: invite.projectName,
        contractorName: invite.adminName,
        completionPercentage: 5.0,
        status: 'Site Preparation',
        totalBudget: 4500000,
        amountPaid: 500000,
        nextPaymentDate: '15 Jul 2026',
        recentUpdate: 'Land clearing completed. Awaiting foundation marking.',
      ));
      
      notifyListeners();
    }
  }

  void declineInvite(String inviteId) {
    final inviteIndex = _invites.indexWhere((i) => i.id == inviteId);
    if (inviteIndex != -1) {
      _invites[inviteIndex].status = 'Declined';
      notifyListeners();
    }
  }
}
