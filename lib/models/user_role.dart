enum UserRole {
  superAdmin,
  branchManager,
  cashier,
  chef,
  waiter;

  String get displayName {
    switch (this) {
      case UserRole.superAdmin:
        return 'Admin / Owner';
      case UserRole.branchManager:
        return 'Branch Manager';
      case UserRole.cashier:
        return 'Cashier / POS';
      case UserRole.chef:
        return 'Head Chef (KDS)';
      case UserRole.waiter:
        return 'Waitstaff';
    }
  }

  String get badgeLabel {
    switch (this) {
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.branchManager:
        return 'Manager';
      case UserRole.cashier:
        return 'Cashier';
      case UserRole.chef:
        return 'Kitchen';
      case UserRole.waiter:
        return 'Waiter';
    }
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String branchId;
  final String avatarUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.branchId,
    this.avatarUrl = '',
  });
}

