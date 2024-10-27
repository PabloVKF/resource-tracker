import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:resource_tracker/modules/resource_tracker/models/registry.dart';

class Registrychart extends StatelessWidget {
  final List<Registry> registries;

  const Registrychart({
    super.key,
    required this.registries,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final registriesName = registries.isEmpty ? null : registries.first.name;

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(
            enabled: false,
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (groupData) {
                return registries[groupData.x].isAnomaly
                    ? colorScheme.error
                    : colorScheme.secondary;
              },
              getTooltipItem: (
                BarChartGroupData group,
                int groupIndex,
                BarChartRodData rod,
                int rodIndex,
              ) {
                return BarTooltipItem(
                  rod.toY.round().toString(),
                  TextStyle(
                    color: registries[groupIndex].isAnomaly
                        ? colorScheme.onError
                        : colorScheme.onSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          barGroups: registries
              .asMap()
              .entries
              .map(
                (entry) => BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value.value.toDouble(),
                      color: entry.value.isAnomaly
                          ? colorScheme.error
                          : colorScheme.secondary,
                      width: 16,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(4),
                      ),
                    ),
                  ],
                  showingTooltipIndicators: [0],
                ),
              )
              .toList(),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: Text(
                registriesName == null ?
                "Ultimos registros" :
                "Ultimos registros de $registriesName",
              ),
              axisNameSize: 20,
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  final registry = registries[value.toInt()];
                  final stringData =
                      '${registry.date.day}/${registry.date.month}/${registry.date.year}';
                  return Text(
                    stringData,
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(
              axisNameWidget: Text("Valor em m³"),
              axisNameSize: 20,
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
          ),
        ),
        swapAnimationCurve: Curves.easeOut,
        swapAnimationDuration: const Duration(milliseconds: 800),
      ),
    );
  }
}
