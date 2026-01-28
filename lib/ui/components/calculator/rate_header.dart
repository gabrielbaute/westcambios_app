// lib/ui/components/calculator/rate_header.dart
import 'package:flutter/material.dart';
import 'rate_card_item.dart';

class RateHeader extends StatelessWidget {
  final double brlRate;
  final double usdRate;
  final double usdtRate;
  final double usdtBrlRate;

  const RateHeader({
    super.key,
    required this.brlRate,
    required this.usdRate,
    required this.usdtRate,
    required this.usdtBrlRate,
  });

  @override
  Widget build(BuildContext context) {
    // Usamos un SizedBox para darle una altura finita al scroll horizontal
    return SizedBox(
      height: 100, // Ajusta esta altura según el diseño de tu RateCardItem
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          RateCardItem(
            label: "Tasa del día",
            value: "R\$ ${brlRate.toStringAsFixed(2)}",
            icon: Icons.trending_up,
          ),
          const SizedBox(width: 12),
          RateCardItem(
            label: "Dólar BCV",
            value: "\$ ${usdRate.toStringAsFixed(2)}",
            icon: Icons.attach_money,
          ),
          const SizedBox(width: 12),
          RateCardItem(
            label: "USDT/VES (P2P)",
            value: "\$ ${usdtRate.toStringAsFixed(2)}",
            icon: Icons.currency_bitcoin,
          ),
          const SizedBox(width: 12),
          RateCardItem(
            label: "USDT/BRL (P2P)",
            value: "R\$ ${usdtBrlRate.toStringAsFixed(2)}",
            icon: Icons.currency_exchange,
          ),
        ],
      ),
    );
  }
}
