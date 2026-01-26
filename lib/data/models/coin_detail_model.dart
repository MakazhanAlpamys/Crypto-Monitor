/// Detailed coin model for individual coin page
class CoinDetailModel {
  final String id;
  final String symbol;
  final String name;
  final String? description;
  final String? image;
  final MarketData? marketData;
  final List<String>? categories;
  final String? genesisDate;
  final int? sentimentVotesUpPercentage;
  final int? sentimentVotesDownPercentage;
  final int? watchlistUsers;
  final Links? links;

  CoinDetailModel({
    required this.id,
    required this.symbol,
    required this.name,
    this.description,
    this.image,
    this.marketData,
    this.categories,
    this.genesisDate,
    this.sentimentVotesUpPercentage,
    this.sentimentVotesDownPercentage,
    this.watchlistUsers,
    this.links,
  });

  factory CoinDetailModel.fromJson(Map<String, dynamic> json) {
    return CoinDetailModel(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      description: json['description']?['en'] as String?,
      image: json['image']?['large'] as String?,
      marketData: json['market_data'] != null
          ? MarketData.fromJson(json['market_data'])
          : null,
      categories: json['categories'] != null
          ? List<String>.from(json['categories'])
          : null,
      genesisDate: json['genesis_date'] as String?,
      sentimentVotesUpPercentage: json['sentiment_votes_up_percentage'] as int?,
      sentimentVotesDownPercentage: json['sentiment_votes_down_percentage'] as int?,
      watchlistUsers: json['watchlist_portfolio_users'] as int?,
      links: json['links'] != null ? Links.fromJson(json['links']) : null,
    );
  }
}

class MarketData {
  final double? currentPrice;
  final double? marketCap;
  final int? marketCapRank;
  final double? totalVolume;
  final double? high24h;
  final double? low24h;
  final double? priceChange24h;
  final double? priceChangePercentage24h;
  final double? priceChangePercentage7d;
  final double? priceChangePercentage30d;
  final double? priceChangePercentage1y;
  final double? circulatingSupply;
  final double? totalSupply;
  final double? maxSupply;
  final double? ath;
  final double? athChangePercentage;
  final DateTime? athDate;
  final double? atl;
  final double? atlChangePercentage;
  final DateTime? atlDate;

  MarketData({
    this.currentPrice,
    this.marketCap,
    this.marketCapRank,
    this.totalVolume,
    this.high24h,
    this.low24h,
    this.priceChange24h,
    this.priceChangePercentage24h,
    this.priceChangePercentage7d,
    this.priceChangePercentage30d,
    this.priceChangePercentage1y,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    this.ath,
    this.athChangePercentage,
    this.athDate,
    this.atl,
    this.atlChangePercentage,
    this.atlDate,
  });

  factory MarketData.fromJson(Map<String, dynamic> json) {
    return MarketData(
      currentPrice: _getUsdValue(json['current_price']),
      marketCap: _getUsdValue(json['market_cap']),
      marketCapRank: json['market_cap_rank'] as int?,
      totalVolume: _getUsdValue(json['total_volume']),
      high24h: _getUsdValue(json['high_24h']),
      low24h: _getUsdValue(json['low_24h']),
      priceChange24h: _parseDouble(json['price_change_24h']),
      priceChangePercentage24h: _parseDouble(json['price_change_percentage_24h']),
      priceChangePercentage7d: _parseDouble(json['price_change_percentage_7d']),
      priceChangePercentage30d: _parseDouble(json['price_change_percentage_30d']),
      priceChangePercentage1y: _parseDouble(json['price_change_percentage_1y']),
      circulatingSupply: _parseDouble(json['circulating_supply']),
      totalSupply: _parseDouble(json['total_supply']),
      maxSupply: _parseDouble(json['max_supply']),
      ath: _getUsdValue(json['ath']),
      athChangePercentage: _getUsdValue(json['ath_change_percentage']),
      athDate: json['ath_date']?['usd'] != null
          ? DateTime.tryParse(json['ath_date']['usd'])
          : null,
      atl: _getUsdValue(json['atl']),
      atlChangePercentage: _getUsdValue(json['atl_change_percentage']),
      atlDate: json['atl_date']?['usd'] != null
          ? DateTime.tryParse(json['atl_date']['usd'])
          : null,
    );
  }

  static double? _getUsdValue(dynamic data) {
    if (data == null) return null;
    if (data is Map) {
      return _parseDouble(data['usd']);
    }
    return _parseDouble(data);
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  bool get isPriceUp => (priceChangePercentage24h ?? 0) >= 0;
}

class Links {
  final String? homepage;
  final String? twitter;
  final String? reddit;
  final String? github;
  final String? telegram;

  Links({
    this.homepage,
    this.twitter,
    this.reddit,
    this.github,
    this.telegram,
  });

  factory Links.fromJson(Map<String, dynamic> json) {
    final homepageList = json['homepage'] as List?;
    final reposUrls = json['repos_url'] as Map?;
    final githubList = reposUrls?['github'] as List?;

    return Links(
      homepage: homepageList?.isNotEmpty == true ? homepageList!.first as String? : null,
      twitter: json['twitter_screen_name'] != null
          ? 'https://twitter.com/${json['twitter_screen_name']}'
          : null,
      reddit: json['subreddit_url'] as String?,
      github: githubList?.isNotEmpty == true ? githubList!.first as String? : null,
      telegram: json['telegram_channel_identifier'] != null
          ? 'https://t.me/${json['telegram_channel_identifier']}'
          : null,
    );
  }
}
