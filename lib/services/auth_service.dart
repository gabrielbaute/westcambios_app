import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // Implementación de Singleton para asegurar una única fuente de verdad
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _storage = const FlutterSecureStorage();

  // Constantes para evitar errores de typos (Hardcoded strings)
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  /// Guarda el token JWT de forma segura
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Recupera el token. Si no existe, devuelve null.
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Elimina el token (Logout)
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Verifica si hay una sesión activa sin necesidad de llamar a la API
  Future<bool> hasToken() async {
    String? token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
