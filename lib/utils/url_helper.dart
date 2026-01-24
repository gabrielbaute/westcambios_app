import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  /// Lanza una URL de forma segura
  static Future<void> launchExternalUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'No se pudo lanzar la URL: $url';
    }
  }

  /// Genera y lanza el link de WhatsApp con un mensaje predefinido
  static Future<void> launchWhatsApp({
    required String phone,
    String message = "",
  }) async {
    // Formato internacional wa.me/numero?text=mensaje
    final String encodedMsg = Uri.encodeComponent(message);
    final String url = "https://wa.me/$phone?text=$encodedMsg";
    await launchExternalUrl(url);
  }
}
