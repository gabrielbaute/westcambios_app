import 'package:flutter/material.dart';
import 'package:client_app/app_routes.dart';
import 'package:client_app/services/api_client.dart';
import 'package:client_app/services/auth_service.dart';
import 'package:client_app/ui/themes/west_themes.dart';
import 'package:client_app/ui/components/navigation/drawer_item.dart';
import 'package:client_app/ui/pages/auth/login_page.dart';
import 'package:client_app/ui/pages/auth/register_page.dart';

class CustomDrawer extends StatelessWidget {
  final ApiClient apiClient;

  const CustomDrawer({super.key, required this.apiClient});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(),
          FutureBuilder<bool>(
            future: AuthService().hasToken(),
            builder: (context, snapshot) {
              final bool isLoggedIn = snapshot.data ?? false;

              return Column(
                children: [
                  if (isLoggedIn) ...[
                    DrawerItem(
                      icon: Icons.account_circle,
                      title: "Mi Perfil",
                      onTap: () => Navigator.pushNamed(context, '/profile'),
                    ),
                    DrawerItem(
                      icon: Icons.logout,
                      title: "Cerrar Sesión",
                      color: Colors.redAccent,
                      onTap: () async {
                        await AuthService().deleteToken();
                        if (context.mounted)
                          Navigator.pushReplacementNamed(context, '/');
                      },
                    ),
                  ] else ...[
                    DrawerItem(
                      icon: Icons.login,
                      title: "Iniciar Sesión",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LoginPage(apiClient: apiClient),
                          ),
                        );
                      },
                    ),
                    DrawerItem(
                      icon: Icons.person_add,
                      title: "Registro",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RegisterPage(apiClient: apiClient),
                          ),
                        );
                      },
                    ),
                    const Divider(), // Separador visual
                    DrawerItem(
                      icon: Icons.settings_outlined,
                      title: "Configuración",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRoutes.settingspage);
                      },
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const DrawerHeader(
      decoration: BoxDecoration(color: WestColors.orangeLight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: WestColors.whiteBone,
            child: Icon(Icons.person, color: WestColors.orangePrimary),
          ),
          SizedBox(height: 10),
          Text(
            "WestCambios",
            style: TextStyle(
              color: WestColors.whitePure,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
