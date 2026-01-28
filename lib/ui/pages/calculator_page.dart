// lib/ui/pages/calculator_page.dart
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';

import 'package:client_app/models/enums.dart';
import 'package:client_app/utils/share_helper.dart';
import 'package:client_app/services/calc_service.dart';
import 'package:client_app/ui/themes/west_themes.dart';
import 'package:client_app/ui/components/calculator/rate_header.dart';
import 'package:client_app/ui/components/navigation/calculator_actions.dart';
import 'package:client_app/ui/components/calculator/currency_input_card.dart';
import 'package:client_app/ui/components/calculator/whatsapp_button.dart';

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

  void _handleCopy() {
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

    ShareHelper.copyToClipboard(text).then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cotización copiada al portapapeles")),
        );
      }
    });
  }

  Future<void> _handleShare() async {
    await ShareHelper.shareScreenshot(_screenshotController);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: WestColors.whiteBone,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            // NIVEL 1: Llamado a la acción (WhatsApp)
            const WhatsappButton(),

            const SizedBox(height: 15),

            // NIVEL 2: Área de captura (Screenshot)
            // Solo envuelve lo que el cliente final debe ver en la foto
            Screenshot(
              controller: _screenshotController,
              child: Container(
                color:
                    WestColors.whiteBone, // Asegura fondo sólido en la captura
                child: Column(
                  children: [
                    RateHeader(
                      brlRate: widget.calcService.brlToVesRate,
                      usdRate: widget.calcService.usdToVesRate,
                      usdtRate: widget.calcService.usdtToVesRate,
                      usdtBrlRate: widget.calcService.usdtToBrlRate,
                    ),
                    const SizedBox(height: 10),
                    CurrencyInputCard(
                      label: "Envías Reales",
                      currencyCode: "R\$",
                      badgeColor: const Color(0xFFFF6B00),
                      controller: _brlController,
                      focusNode: _brlFocus,
                      onChanged: _onCalculate,
                    ),
                    CurrencyInputCard(
                      label: "Reciben Bolívares",
                      currencyCode: "Bs",
                      badgeColor: const Color(0xFF28A745),
                      controller: _vesController,
                      focusNode: _vesFocus,
                      onChanged: _onCalculate,
                    ),
                    CurrencyInputCard(
                      label: "Referencia en Dólares",
                      currencyCode: "\$",
                      badgeColor: const Color(0xFF007BFF),
                      controller: _usdController,
                      focusNode: _usdFocus,
                      onChanged: _onCalculate,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // NIVEL 3: Acciones de Utilidad (Fuera del screenshot)
            CalculatorActions(
              onCopyText: _handleCopy,
              onShareScreenshot: _handleShare,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
