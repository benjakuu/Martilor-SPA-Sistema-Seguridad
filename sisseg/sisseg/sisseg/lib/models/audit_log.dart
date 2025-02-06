// lib/models/audit_log.dart
enum AuditAction {
  login,
  logout,
  roleChange,
  securityUpdate,
  userCreation,
  userUpdate,
  documentAccess,
  configChange,
  failedLogin,
}

class AuditLog {
  final String id;
  final DateTime timestamp;
  final String userId;
  final String userName;
  final AuditAction action;
  final String description;
  final String? details;
  final String ipAddress;

  const AuditLog({
    required this.id,
    required this.timestamp,
    required this.userId,
    required this.userName,
    required this.action,
    required this.description,
    this.details,
    required this.ipAddress,
  });

  String get actionText {
    switch (action) {
      case AuditAction.login:
        return 'Inicio de sesión';
      case AuditAction.logout:
        return 'Cierre de sesión';
      case AuditAction.roleChange:
        return 'Cambio de rol';
      case AuditAction.securityUpdate:
        return 'Actualización de seguridad';
      case AuditAction.userCreation:
        return 'Creación de usuario';
      case AuditAction.userUpdate:
        return 'Actualización de usuario';
      case AuditAction.documentAccess:
        return 'Acceso a documento';
      case AuditAction.configChange:
        return 'Cambio de configuración';
      case AuditAction.failedLogin:
        return 'Intento fallido de inicio de sesión';
    }
  }

  String get formattedTimestamp {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute}';
  }
}
