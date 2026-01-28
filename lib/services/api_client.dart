import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:client_app/models/enums.dart';
import 'package:client_app/models/user_model.dart';
import 'package:client_app/models/rate_model.dart';
import 'package:client_app/services/auth_service.dart';

class ApiClient {
  final String baseUrl = "https://westcambios.samanbooks.online/api/v1";
  final AuthService _authService = AuthService();
  String? _token;

  // Setter para actualizar el token tras el login
  set token(String? value) => _token = value;

  /// Headers base con soporte para JSON y Auth
  Map<String, String> _getHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  /// Genera las cabeceras inyectando el token automáticamente si existe
  Future<Map<String, String>> _getAuthHeaders({bool isJson = true}) async {
    final Map<String, String> headers = {};

    if (isJson) {
      headers['Content-Type'] = 'application/json';
    } else {
      headers['Content-Type'] = 'application/x-www-form-urlencoded';
    }

    // Inyección automática del formalismo Bearer Token
    final String? token = await _authService.getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  /// Métodos de usuario/autenticación

  /// Login compatible con OAuth2PasswordRequestForm de FastAPI
  Future<AuthToken> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      // OAuth2 espera 'username' aunque le pasemos el email
      body: {'username': email, 'password': password},
    );

    final data = AuthToken.fromJson(_handleResponse(response));
    _token = data.accessToken;
    return data;
  }

  /// Registro de usuario - Envía JSON
  Future<UserResponse> register(UserCreate userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData.toJson()),
    );

    return UserResponse.fromJson(_handleResponse(response));
  }

  /// Obtener info del usuario actual (Users) - Requiere auth
  Future<UserResponse> getMe() async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: await _getAuthHeaders(),
    );

    return UserResponse.fromJson(_handleResponse(response));
  }

  /// Métodos para las tasas de cambio

  /// Obtener tasas del día de hoy (Exchange Rates) - No requiere auth
  Future<RateListResponse> getTodayRates() async {
    final response = await http.get(
      Uri.parse('$baseUrl/rates/today'),
      headers: _getHeaders(),
    );
    return RateListResponse.fromJson(_handleResponse(response));
  }

  /// Obtiene la tasa más reciente para una moneda específica (Base -> VES)
  /// Filtra la lista de hoy para encontrar el registro pertinente.
  Future<RateResponse?> getLatestRateFor(Currency fromCurrency) async {
    try {
      final RateListResponse dailyRates = await getTodayRates();

      // Buscamos el primer registro que coincida con la moneda de origen
      // y que tenga como destino VES (Bolívares)
      return dailyRates.rates.cast<RateResponse?>().firstWhere(
        (rate) =>
            rate?.fromCurrency == fromCurrency &&
            rate?.toCurrency == Currency.VES,
        orElse: () => null,
      );
    } catch (e) {
      // Si falla la red o el parseo, propagamos para que la UI lo maneje
      return null;
    }
  }

  /// Método específico para BRL -> VES (Tasa WestCambios)
  Future<RateResponse?> getLatestBrlRate() => getLatestRateFor(Currency.BRL);

  /// Método específico para USD -> VES (Tasa BCV/Referencia)
  Future<RateResponse?> getLatestUsdRate() => getLatestRateFor(Currency.USD);

  /// Método específico para USDT -> VES (Tasa Binance/P2P)
  Future<RateResponse?> getLatestUsdtRate() => getLatestRateFor(Currency.USDT);

  /// Obtener tasas de la ultima semana (Exchange Rates) - No requiere auth
  Future<RateListResponse> getWeekRates() async {
    final response = await http.get(
      Uri.parse('$baseUrl/rates/week'),
      headers: _getHeaders(),
    );

    return RateListResponse.fromJson(_handleResponse(response));
  }

  /// Obtener tasas del mes actual (Exchange Rates) - No requiere auth
  Future<RateListResponse> getMonthRates() async {
    final response = await http.get(
      Uri.parse('$baseUrl/rates/month'),
      headers: _getHeaders(),
    );

    return RateListResponse.fromJson(_handleResponse(response));
  }

  /// Obtener tasas de los últimos 3 meses (Exchange Rates) - No requiere auth
  Future<RateListResponse> getThreeMonthRates() async {
    final response = await http.get(
      Uri.parse('$baseUrl/rates/3months'),
      headers: _getHeaders(),
    );

    return RateListResponse.fromJson(_handleResponse(response));
  }

  /// Obtener tasas de los últimos 6 meses (Exchange Rates) - No requiere auth
  Future<RateListResponse> getSixMonthRates() async {
    final response = await http.get(
      Uri.parse('$baseUrl/rates/6months'),
      headers: _getHeaders(),
    );

    return RateListResponse.fromJson(_handleResponse(response));
  }

  /// Obtener tasas del último año (Exchange Rates) - No requiere auth
  Future<RateListResponse> getYearRates() async {
    final response = await http.get(
      Uri.parse('$baseUrl/rates/year'),
      headers: _getHeaders(),
    );

    return RateListResponse.fromJson(_handleResponse(response));
  }

  /// Obtener tasas en un rango de tiempo (Exchange Rates) - No requiere auth
  Future<RateListResponse> getRatesInRange(DateTime start, DateTime end) async {
    // Creamos la URI de forma estructurada
    final uri = Uri.parse('$baseUrl/rates/custom').replace(
      queryParameters: {
        'start_date': start.toIso8601String(),
        'end_date': end.toIso8601String(),
      },
    );

    final response = await http.get(uri, headers: _getHeaders());
    return RateListResponse.fromJson(_handleResponse(response));
  }

  /// Obtener una tasa por su ID (Exchange Rates) - No requiere auth
  Future<RateResponse> getRateById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/rates/$id'),
      headers: _getHeaders(),
    );

    return RateResponse.fromJson(_handleResponse(response));
  }

  /// Manejador de respuestas centralizado
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      // Aquí podrías mapear errores específicos de FastAPI (422, 401, etc.)
      throw HttpException('Error ${response.statusCode}: ${response.body}');
    }
  }
}
