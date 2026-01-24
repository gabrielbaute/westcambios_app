import 'package:flutter/material.dart';
import 'package:client_app/services/api_client.dart';
import 'package:client_app/models/user_model.dart';
import 'package:client_app/ui/themes/west_themes.dart';

class ProfilePage extends StatelessWidget {
  final ApiClient apiClient;

  const ProfilePage({super.key, required this.apiClient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WestColors.whiteBone,
      appBar: AppBar(title: const Text("Mi Perfil"), elevation: 0),
      body: FutureBuilder<UserResponse>(
        future: apiClient.getMe(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text("Error al cargar perfil: ${snapshot.error}"),
                ],
              ),
            );
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildProfileHeader(user),
                const SizedBox(height: 24),
                _buildInfoSection(user),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(UserResponse user) {
    return Center(
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: WestColors.orangePrimary,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            user.username,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Chip(
            label: Text(user.role.name),
            backgroundColor: WestColors.orangeLight,
            labelStyle: const TextStyle(color: WestColors.orangePrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(UserResponse user) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow(Icons.email, "Correo", user.email),
            const Divider(),
            _buildInfoRow(
              Icons.calendar_today,
              "Miembro desde",
              user.createdAt.toString().substring(0, 10),
            ),
            const Divider(),
            _buildInfoRow(
              Icons.verified_user,
              "Estado",
              user.isActive ? "Activo" : "Inactivo",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: WestColors.grayDark, size: 20),
          const SizedBox(width: 15),
          Text(label, style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
