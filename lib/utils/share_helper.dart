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

  /// Captura un widget y lo comparte como imagen
  static Future<void> shareScreenshot(ScreenshotController controller) async {
    final image = await controller.capture();
    if (image == null) return;

    final directory = await getTemporaryDirectory();
    final imagePath = await File(
      '${directory.path}/cotizacion_west.png',
    ).create();
    await imagePath.writeAsBytes(image);

    await Share.shareXFiles([
      XFile(imagePath.path),
    ], text: 'Cotización enviada desde WestCambios App');
  }
}
