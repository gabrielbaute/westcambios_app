import 'package:flutter/material.dart';
import 'package:client_app/services/notification_service.dart';
import 'package:client_app/ui/themes/west_themes.dart';

class NotificationsPage extends StatelessWidget {
  final NotificationService notificationService;

  const NotificationsPage({super.key, required this.notificationService});

  @override
  Widget build(BuildContext context) {
    final items = notificationService.history;

    return Scaffold(
      appBar: AppBar(title: const Text("Centro de Mensajes")),
      body: items.isEmpty
          ? const Center(child: Text("No tienes notificaciones recientes"))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.notifications_active,
                      color: WestColors.orangePrimary,
                    ),
                    title: Text(items[index]['title']!),
                    subtitle: Text(items[index]['body']!),
                    trailing: Text(items[index]['time']!),
                  ),
                );
              },
            ),
    );
  }
}
