import 'package:dio/dio.dart';
import '../models/coin_model.dart';
import '../models/coin_detail_model.dart';
import '../models/chart_data_model.dart';
import '../../core/config/api_config.dart';

/// CoinGecko API Data Source
class CoinGeckoApi {
  final Dio _dio;

  CoinGeckoApi({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: ApiConfig.baseUrl,
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
              headers: {
                'Accept': 'application/json',
              },
            ));

  /// Get list of coins with market data
  Future<List<CoinModel>> getCoinsMarkets({
    String currency = ApiConfig.defaultCurrency,
    String order = ApiConfig.defaultOrder,
    int perPage = ApiConfig.defaultPerPage,
    int page = 1,
    bool sparkline = true,
    String? ids,
  }) async {
    try {
      final response = await _dio.get(
        ApiConfig.coinsMarkets,
        queryParameters: {
          'vs_currency': currency,
          'order': order,
          'per_page': perPage,
          'page': page,
          'sparkline': sparkline,
          if (ids != null) 'ids': ids,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as List;
        return data.map((json) => CoinModel.fromJson(json)).toList();
      }
      throw CoinGeckoException('Failed to load coins: ${response.statusCode}');
    } on DioException catch (e) {
      throw CoinGeckoException(_handleDioError(e));
    }
  }

  /// Get detailed coin information
  Future<CoinDetailModel> getCoinDetails(String coinId) async {
    try {
      final response = await _dio.get(
        '${ApiConfig.coinDetails}/$coinId',
        queryParameters: {
          'localization': false,
          'tickers': false,
          'market_data': true,
          'community_data': false,
          'developer_data': false,
          'sparkline': false,
        },
      );

      if (response.statusCode == 200) {
        return CoinDetailModel.fromJson(response.data);
      }
      throw CoinGeckoException('Failed to load coin details: ${response.statusCode}');
    } on DioException catch (e) {
      throw CoinGeckoException(_handleDioError(e));
    }
  }

  /// Get price chart data
  Future<ChartDataModel> getCoinMarketChart({
    required String coinId,
    String currency = ApiConfig.defaultCurrency,
    int days = 7,
  }) async {
    try {
      final response = await _dio.get(
        '/coins/$coinId/market_chart',
        queryParameters: {
          'vs_currency': currency,
          'days': days == 0 ? 'max' : days,
        },
      );

      if (response.statusCode == 200) {
        return ChartDataModel.fromJson(response.data);
      }
      throw CoinGeckoException('Failed to load chart data: ${response.statusCode}');
    } on DioException catch (e) {
      throw CoinGeckoException(_handleDioError(e));
    }
  }

  /// Search for coins
  Future<List<CoinSearchResult>> searchCoins(String query) async {
    try {
      final response = await _dio.get(
        ApiConfig.searchCoins,
        queryParameters: {'query': query},
      );

      if (response.statusCode == 200) {
        final coins = response.data['coins'] as List;
        return coins.map((json) => CoinSearchResult.fromJson(json)).toList();
      }
      throw CoinGeckoException('Failed to search coins: ${response.statusCode}');
    } on DioException catch (e) {
      throw CoinGeckoException(_handleDioError(e));
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 429) {
          return 'Too many requests. Please try again later.';
        }
        return 'Server error: $statusCode';
      default:
        return 'An unexpected error occurred.';
    }
  }
}

/// Search result model
class CoinSearchResult {
  final String id;
  final String name;
  final String symbol;
  final int? marketCapRank;
  final String? thumb;
  final String? large;

  CoinSearchResult({
    required this.id,
    required this.name,
    required this.symbol,
    this.marketCapRank,
    this.thumb,
    this.large,
  });

  factory CoinSearchResult.fromJson(Map<String, dynamic> json) {
    return CoinSearchResult(
      id: json['id'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      marketCapRank: json['market_cap_rank'] as int?,
      thumb: json['thumb'] as String?,
      large: json['large'] as String?,
    );
  }
}

/// Custom exception for API errors
class CoinGeckoException implements Exception {
  final String message;
  CoinGeckoException(this.message);

  @override
  String toString() => message;
}
