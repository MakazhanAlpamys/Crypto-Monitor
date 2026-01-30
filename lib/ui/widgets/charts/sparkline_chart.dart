import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';

/// Mini sparkline chart for coin cards
class SparklineChart extends StatelessWidget {
  final List<double> data;
  final bool isPositive;
  final double strokeWidth;

  const SparklineChart({
    super.key,
    required this.data,
    this.isPositive = true,
    this.strokeWidth = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox();

    final color = isPositive ? AppColors.chartGreen : AppColors.chartRed;
    final spots = _createSpots();
    final minY = data.reduce((a, b) => a < b ? a : b);
    final maxY = data.reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY) * 0.1;

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        minY: minY - padding,
        maxY: maxY + padding,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.3,
            color: color,
            barWidth: strokeWidth,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.3),
                  color.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _createSpots() {
    // Sample data to reduce points for better performance
    final sampledData = _sampleData(data, 20);
    return sampledData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();
  }

  List<double> _sampleData(List<double> data, int maxPoints) {
    if (data.length <= maxPoints) return data;
    
    final step = data.length / maxPoints;
    final result = <double>[];
    
    for (var i = 0; i < maxPoints; i++) {
      final index = (i * step).floor();
      result.add(data[index]);
    }
    
    // Always include the last point
    result[result.length - 1] = data.last;
    
    return result;
  }
}
