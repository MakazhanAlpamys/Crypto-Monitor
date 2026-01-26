/// Model for price chart data
class ChartDataModel {
  final List<PricePoint> prices;
  final List<PricePoint>? marketCaps;
  final List<PricePoint>? totalVolumes;

  ChartDataModel({
    required this.prices,
    this.marketCaps,
    this.totalVolumes,
  });

  factory ChartDataModel.fromJson(Map<String, dynamic> json) {
    return ChartDataModel(
      prices: _parsePricePoints(json['prices']),
      marketCaps: json['market_caps'] != null
          ? _parsePricePoints(json['market_caps'])
          : null,
      totalVolumes: json['total_volumes'] != null
          ? _parsePricePoints(json['total_volumes'])
          : null,
    );
  }

  static List<PricePoint> _parsePricePoints(List<dynamic>? data) {
    if (data == null) return [];
    return data.map((point) {
      final timestamp = point[0] as num;
      final price = point[1] as num?;
      return PricePoint(
        timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp.toInt()),
        value: price?.toDouble() ?? 0.0,
      );
    }).toList();
  }

  double get minPrice {
    if (prices.isEmpty) return 0;
    return prices.map((p) => p.value).reduce((a, b) => a < b ? a : b);
  }

  double get maxPrice {
    if (prices.isEmpty) return 0;
    return prices.map((p) => p.value).reduce((a, b) => a > b ? a : b);
  }

  double get priceChange {
    if (prices.length < 2) return 0;
    return prices.last.value - prices.first.value;
  }

  double get priceChangePercentage {
    if (prices.length < 2 || prices.first.value == 0) return 0;
    return ((prices.last.value - prices.first.value) / prices.first.value) * 100;
  }
}

class PricePoint {
  final DateTime timestamp;
  final double value;

  PricePoint({
    required this.timestamp,
    required this.value,
  });
}

/// Time range options for chart
enum ChartTimeRange {
  day1('1D', 1),
  week1('1W', 7),
  month1('1M', 30),
  month3('3M', 90),
  year1('1Y', 365),
  all('All', 0);

  const ChartTimeRange(this.label, this.days);
  final String label;
  final int days;
}
