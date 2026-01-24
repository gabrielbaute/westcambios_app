import 'package:flutter/material.dart';
import 'package:client_app/ui/layouts/main_layout.dart';
import 'package:client_app/ui/pages/settings_page.dart';
import 'package:client_app/ui/pages/auth/login_page.dart';
import 'package:client_app/ui/pages/profile_page.dart';
import 'package:client_app/ui/pages/notifications_page.dart';

import 'package:client_app/services/calc_service.dart';
import 'package:client_app/services/notification_service.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String profile = '/profile';
  static const String settingspage = '/settings';
  static const String notifications = '/notifications';

  static Route<dynamic> generateRoute(
    RouteSettings settings,
    CalcService calcService,
    NotificationService notificationService,
  ) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => MainLayout(
            calcService: calcService,
            notificationService: notificationService,
          ),
        );
      case login:
        // Inyectamos el apiClient desde el calcService
        return MaterialPageRoute(
          builder: (_) => LoginPage(apiClient: calcService.apiClient),
        );
      case profile:
        // Asumiendo que ProfilePage también lo necesitará para getMe()
        return MaterialPageRoute(
          builder: (_) => ProfilePage(apiClient: calcService.apiClient),
        );
      case notifications:
        return MaterialPageRoute(
          builder: (_) =>
              NotificationsPage(notificationService: notificationService),
        );
      case settingspage:
        return MaterialPageRoute(builder: (_) => SettingsPage());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Ruta no encontrada'))),
        );
    }
  }
}
