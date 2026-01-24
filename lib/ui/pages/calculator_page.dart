// lib/ui/pages/calculator_page.dart
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'package:client_app/models/enums.dart';
import 'package:client_app/services/calc_service.dart';
import 'package:client_app/ui/themes/west_themes.dart';
import 'package:client_app/ui/components/calculator/rate_header.dart';
import 'package:client_app/ui/components/navigation/calculator_actions.dart';
import 'package:client_app/ui/components/calculator/currency_input_card.dart';

class CalculatorPage extends StatefulWidget {
  final CalcService calcService;
  const CalculatorPage({super.key, required this.calcService});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  // 1. Definimos los controladores y focus (ya los tenías)
  final ScreenshotController _screenshotController = ScreenshotController();
  final TextEditingController _brlController = TextEditingController();
  final TextEditingController _vesController = TextEditingController();
  final TextEditingController _usdController = TextEditingController();
  final FocusNode _brlFocus = FocusNode();
  final FocusNode _vesFocus = FocusNode();
  final FocusNode _usdFocus = FocusNode();

  // 2. ESTADO DE CARGA: Para saber si estamos trayendo datos de la API
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // 3. LLAMADA INICIAL: Apenas se cree esta vista, traemos las tasas
    _fetchRates();
  }

  Future<void> _fetchRates() async {
    try {
      // Llamamos al método que actualizamos en el servicio
      await widget.calcService.refreshRate();
    } catch (e) {
      // Aquí podrías mostrar un SnackBar de error
      debugPrint("Error cargando tasas: $e");
    } finally {
      // 4. ACTUALIZAR UI: Quitamos el cargando y redibujamos
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onCalculate() {
    // 1. Identificamos el origen y el monto
    double amount = 0;
    Currency fromCurrency = Currency.BRL;

    if (_brlFocus.hasFocus) {
      amount = double.tryParse(_brlController.text) ?? 0;
      fromCurrency = Currency.BRL;
    } else if (_vesFocus.hasFocus) {
      amount = double.tryParse(_vesController.text) ?? 0;
      fromCurrency = Currency.VES;
    } else if (_usdFocus.hasFocus) {
      amount = double.tryParse(_usdController.text) ?? 0;
      fromCurrency = Currency.USD;
    }

    // 2. Llamamos al motor de conversión que acabas de crear
    final results = widget.calcService.performTripleConversion(
      amount: amount,
      fromCurrency: fromCurrency,
    );

    // 3. Actualizamos la UI solo si el campo no tiene el foco (para no interrumpir al usuario)
    setState(() {
      if (!_brlFocus.hasFocus) {
        _brlController.text = results['BRL']! > 0
            ? results['BRL']!.toStringAsFixed(2)
            : "";
      }
      if (!_vesFocus.hasFocus) {
        _vesController.text = results['VES']! > 0
            ? results['VES']!.toStringAsFixed(2)
            : "";
      }
      if (!_usdFocus.hasFocus) {
        _usdController.text = results['USD']! > 0
            ? results['USD']!.toStringAsFixed(2)
            : "";
      }
    });
  }

  // Función para copiar texto (Estilo formal/claro)
  void _copyToClipboard() {
    final text =
        """
💰 *WestCambios - Cotización*
----------------------------
Envías: ${_brlController.text} R\$
Recibes: ${_vesController.text} Bs
Ref: ${_usdController.text} \$
----------------------------
Tasa: ${widget.calcService.brlToVesRate}
""";
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cotización copiada al portapapeles")),
    );
  }

  // Función para capturar y compartir imagen
  Future<void> _shareScreenshot() async {
    // Capturamos el widget
    final image = await _screenshotController.capture();
    if (image == null) return;

    // Guardamos temporalmente
    final directory = await getTemporaryDirectory();
    final imagePath = await File('${directory.path}/cotizacion.png').create();
    await imagePath.writeAsBytes(image);

    // Compartimos el archivo
    await Share.shareXFiles([
      XFile(imagePath.path),
    ], text: 'Mi cotización en WestCambios');
  }

  @override
  Widget build(BuildContext context) {
    // 5. VISTA DE CARGA: Si aún no hay datos, mostramos un spinner
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: Screenshot(
        controller: _screenshotController,
        child: Container(
          color: WestColors.whiteBone,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header con las tasas obtenidas del servicio
                RateHeader(
                  brlRate: widget.calcService.brlToVesRate,
                  usdRate: widget.calcService.usdToVesRate,
                ),

                const SizedBox(height: 10),

                // Input de Reales (Naranja)
                CurrencyInputCard(
                  label: "Envías Reales",
                  currencyCode: "R\$",
                  badgeColor: const Color(0xFFFF6B00),
                  controller: _brlController,
                  focusNode: _brlFocus,
                  onChanged: _onCalculate,
                ),

                // Input de Bolívares (Verde)
                CurrencyInputCard(
                  label: "Reciben Bolívares",
                  currencyCode: "Bs",
                  badgeColor: const Color(0xFF28A745),
                  controller: _vesController,
                  focusNode: _vesFocus,
                  onChanged: _onCalculate,
                ),

                // Input de Dólares (Azul - Referencia)
                CurrencyInputCard(
                  label: "Referencia en Dólares",
                  currencyCode: "\$",
                  badgeColor: const Color(0xFF007BFF),
                  controller: _usdController,
                  focusNode: _usdFocus,
                  onChanged: _onCalculate,
                ),
                // Agregamos las acciones al final
                CalculatorActions(
                  onCopyText: _copyToClipboard,
                  onShareScreenshot: _shareScreenshot,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
