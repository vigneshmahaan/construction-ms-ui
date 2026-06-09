class ProjectInvite {
  final String id;
  final String projectName;
  final String adminName;
  final String propertyType;
  final String location;
  String status; // 'Pending', 'Accepted', 'Declined'

  ProjectInvite({
    required this.id,
    required this.projectName,
    required this.adminName,
    required this.propertyType,
    required this.location,
    this.status = 'Pending',
  });
}

class ClientProject {
  final String id;
  final String name;
  final String contractorName;
  final double completionPercentage;
  final String status;
  final double totalBudget;
  final double amountPaid;
  final String nextPaymentDate;
  final String recentUpdate;

  ClientProject({
    required this.id,
    required this.name,
    required this.contractorName,
    required this.completionPercentage,
    required this.status,
    required this.totalBudget,
    required this.amountPaid,
    required this.nextPaymentDate,
    required this.recentUpdate,
  });
}
