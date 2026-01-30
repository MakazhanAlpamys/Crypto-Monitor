import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/chart_data_model.dart';

/// Interactive price chart widget
class PriceChart extends StatefulWidget {
  final ChartDataModel chartData;
  final ChartTimeRange timeRange;
  final Function(ChartTimeRange)? onTimeRangeChanged;

  const PriceChart({
    super.key,
    required this.chartData,
    required this.timeRange,
    this.onTimeRangeChanged,
  });

  @override
  State<PriceChart> createState() => _PriceChartState();
}

class _PriceChartState extends State<PriceChart> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    final isPositive = widget.chartData.priceChangePercentage >= 0;
    final color = isPositive ? AppColors.chartGreen : AppColors.chartRed;

    return Column(
      children: [
        // Time range selector
        _buildTimeRangeSelector(),
        const SizedBox(height: 16),
        // Chart
        SizedBox(
          height: 220,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: LineChart(
              _buildChartData(color),
              duration: const Duration(milliseconds: 300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeRangeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ChartTimeRange.values.map((range) {
          final isSelected = range == widget.timeRange;
          return GestureDetector(
            onTap: () => widget.onTimeRangeChanged?.call(range),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                range.label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textTertiary,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  LineChartData _buildChartData(Color color) {
    final prices = widget.chartData.prices;
    if (prices.isEmpty) {
      return LineChartData(lineBarsData: []);
    }

    final spots = prices.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();

    final minY = widget.chartData.minPrice;
    final maxY = widget.chartData.maxPrice;
    final padding = (maxY - minY) * 0.1;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: (maxY - minY) / 4,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.glassBorder,
            strokeWidth: 0.5,
            dashArray: [5, 5],
          );
        },
      ),
      titlesData: FlTitlesData(
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 60,
            getTitlesWidget: (value, meta) {
              return Text(
                Formatters.formatPrice(value),
                style: const TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 10,
                ),
              );
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: prices.length / 4,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= prices.length) return const SizedBox();
              
              final date = prices[index].timestamp;
              String text;
              
              switch (widget.timeRange) {
                case ChartTimeRange.day1:
                  text = DateFormat('HH:mm').format(date);
                  break;
                case ChartTimeRange.week1:
                case ChartTimeRange.month1:
                  text = DateFormat('MMM d').format(date);
                  break;
                default:
                  text = DateFormat('MMM yyyy').format(date);
              }

              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 10,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minY: minY - padding,
      maxY: maxY + padding,
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => AppColors.surfaceLight,
          tooltipRoundedRadius: 12,
          tooltipPadding: const EdgeInsets.all(12),
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final index = spot.x.toInt();
              if (index >= prices.length) return null;
              
              final price = prices[index];
              return LineTooltipItem(
                '${Formatters.formatPrice(price.value)}\n${DateFormat('MMM d, HH:mm').format(price.timestamp)}',
                const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
        touchCallback: (event, response) {
          if (event is FlTapUpEvent || event is FlPanEndEvent) {
            setState(() => _touchedIndex = null);
          } else if (response?.lineBarSpots != null) {
            setState(() => _touchedIndex = response!.lineBarSpots!.first.x.toInt());
          }
        },
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.2,
          color: color,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            checkToShowDot: (spot, barData) {
              return _touchedIndex != null && spot.x.toInt() == _touchedIndex;
            },
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 6,
                color: color,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
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
    );
  }
}
