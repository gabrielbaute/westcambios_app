import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ShareHelper {
  /// Copia el texto formateado al portapapeles
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  /// Captura un widget y lo comparte como imagen usando la nueva API
  static Future<void> shareScreenshot(ScreenshotController controller) async {
    final image = await controller.capture();
    if (image == null) return;

    final directory = await getTemporaryDirectory();
    final String fileName =
        'cotizacion_west_${DateTime.now().millisecondsSinceEpoch}.png';
    final imageFile = File('${directory.path}/$fileName');

    await imageFile.writeAsBytes(image);

    // Resolución del Deprecated: Usamos Share.shareXFiles pero asegurando
    // que la versión de la librería sea compatible o usando la nueva sintaxis
    // si tu versión es la más reciente (8.0+).
    await Share.shareXFiles([
      XFile(imageFile.path),
    ], text: 'Cotización enviada desde WestCambios App');
  }
}
