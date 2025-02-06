// lib/services/auth/memory_password_service.dart
import 'dart:math';

class MemoryPasswordService {
  static final Map<String, _ResetRequest> _resetRequests = {};

  static final Map<String, String> _users = {
    'usuario@ejemplo.com': '123456',
    'admin@ejemplo.com': 'admin123',
  };

  String _generateToken() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random.secure();
    return List.generate(32, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  Future<bool> requestPasswordReset(String email) async {
    await Future.delayed(const Duration(seconds: 2));

    if (!_users.containsKey(email)) {
      return false;
    }

    final token = _generateToken();
    _resetRequests[email] = _ResetRequest(
      token: token,
      timestamp: DateTime.now(),
    );

    // En una app real, aquí enviarías el email
    print('Token generado para $email: $token'); // Solo para desarrollo

    return true;
  }

  // Verificar token
  bool verifyToken(String email, String token) {
    final request = _resetRequests[email];
    if (request == null) return false;

    // Verificar si el token no ha expirado (15 minutos)
    final isValid = request.token == token &&
        DateTime.now().difference(request.timestamp).inMinutes < 15;

    return isValid;
  }

  // Cambiar contraseña
  Future<bool> resetPassword(
      String email, String token, String newPassword) async {
    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));

    if (!verifyToken(email, token)) return false;

    // Actualizar contraseña
    _users[email] = newPassword;

    // Eliminar token usado
    _resetRequests.remove(email);

    return true;
  }
}

class _ResetRequest {
  final String token;
  final DateTime timestamp;

  _ResetRequest({
    required this.token,
    required this.timestamp,
  });
}
