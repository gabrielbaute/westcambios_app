// lib/ui/components/calculator/rate_card_item.dart
import 'package:flutter/material.dart';
import '../../themes/west_themes.dart';

class RateCardItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const RateCardItem({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      // Bajamos el padding para ganar espacio interno
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [WestColors.orangePrimary, WestColors.orangeSoft],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12), // Un poco menos de radio
        boxShadow: [
          BoxShadow(
            color: WestColors.orangePrimary.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Quitamos MainAxisAlignment.center para evitar empujes innecesarios
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 18,
          ), // Icono ligeramente más pequeño
          const SizedBox(height: 4), // Menos espacio
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15, // Un punto menos para asegurar cabida
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
