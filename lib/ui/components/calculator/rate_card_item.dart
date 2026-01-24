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
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: WestColors.whitePure,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: WestColors.orangeSoft, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: WestColors.orangePrimary.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: WestColors.orangePrimary),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: WestColors.grayDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: WestColors.orangePrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
