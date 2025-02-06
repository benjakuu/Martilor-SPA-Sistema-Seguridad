enum UserRole { admin, standard }

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? photoUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.photoUrl,
  });

  bool get isAdmin => role == UserRole.admin;

  bool canAccessAdminFeatures() => isAdmin;
  bool canEditSettings() => isAdmin;
  bool canManageUsers() => isAdmin;
  bool canViewDocuments() => true;
  bool canEditProfile() => true;
}
