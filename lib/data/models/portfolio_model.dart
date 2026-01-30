/// Portfolio asset model for tracking user's crypto holdings
class PortfolioAsset {
  final String coinId;
  final String symbol;
  final String name;
  final String? image;
  final double amount;
  final double avgBuyPrice;
  final DateTime purchaseDate;
  final double? currentPrice;
  final double? priceChangePercentage24h;

  PortfolioAsset({
    required this.coinId,
    required this.symbol,
    required this.name,
    this.image,
    required this.amount,
    required this.avgBuyPrice,
    required this.purchaseDate,
    this.currentPrice,
    this.priceChangePercentage24h,
  });

  /// Current value of this asset
  double get currentValue => amount * (currentPrice ?? avgBuyPrice);

  /// Total invested in this asset
  double get totalInvested => amount * avgBuyPrice;

  /// Profit/Loss amount
  double get profitLoss => currentValue - totalInvested;

  /// Profit/Loss percentage
  double get profitLossPercentage {
    if (totalInvested == 0) return 0;
    return (profitLoss / totalInvested) * 100;
  }

  /// Is this asset in profit
  bool get isProfit => profitLoss >= 0;

  factory PortfolioAsset.fromJson(Map<String, dynamic> json) {
    return PortfolioAsset(
      coinId: json['coin_id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      image: json['image'] as String?,
      amount: (json['amount'] as num).toDouble(),
      avgBuyPrice: (json['avg_buy_price'] as num).toDouble(),
      purchaseDate: DateTime.parse(json['purchase_date'] as String),
      currentPrice: json['current_price'] != null 
          ? (json['current_price'] as num).toDouble() 
          : null,
      priceChangePercentage24h: json['price_change_percentage_24h'] != null 
          ? (json['price_change_percentage_24h'] as num).toDouble() 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coin_id': coinId,
      'symbol': symbol,
      'name': name,
      'image': image,
      'amount': amount,
      'avg_buy_price': avgBuyPrice,
      'purchase_date': purchaseDate.toIso8601String(),
      'current_price': currentPrice,
      'price_change_percentage_24h': priceChangePercentage24h,
    };
  }

  PortfolioAsset copyWith({
    String? coinId,
    String? symbol,
    String? name,
    String? image,
    double? amount,
    double? avgBuyPrice,
    DateTime? purchaseDate,
    double? currentPrice,
    double? priceChangePercentage24h,
  }) {
    return PortfolioAsset(
      coinId: coinId ?? this.coinId,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      image: image ?? this.image,
      amount: amount ?? this.amount,
      avgBuyPrice: avgBuyPrice ?? this.avgBuyPrice,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      currentPrice: currentPrice ?? this.currentPrice,
      priceChangePercentage24h: priceChangePercentage24h ?? this.priceChangePercentage24h,
    );
  }
}

/// Transaction model for buy/sell history
class PortfolioTransaction {
  final String id;
  final String coinId;
  final String symbol;
  final String name;
  final TransactionType type;
  final double amount;
  final double price;
  final DateTime timestamp;
  final double? fee;

  PortfolioTransaction({
    required this.id,
    required this.coinId,
    required this.symbol,
    required this.name,
    required this.type,
    required this.amount,
    required this.price,
    required this.timestamp,
    this.fee,
  });

  double get totalValue => amount * price + (fee ?? 0);

  factory PortfolioTransaction.fromJson(Map<String, dynamic> json) {
    return PortfolioTransaction(
      id: json['id'] as String,
      coinId: json['coin_id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.buy,
      ),
      amount: (json['amount'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      fee: json['fee'] != null ? (json['fee'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coin_id': coinId,
      'symbol': symbol,
      'name': name,
      'type': type.name,
      'amount': amount,
      'price': price,
      'timestamp': timestamp.toIso8601String(),
      'fee': fee,
    };
  }
}

enum TransactionType { buy, sell }

/// Portfolio summary model
class PortfolioSummary {
  final double totalValue;
  final double totalInvested;
  final double totalProfitLoss;
  final double profitLossPercentage;
  final double change24h;
  final double changePercentage24h;
  final List<PortfolioAsset> assets;

  PortfolioSummary({
    required this.totalValue,
    required this.totalInvested,
    required this.totalProfitLoss,
    required this.profitLossPercentage,
    required this.change24h,
    required this.changePercentage24h,
    required this.assets,
  });

  bool get isProfit => totalProfitLoss >= 0;
  bool get is24hUp => change24h >= 0;
}
