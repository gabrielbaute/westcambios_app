import 'package:workmanager/workmanager.dart';
import 'package:client_app/services/api_client.dart';
import 'package:client_app/services/notification_service.dart';

@pragma(
  'vm:entry-point',
) // Obligatorio para que no se elimine en el tree-shaking
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Instanciamos los servicios necesarios para la tarea aislada
    final apiClient = ApiClient();
    final notificationService = NotificationService(apiClient: apiClient);

    await notificationService.initNotification();
    await notificationService.checkForRateUpdates();

    return Future.value(true);
  });
}
