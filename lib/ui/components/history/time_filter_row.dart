import 'package:flutter/material.dart';
import 'package:client_app/ui/themes/west_themes.dart';

class TimeFilterRow extends StatelessWidget {
  final String currentFilter;
  final Function(String) onFilterChanged;

  const TimeFilterRow({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Definimos los filtros disponibles
    final filters = {
      '7d': '7 Días',
      '1m': '1 Mes',
      '3m': '3 Meses',
      '6m': '6 Meses',
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.entries.map((e) {
          final bool isActive = currentFilter == e.key;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(e.value),
              selected: isActive,
              onSelected: (_) => onFilterChanged(e.key),
              selectedColor: WestColors.orangePrimary,
              labelStyle: TextStyle(
                color: isActive ? Colors.white : WestColors.grayDark,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
