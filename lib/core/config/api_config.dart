/// CoinGecko API Configuration
class ApiConfig {
  static const String baseUrl = 'https://api.coingecko.com/api/v3';
  
  // Endpoints
  static const String coinsMarkets = '/coins/markets';
  static const String coinDetails = '/coins';
  static const String searchCoins = '/search';
  static const String coinMarketChart = '/coins/{id}/market_chart';
  
  // Default parameters
  static const String defaultCurrency = 'usd';
  static const int defaultPerPage = 100;
  static const String defaultOrder = 'market_cap_desc';
  
  // Rate limiting
  static const Duration requestDelay = Duration(milliseconds: 1200);
}
