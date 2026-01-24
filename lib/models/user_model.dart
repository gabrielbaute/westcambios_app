import 'package:client_app/models/enums.dart';

class UserResponse {
  final int id;
  final String email;
  final String username;
  final bool isActive;
  final UserRole role;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserResponse({
    required this.id,
    required this.email,
    required this.username,
    required this.isActive,
    required this.role,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] as int,
      email: json['email'] as String,
      username: json['username'] as String,
      isActive: json['is_active'] as bool,
      // Manejo de Enum compatible con tu backend
      role: UserRole.values.byName((json['role'] as String).toUpperCase()),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }
}

class UserCreate {
  final String email;
  final String username;
  final String
  password; // En el backend llega como password_hash, pero el cliente envía texto plano

  UserCreate({
    required this.email,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      // Importante: tu esquema UserCreate espera 'password_hash'
      'password_hash': password,
      'is_active': true,
      'role': 'CLIENT',
    };
  }
}

class AuthToken {
  final String accessToken;
  final String tokenType;

  AuthToken({required this.accessToken, required this.tokenType});

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
    );
  }
}
