import '../datasources/coingecko_api.dart';
import '../models/coin_model.dart';
import '../models/coin_detail_model.dart';
import '../models/chart_data_model.dart';

/// Repository for cryptocurrency data
class CoinRepository {
  final CoinGeckoApi _api;

  CoinRepository({CoinGeckoApi? api}) : _api = api ?? CoinGeckoApi();

  /// Get top coins by market cap
  Future<List<CoinModel>> getTopCoins({
    int page = 1,
    int perPage = 100,
    String currency = 'usd',
  }) async {
    return _api.getCoinsMarkets(
      page: page,
      perPage: perPage,
      sparkline: true,
      currency: currency,
    );
  }

  /// Get coins by IDs (for watchlist)
  Future<List<CoinModel>> getCoinsByIds(List<String> ids, {String currency = 'usd'}) async {
    if (ids.isEmpty) return [];
    return _api.getCoinsMarkets(
      ids: ids.join(','),
      sparkline: true,
      currency: currency,
    );
  }

  /// Get detailed coin information
  Future<CoinDetailModel> getCoinDetails(String coinId) async {
    return _api.getCoinDetails(coinId);
  }

  /// Get price chart data
  Future<ChartDataModel> getCoinChart({
    required String coinId,
    required ChartTimeRange timeRange,
    String currency = 'usd',
  }) async {
    return _api.getCoinMarketChart(
      coinId: coinId,
      days: timeRange.days,
      currency: currency,
    );
  }

  /// Search coins
  Future<List<CoinSearchResult>> searchCoins(String query) async {
    if (query.isEmpty) return [];
    return _api.searchCoins(query);
  }
}
