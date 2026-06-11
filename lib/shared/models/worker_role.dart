enum WorkerRole { siteEngineer, projectManager, supervisor }

extension WorkerRoleExtension on WorkerRole {
  String get label {
    switch (this) {
      case WorkerRole.siteEngineer:
        return 'Site Engineer';
      case WorkerRole.projectManager:
        return 'Project Manager';
      case WorkerRole.supervisor:
        return 'Supervisor';
    }
  }
}
