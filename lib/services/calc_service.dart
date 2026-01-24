import 'package:client_app/models/rate_model.dart';
import 'package:client_app/services/api_client.dart';
import 'package:client_app/models/enums.dart';

class CalcService {
  final ApiClient _apiClient;
  ApiClient get apiClient => _apiClient;

  // Propiedades privadas para almacenar el estado actual de las tasas
  RateResponse? _brlRate;
  RateResponse? _usdRate;

  CalcService({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Actualiza las tasas de cambio consultando la API.
  /// Utiliza [Future.wait] para realizar ambas peticiones en paralelo,
  /// optimizando el tiempo de respuesta de la red.
  Future<void> refreshRate() async {
    try {
      // Ejecutamos ambas peticiones de forma concurrente
      final results = await Future.wait([
        _apiClient.getLatestBrlRate(),
        _apiClient.getLatestUsdRate(),
      ]);

      // Asignamos los resultados (el orden coincide con el de la lista en Future.wait)
      _brlRate = results[0];
      _usdRate = results[1];
    } catch (e) {
      // En un entorno de ingeniería, aquí podrías implementar un sistema de logs
      rethrow;
    }
  }

  // Getters con tipado explícito
  double get brlToVesRate => _brlRate?.rate ?? 0.0;
  double get usdToVesRate => _usdRate?.rate ?? 0.0;

  /// Realiza la conversión de Bolívares a Dólares basada en la tasa actual.
  ///
  /// Implementación del formalismo: VES / (USD/VES) = USD
  double calculateVesToUsd(double amountVes) {
    if (usdToVesRate == 0) return 0.0;
    return amountVes / usdToVesRate;
  }

  /// Realiza la conversión de Reales a Bolívares.
  ///
  /// Implementación del formalismo: BRL * (BRL/VES) = VES
  double calculateBrlToVes(double amountBrl) {
    return amountBrl * brlToVesRate;
  }

  /// Encapsula la lógica de conversión triple
  Map<String, double> performTripleConversion({
    required double amount,
    required Currency fromCurrency,
  }) {
    double ves = 0;
    double brl = 0;
    double usd = 0;

    if (fromCurrency == Currency.BRL) {
      ves = amount * brlToVesRate;
      usd = usdToVesRate > 0 ? ves / usdToVesRate : 0;
      brl = amount;
    } else if (fromCurrency == Currency.VES) {
      ves = amount;
      brl = brlToVesRate > 0 ? ves / brlToVesRate : 0;
      usd = usdToVesRate > 0 ? ves / usdToVesRate : 0;
    } else if (fromCurrency == Currency.USD) {
      usd = amount;
      ves = amount * usdToVesRate;
      brl = brlToVesRate > 0 ? ves / brlToVesRate : 0;
    }

    return {'BRL': brl, 'VES': ves, 'USD': usd};
  }
}
