import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'api_client.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final ApiClient _apiClient;

  List<Map<String, String>> _history = [];
  static const String _storageKey = 'notification_history';

  NotificationService({required ApiClient apiClient}) : _apiClient = apiClient;

  List<Map<String, String>> get history => _history;

  /// Carga el historial persistido al iniciar la app
  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);
    await _loadHistoryFromDisk();
  }

  Future<void> _loadHistoryFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString(_storageKey);
    if (savedData != null) {
      final List<dynamic> decoded = json.decode(savedData);
      _history = decoded.map((item) => Map<String, String>.from(item)).toList();
    }
  }

  Future<void> _saveHistoryToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, json.encode(_history));
  }

  Future<void> checkForRateUpdates() async {
    try {
      final rateList = await _apiClient.getTodayRates();
      if (rateList.rates.isNotEmpty) {
        final currentRate = rateList.rates.first.rate;

        // Simulación de comparación de lógica
        // En una implementación real, persistirías también '_lastKnownRate'
        await _showNotification(
          title: "Actualización de Tasa",
          body: "La nueva tasa es $currentRate BRL/VES",
        );
      }
    } catch (e) {
      print("Worker Error: $e");
    }
  }

  Future<void> _showNotification({
    required String title,
    required String body,
  }) async {
    // 1. Actualizar memoria y disco
    _history.insert(0, {
      'title': title,
      'body': body,
      'time': DateTime.now().toString().substring(11, 16),
    });
    await _saveHistoryToDisk();

    // 2. Notificación física
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'rate_alerts',
          'Alertas',
          importance: Importance.max,
          priority: Priority.high,
        );
    await _notificationsPlugin.show(
      0,
      title,
      body,
      const NotificationDetails(android: androidDetails),
    );
  }
}
