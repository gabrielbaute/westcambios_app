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
        child: Center(
          child: Text(
            "No pudimos conectarnos a nuestro servidor, por favor intenta más tarde!",
          ),
        ),
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
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                // 1. Color de fondo del recuadro
                getTooltipColor: (touchedSpot) =>
                    WestColors.whiteBone.withValues(alpha: 0.4),
                tooltipBorderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
                getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                  return touchedBarSpots.map((barSpot) {
                    return LineTooltipItem(
                      // 2. Personalización del texto (Capa de ingeniería: Formateo de moneda)
                      'Bs ${barSpot.y.toStringAsFixed(2)}',
                      const TextStyle(
                        color: WestColors
                            .orangePrimary, // Texto en naranja de la marca
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: rates.asMap().entries.map((e) {
                  return FlSpot(e.key.toDouble().roundToDouble(), e.value.rate);
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
                      WestColors.orangePrimary.withValues(alpha: 0.4),
                      WestColors.orangePrimary.withValues(alpha: 0.0),
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
