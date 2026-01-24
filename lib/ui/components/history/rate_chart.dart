import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:client_app/ui/themes/west_themes.dart';
import 'package:client_app/models/rate_model.dart';

class RateChart extends StatelessWidget {
  final List<RateResponse> rates;

  const RateChart({super.key, required this.rates});

  @override
  Widget build(BuildContext context) {
    if (rates.isEmpty)
      return const SizedBox(
        height: 200,
        child: Center(child: Text("Sin datos")),
      );

    return AspectRatio(
      aspectRatio: 1.7,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 24,
          bottom: 12,
        ),
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(
              show: false,
            ), // Por ahora simple, luego añadimos ejes
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: rates.asMap().entries.map((e) {
                  return FlSpot(e.key.toDouble(), e.value.rate);
                }).toList(),
                isCurved: true,
                gradient: const LinearGradient(
                  colors: [WestColors.orangePrimary, WestColors.orangeLight],
                ),
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    colors: [
                      WestColors.orangePrimary.withOpacity(0.3),
                      WestColors.orangePrimary.withOpacity(0.0),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
