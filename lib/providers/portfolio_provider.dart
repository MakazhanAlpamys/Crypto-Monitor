import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/portfolio_model.dart';
import '../data/models/coin_model.dart';
import 'providers.dart';

/// Portfolio state notifier for managing user's portfolio
class PortfolioNotifier extends StateNotifier<AsyncValue<List<PortfolioAsset>>> {
  final Ref _ref;
  
  // Demo portfolio data - In production, this would come from a database
  final List<PortfolioAsset> _demoAssets = [
    PortfolioAsset(
      coinId: 'bitcoin',
      symbol: 'BTC',
      name: 'Bitcoin',
      image: 'https://assets.coingecko.com/coins/images/1/large/bitcoin.png',
      amount: 0.5234,
      avgBuyPrice: 35000.00,
      purchaseDate: DateTime(2024, 6, 15),
    ),
    PortfolioAsset(
      coinId: 'ethereum',
      symbol: 'ETH',
      name: 'Ethereum',
      image: 'https://assets.coingecko.com/coins/images/279/large/ethereum.png',
      amount: 3.2145,
      avgBuyPrice: 2100.00,
      purchaseDate: DateTime(2024, 8, 22),
    ),
    PortfolioAsset(
      coinId: 'binancecoin',
      symbol: 'BNB',
      name: 'BNB',
      image: 'https://assets.coingecko.com/coins/images/825/large/bnb-icon2_2x.png',
      amount: 15.678,
      avgBuyPrice: 280.00,
      purchaseDate: DateTime(2024, 10, 5),
    ),
    PortfolioAsset(
      coinId: 'solana',
      symbol: 'SOL',
      name: 'Solana',
      image: 'https://assets.coingecko.com/coins/images/4128/large/solana.png',
      amount: 45.234,
      avgBuyPrice: 85.00,
      purchaseDate: DateTime(2024, 11, 12),
    ),
    PortfolioAsset(
      coinId: 'ripple',
      symbol: 'XRP',
      name: 'XRP',
      image: 'https://assets.coingecko.com/coins/images/44/large/xrp-symbol-white-128.png',
      amount: 1500.0,
      avgBuyPrice: 0.55,
      purchaseDate: DateTime(2024, 12, 1),
    ),
  ];

  PortfolioNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadPortfolio();
  }

  Future<void> _loadPortfolio() async {
    state = const AsyncValue.loading();
    try {
      // Update assets with current prices
      final updatedAssets = await _updateAssetPrices(_demoAssets);
      state = AsyncValue.data(updatedAssets);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<List<PortfolioAsset>> _updateAssetPrices(List<PortfolioAsset> assets) async {
    try {
      final coinIds = assets.map((a) => a.coinId).toList();
      final currency = _ref.read(selectedCurrencyProvider);
      
      final coins = await _ref.read(coinRepositoryProvider).getCoinsByIds(
        coinIds,
        currency: currency.code.toLowerCase(),
      );
      
      return assets.map((asset) {
        final coin = coins.firstWhere(
          (c) => c.id == asset.coinId,
          orElse: () => CoinModel(
            id: asset.coinId,
            symbol: asset.symbol,
            name: asset.name,
          ),
        );
        return asset.copyWith(
          currentPrice: coin.currentPrice ?? asset.avgBuyPrice,
          priceChangePercentage24h: coin.priceChangePercentage24h,
          image: coin.image ?? asset.image,
        );
      }).toList();
    } catch (e) {
      // Return original assets if API fails
      return assets;
    }
  }

  Future<void> refresh() async {
    await _loadPortfolio();
  }

  Future<void> addAsset({
    required String coinId,
    required String symbol,
    required String name,
    String? image,
    required double amount,
    required double price,
  }) async {
    final existingIndex = _demoAssets.indexWhere((a) => a.coinId == coinId);
    
    if (existingIndex != -1) {
      // Update existing asset
      final existing = _demoAssets[existingIndex];
      final newAmount = existing.amount + amount;
      final newAvgPrice = ((existing.amount * existing.avgBuyPrice) + (amount * price)) / newAmount;
      
      _demoAssets[existingIndex] = existing.copyWith(
        amount: newAmount,
        avgBuyPrice: newAvgPrice,
      );
    } else {
      // Add new asset
      _demoAssets.add(PortfolioAsset(
        coinId: coinId,
        symbol: symbol,
        name: name,
        image: image,
        amount: amount,
        avgBuyPrice: price,
        purchaseDate: DateTime.now(),
      ));
    }
    
    await _loadPortfolio();
  }

  Future<void> removeAsset(String coinId, double amount) async {
    final existingIndex = _demoAssets.indexWhere((a) => a.coinId == coinId);
    
    if (existingIndex != -1) {
      final existing = _demoAssets[existingIndex];
      final newAmount = existing.amount - amount;
      
      if (newAmount <= 0) {
        _demoAssets.removeAt(existingIndex);
      } else {
        _demoAssets[existingIndex] = existing.copyWith(amount: newAmount);
      }
      
      await _loadPortfolio();
    }
  }
}

/// Portfolio notifier provider
final portfolioNotifierProvider = 
    StateNotifierProvider<PortfolioNotifier, AsyncValue<List<PortfolioAsset>>>((ref) {
  return PortfolioNotifier(ref);
});

/// Portfolio summary provider
final portfolioSummaryProvider = Provider<AsyncValue<PortfolioSummary>>((ref) {
  final assetsAsync = ref.watch(portfolioNotifierProvider);
  
  return assetsAsync.whenData((assets) {
    if (assets.isEmpty) {
      return PortfolioSummary(
        totalValue: 0,
        totalInvested: 0,
        totalProfitLoss: 0,
        profitLossPercentage: 0,
        change24h: 0,
        changePercentage24h: 0,
        assets: [],
      );
    }
    
    double totalValue = 0;
    double totalInvested = 0;
    double previousDayValue = 0;
    
    for (final asset in assets) {
      totalValue += asset.currentValue;
      totalInvested += asset.totalInvested;
      
      // Calculate previous day value for 24h change
      final previousPrice = asset.currentPrice != null && asset.priceChangePercentage24h != null
          ? asset.currentPrice! / (1 + asset.priceChangePercentage24h! / 100)
          : asset.currentPrice ?? asset.avgBuyPrice;
      previousDayValue += asset.amount * previousPrice;
    }
    
    final totalProfitLoss = totalValue - totalInvested;
    final profitLossPercentage = totalInvested > 0 
        ? (totalProfitLoss / totalInvested) * 100 
        : 0.0;
    final change24h = totalValue - previousDayValue;
    final changePercentage24h = previousDayValue > 0 
        ? (change24h / previousDayValue) * 100 
        : 0.0;
    
    return PortfolioSummary(
      totalValue: totalValue,
      totalInvested: totalInvested,
      totalProfitLoss: totalProfitLoss,
      profitLossPercentage: profitLossPercentage,
      change24h: change24h,
      changePercentage24h: changePercentage24h,
      assets: assets,
    );
  });
});

/// Trending coins provider - Top gainers
final trendingCoinsProvider = Provider<AsyncValue<List<CoinModel>>>((ref) {
  final coinsAsync = ref.watch(coinsProvider);
  
  return coinsAsync.whenData((coins) {
    // Sort by 24h change and take top 10
    final sorted = List<CoinModel>.from(coins)
      ..sort((a, b) => (b.priceChangePercentage24h ?? 0)
          .compareTo(a.priceChangePercentage24h ?? 0));
    return sorted.take(10).toList();
  });
});

/// Top losers provider
final topLosersProvider = Provider<AsyncValue<List<CoinModel>>>((ref) {
  final coinsAsync = ref.watch(coinsProvider);
  
  return coinsAsync.whenData((coins) {
    // Sort by 24h change (ascending) and take top 10
    final sorted = List<CoinModel>.from(coins)
      ..sort((a, b) => (a.priceChangePercentage24h ?? 0)
          .compareTo(b.priceChangePercentage24h ?? 0));
    return sorted.take(10).toList();
  });
});

/// Selected exchange coins provider
final exchangeFromCoinProvider = StateProvider<CoinModel?>((ref) => null);
final exchangeToCoinProvider = StateProvider<CoinModel?>((ref) => null);
final exchangeAmountProvider = StateProvider<double>((ref) => 0);
