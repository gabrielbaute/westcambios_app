// lib/models/rate_model.dart

import 'enums.dart';

class RateResponse {
  final int id;
  final Currency fromCurrency;
  final Currency toCurrency;
  final double rate;
  final DateTime timestamp;

  RateResponse({
    required this.id,
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
    required this.timestamp,
  });

  /// Factory para crear un objeto desde el JSON de FastAPI
  factory RateResponse.fromJson(Map<String, dynamic> json) {
    return RateResponse(
      id: json['id'] as int,
      fromCurrency: Currency.values.byName(json['from_currency']),
      toCurrency: Currency.values.byName(json['to_currency']),
      rate: (json['rate'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class RateListResponse {
  final int count;
  final List<RateResponse> rates;

  RateListResponse({required this.count, required this.rates});

  factory RateListResponse.fromJson(Map<String, dynamic> json) {
    return RateListResponse(
      count: json['count'] as int,
      rates: (json['rates'] as List)
          .map((r) => RateResponse.fromJson(r as Map<String, dynamic>))
          .toList(),
    );
  }
}
