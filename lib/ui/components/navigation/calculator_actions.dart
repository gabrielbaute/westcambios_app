import 'package:flutter/material.dart';
import 'package:client_app/ui/themes/west_themes.dart';

class CalculatorActions extends StatelessWidget {
  final VoidCallback onCopyText;
  final VoidCallback onShareScreenshot;

  const CalculatorActions({
    super.key,
    required this.onCopyText,
    required this.onShareScreenshot,
  });

  @override
  Widget build(BuildContext context) {
    // Definimos un estilo común para ambos botones para asegurar simetría
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors
          .transparent, // Lo manejaremos con el contenedor padre o el style
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 16),
      minimumSize: const Size(0, 55), // Altura fija para que sean iguales
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Row(
        children: [
          // Botón de Copiar
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onCopyText,
              icon: const Icon(Icons.copy_all_rounded, size: 20),
              label: const Text("Copiar"),
              style: buttonStyle.copyWith(
                backgroundColor: WidgetStateProperty.all(WestColors.grayDark),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Botón de Compartir
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onShareScreenshot,
              icon: const Icon(Icons.share_rounded, size: 20),
              label: const Text("Captura"),
              style: buttonStyle.copyWith(
                backgroundColor: WidgetStateProperty.all(
                  WestColors.orangePrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
