// lib/ui/components/calculator/rate_header.dart
import 'package:flutter/material.dart';
import 'rate_card_item.dart';

class RateHeader extends StatelessWidget {
  final double brlRate;
  final double usdRate;

  const RateHeader({super.key, required this.brlRate, required this.usdRate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          RateCardItem(
            label: "Tasa del día",
            value: "R\$ ${brlRate.toStringAsFixed(2)}",
            icon: Icons.trending_up,
          ),
          const SizedBox(width: 12),
          RateCardItem(
            label: "Valor Dólar",
            value: "\$ ${usdRate.toStringAsFixed(2)}",
            icon: Icons.attach_money,
          ),
        ],
      ),
    );
  }
}
