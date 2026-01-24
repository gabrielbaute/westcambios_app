import 'package:flutter/material.dart';
import 'package:client_app/services/api_client.dart';
import 'package:client_app/services/auth_service.dart';
import 'package:client_app/ui/components/auth/auth_text_field.dart';
import 'package:client_app/ui/components/auth/auth_button.dart';
import 'package:client_app/ui/themes/west_themes.dart';
import 'package:client_app/ui/pages/auth/register_page.dart';

class LoginPage extends StatefulWidget {
  final ApiClient apiClient;
  const LoginPage({super.key, required this.apiClient});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    // 1. Iniciamos el estado de carga ANTES de la petición
    setState(() => _isLoading = true);

    try {
      // 2. Realizamos UNA SOLA llamada al backend
      final authToken = await widget.apiClient.login(
        _emailController.text.trim(),
        _passController.text,
      );

      // 3. Persistimos el token usando el AuthService
      await AuthService().saveToken(authToken.accessToken);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Bienvenido a WestCambios")),
        );
        // Volvemos a la pantalla anterior (o al Home)
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      // 4. Cerramos el estado de carga siempre, falle o tenga éxito
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WestColors.whiteBone,
      appBar: AppBar(title: const Text("Iniciar Sesión")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(
                Icons.lock_person_outlined,
                size: 80,
                color: WestColors.orangePrimary,
              ),
              const SizedBox(height: 32),
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
                validator: (v) => v!.isEmpty ? "Ingresa tu contraseña" : null,
              ),
              const SizedBox(height: 32),
              AuthButton(
                text: "Entrar",
                isLoading: _isLoading,
                onPressed: _handleLogin,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RegisterPage(apiClient: widget.apiClient),
                    ),
                  );
                },
                child: const Text(
                  "¿No tienes cuenta? Regístrate aquí",
                  style: TextStyle(color: WestColors.grayDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
