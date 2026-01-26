/// Coin model for cryptocurrency data from CoinGecko API
class CoinModel {
  final String id;
  final String symbol;
  final String name;
  final String? image;
  final double? currentPrice;
  final double? marketCap;
  final int? marketCapRank;
  final double? fullyDilutedValuation;
  final double? totalVolume;
  final double? high24h;
  final double? low24h;
  final double? priceChange24h;
  final double? priceChangePercentage24h;
  final double? marketCapChange24h;
  final double? marketCapChangePercentage24h;
  final double? circulatingSupply;
  final double? totalSupply;
  final double? maxSupply;
  final double? ath;
  final double? athChangePercentage;
  final DateTime? athDate;
  final double? atl;
  final double? atlChangePercentage;
  final DateTime? atlDate;
  final List<double>? sparklineIn7d;
  final DateTime? lastUpdated;

  CoinModel({
    required this.id,
    required this.symbol,
    required this.name,
    this.image,
    this.currentPrice,
    this.marketCap,
    this.marketCapRank,
    this.fullyDilutedValuation,
    this.totalVolume,
    this.high24h,
    this.low24h,
    this.priceChange24h,
    this.priceChangePercentage24h,
    this.marketCapChange24h,
    this.marketCapChangePercentage24h,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    this.ath,
    this.athChangePercentage,
    this.athDate,
    this.atl,
    this.atlChangePercentage,
    this.atlDate,
    this.sparklineIn7d,
    this.lastUpdated,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      image: json['image'] as String?,
      currentPrice: _parseDouble(json['current_price']),
      marketCap: _parseDouble(json['market_cap']),
      marketCapRank: json['market_cap_rank'] as int?,
      fullyDilutedValuation: _parseDouble(json['fully_diluted_valuation']),
      totalVolume: _parseDouble(json['total_volume']),
      high24h: _parseDouble(json['high_24h']),
      low24h: _parseDouble(json['low_24h']),
      priceChange24h: _parseDouble(json['price_change_24h']),
      priceChangePercentage24h: _parseDouble(json['price_change_percentage_24h']),
      marketCapChange24h: _parseDouble(json['market_cap_change_24h']),
      marketCapChangePercentage24h: _parseDouble(json['market_cap_change_percentage_24h']),
      circulatingSupply: _parseDouble(json['circulating_supply']),
      totalSupply: _parseDouble(json['total_supply']),
      maxSupply: _parseDouble(json['max_supply']),
      ath: _parseDouble(json['ath']),
      athChangePercentage: _parseDouble(json['ath_change_percentage']),
      athDate: json['ath_date'] != null ? DateTime.tryParse(json['ath_date']) : null,
      atl: _parseDouble(json['atl']),
      atlChangePercentage: _parseDouble(json['atl_change_percentage']),
      atlDate: json['atl_date'] != null ? DateTime.tryParse(json['atl_date']) : null,
      sparklineIn7d: _parseSparkline(json['sparkline_in_7d']),
      lastUpdated: json['last_updated'] != null ? DateTime.tryParse(json['last_updated']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'image': image,
      'current_price': currentPrice,
      'market_cap': marketCap,
      'market_cap_rank': marketCapRank,
      'fully_diluted_valuation': fullyDilutedValuation,
      'total_volume': totalVolume,
      'high_24h': high24h,
      'low_24h': low24h,
      'price_change_24h': priceChange24h,
      'price_change_percentage_24h': priceChangePercentage24h,
      'market_cap_change_24h': marketCapChange24h,
      'market_cap_change_percentage_24h': marketCapChangePercentage24h,
      'circulating_supply': circulatingSupply,
      'total_supply': totalSupply,
      'max_supply': maxSupply,
      'ath': ath,
      'ath_change_percentage': athChangePercentage,
      'ath_date': athDate?.toIso8601String(),
      'atl': atl,
      'atl_change_percentage': atlChangePercentage,
      'atl_date': atlDate?.toIso8601String(),
      'sparkline_in_7d': sparklineIn7d,
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static List<double>? _parseSparkline(dynamic json) {
    if (json == null) return null;
    if (json is Map && json['price'] != null) {
      final prices = json['price'] as List;
      return prices.map((e) => _parseDouble(e) ?? 0.0).toList();
    }
    if (json is List) {
      return json.map((e) => _parseDouble(e) ?? 0.0).toList();
    }
    return null;
  }

  bool get isPriceUp => (priceChangePercentage24h ?? 0) >= 0;

  CoinModel copyWith({
    String? id,
    String? symbol,
    String? name,
    String? image,
    double? currentPrice,
    double? marketCap,
    int? marketCapRank,
    double? fullyDilutedValuation,
    double? totalVolume,
    double? high24h,
    double? low24h,
    double? priceChange24h,
    double? priceChangePercentage24h,
    double? marketCapChange24h,
    double? marketCapChangePercentage24h,
    double? circulatingSupply,
    double? totalSupply,
    double? maxSupply,
    double? ath,
    double? athChangePercentage,
    DateTime? athDate,
    double? atl,
    double? atlChangePercentage,
    DateTime? atlDate,
    List<double>? sparklineIn7d,
    DateTime? lastUpdated,
  }) {
    return CoinModel(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      image: image ?? this.image,
      currentPrice: currentPrice ?? this.currentPrice,
      marketCap: marketCap ?? this.marketCap,
      marketCapRank: marketCapRank ?? this.marketCapRank,
      fullyDilutedValuation: fullyDilutedValuation ?? this.fullyDilutedValuation,
      totalVolume: totalVolume ?? this.totalVolume,
      high24h: high24h ?? this.high24h,
      low24h: low24h ?? this.low24h,
      priceChange24h: priceChange24h ?? this.priceChange24h,
      priceChangePercentage24h: priceChangePercentage24h ?? this.priceChangePercentage24h,
      marketCapChange24h: marketCapChange24h ?? this.marketCapChange24h,
      marketCapChangePercentage24h: marketCapChangePercentage24h ?? this.marketCapChangePercentage24h,
      circulatingSupply: circulatingSupply ?? this.circulatingSupply,
      totalSupply: totalSupply ?? this.totalSupply,
      maxSupply: maxSupply ?? this.maxSupply,
      ath: ath ?? this.ath,
      athChangePercentage: athChangePercentage ?? this.athChangePercentage,
      athDate: athDate ?? this.athDate,
      atl: atl ?? this.atl,
      atlChangePercentage: atlChangePercentage ?? this.atlChangePercentage,
      atlDate: atlDate ?? this.atlDate,
      sparklineIn7d: sparklineIn7d ?? this.sparklineIn7d,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoinModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
