import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:client_app/app_routes.dart';
import 'package:client_app/utils/background_worker.dart';
import 'package:client_app/services/api_client.dart';
import 'package:client_app/services/calc_service.dart';
import 'package:client_app/services/notification_service.dart';
import 'package:client_app/ui/themes/west_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Workmanager
  Workmanager().initialize(callbackDispatcher);

  // Registrar tarea periódica (mínimo 15 min por OS)
  Workmanager().registerPeriodicTask(
    "1",
    "checkRateTask",
    frequency: const Duration(minutes: 15),
  );

  final apiClient = ApiClient();
  final calcService = CalcService(apiClient: apiClient);
  final notificationService = NotificationService(apiClient: apiClient);

  await notificationService.initNotification();

  runApp(
    WestCambiosApp(
      calcService: calcService,
      notificationService: notificationService,
    ),
  );
}

class WestCambiosApp extends StatelessWidget {
  final CalcService calcService;
  final NotificationService notificationService;

  const WestCambiosApp({
    super.key,
    required this.calcService,
    required this.notificationService,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WestCambios',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: WestColors.orangePrimary,
      ),

      // Indicamos que use nuestro sistema de rutas
      initialRoute: AppRoutes.home,
      onGenerateRoute: (settings) =>
          AppRoutes.generateRoute(settings, calcService, notificationService),
    );
  }
}
