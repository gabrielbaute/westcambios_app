import 'package:flutter/material.dart';
import 'package:client_app/models/user_model.dart';
import 'package:client_app/services/api_client.dart';
import 'package:client_app/ui/components/auth/auth_text_field.dart';
import 'package:client_app/ui/components/auth/auth_button.dart';
import 'package:client_app/ui/themes/west_themes.dart';

class RegisterPage extends StatefulWidget {
  final ApiClient apiClient;
  const RegisterPage({super.key, required this.apiClient});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final newUser = UserCreate(
        username: _userController.text.trim(),
        email: _emailController.text.trim(),
        password: _passController.text,
      );

      await widget.apiClient.register(newUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registro exitoso. Por favor inicia sesión."),
          ),
        );
        Navigator.pop(context); // Volver al Login
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WestColors.whiteBone,
      appBar: AppBar(title: const Text("Crear Cuenta")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(
                Icons.person_add_outlined,
                size: 80,
                color: WestColors.orangePrimary,
              ),
              const SizedBox(height: 32),
              AuthTextField(
                controller: _userController,
                label: "Usuario",
                icon: Icons.face,
                validator: (v) => v!.isEmpty ? "Ingresa un usuario" : null,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _emailController,
                label: "Correo Electrónico",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => !v!.contains("@") ? "Email inválido" : null,
              ),
              const SizedBox(height: 16),
              AuthTextField(
                controller: _passController,
                label: "Contraseña",
                icon: Icons.lock_outline,
                isPassword: true,
                validator: (v) => v!.length < 6 ? "Mínimo 6 caracteres" : null,
              ),
              const SizedBox(height: 32),
              AuthButton(
                text: "Registrarse",
                isLoading: _isLoading,
                onPressed: _handleRegister,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
