import 'package:flutter/material.dart';
import 'package:client_app/models/enums.dart';
import 'package:client_app/ui/themes/west_themes.dart';

class CurrencySelector extends StatelessWidget {
  final Currency selected;
  final Function(Currency) onSelected;

  const CurrencySelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Currency>(
      segments: const [
        ButtonSegment(
          value: Currency.BRL,
          label: Text("BRL/VES"),
          icon: Icon(Icons.currency_exchange),
        ),
        ButtonSegment(
          value: Currency.USD,
          label: Text("USD/VES"),
          icon: Icon(Icons.attach_money),
        ),
      ],
      selected: {selected},
      onSelectionChanged: (Set<Currency> newSelection) {
        onSelected(newSelection.first);
      },
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: WestColors.orangePrimary,
        selectedForegroundColor: Colors.white,
        //showSelectedIcon: false,
      ),
    );
  }
}
