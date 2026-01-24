import 'package:flutter/material.dart';
import 'package:client_app/utils/url_helper.dart';

class WhatsappButton extends StatelessWidget {
  final String phoneNumber;

  const WhatsappButton({
    super.key,
    this.phoneNumber = "559281324318", // Número por defecto
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton.icon(
        onPressed: () => UrlHelper.launchWhatsApp(
          phone: phoneNumber,
          message: "Hola WestCambios, quiero realizar una remesa.",
        ),
        icon: const Icon(Icons.chat_rounded, color: Colors.white),
        label: const Text("Envía tu remesa"),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF25D366),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
