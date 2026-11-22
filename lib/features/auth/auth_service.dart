import '../../core/api_client.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthUser {
  final String id;
  final String name;
  final String email;
  final String role; // 'user', 'agent' or 'admin'

  AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory AuthUser.fromJson(Map<String, dynamic> j) => AuthUser(
        id: j['id'] as String,
        name: j['name'] as String,
        email: j['email'] as String,
        role: (j['role'] ?? 'user') as String,
      );
}

class AuthService {
  final _api = ApiClient.instance;

  Future<AuthUser> login(String email, String password) async {
    final res = await _api.dio
        .post('/auth/login', data: {'email': email, 'password': password});
    final data = res.data['data'];
    await _api.saveToken(data['token'] as String);
    return AuthUser.fromJson(data['user'] as Map<String, dynamic>);
  }

  /// A client can never enter through the client form with an admin account.
  Future<AuthUser> loginClient(String email, String password) async {
    final u = await login(email, password);
    if (u.role == 'admin') {
      await logout();
      throw AuthException(
          'Ce compte est administrateur. Utilisez « Espace admin ».');
    }
    return u;
  }

  /// Only admin accounts can enter through the admin form.
  Future<AuthUser> loginAdmin(String email, String password) async {
    final u = await login(email, password);
    if (u.role != 'admin') {
      await logout();
      throw AuthException('Accès réservé aux administrateurs.');
    }
    return u;
  }

  Future<AuthUser> register(
      String name, String email, String password, String phone) async {
    final res = await _api.dio.post('/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
      if (phone.isNotEmpty) 'phone': phone,
    });
    final data = res.data['data'];
    await _api.saveToken(data['token'] as String);
    return AuthUser.fromJson(data['user'] as Map<String, dynamic>);
  }

  Future<void> forgotPassword(String email) async {
    await _api.dio.post('/auth/forgot-password', data: {'email': email});
  }

  Future<void> resetPassword(
      String email, String code, String newPassword) async {
    await _api.dio.post('/auth/reset-password',
        data: {'email': email, 'code': code, 'newPassword': newPassword});
  }

  Future<void> logout() => _api.clearToken();
}
