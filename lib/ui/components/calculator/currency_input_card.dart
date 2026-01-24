// lib/ui/components/calculator/currency_input_card.dart
import 'package:flutter/material.dart';
import '../../themes/west_themes.dart';

class CurrencyInputCard extends StatelessWidget {
  final String label; // "Reales Brasileños", "Bolívares Digitales", etc.
  final String currencyCode; // "R$", "Bs", "$"
  final Color badgeColor;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onChanged;

  const CurrencyInputCard({
    super.key,
    required this.label,
    required this.currencyCode,
    required this.badgeColor,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: WestColors.grayDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  currencyCode,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.zero,
              hintText: "0.00",
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
            onTap: () {
              // Al tocar el campo, seleccionamos todo el texto para facilitar la edición
              controller.selection = TextSelection(
                baseOffset: 0,
                extentOffset: controller.text.length,
              );
            },
            onChanged: (_) => onChanged(),
          ),
        ],
      ),
    );
  }
}
