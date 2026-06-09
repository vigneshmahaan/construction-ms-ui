enum UserRole { admin, client, worker }

extension UserRoleExtension on UserRole {
  String get key {
    switch (this) {
      case UserRole.admin:
        return 'admin';
      case UserRole.client:
        return 'client';
      case UserRole.worker:
        return 'worker';
    }
  }

  String get label {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.client:
        return 'Client';
      case UserRole.worker:
        return 'Worker';
    }
  }

  static UserRole fromKey(String key) {
    switch (key) {
      case 'client':
        return UserRole.client;
      case 'worker':
        return UserRole.worker;
      default:
        return UserRole.admin;
    }
  }
}
