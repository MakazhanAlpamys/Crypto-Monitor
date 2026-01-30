import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/repositories/coin_repository.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/watchlist_repository.dart';
import '../data/datasources/coingecko_api.dart';
import '../data/models/coin_model.dart';
import '../data/models/coin_detail_model.dart';
import '../data/models/chart_data_model.dart';
import '../data/models/user_model.dart';
import '../core/localization/app_localizations.dart';

export 'portfolio_provider.dart';

// ==================== Repository Providers ====================

final coinGeckoApiProvider = Provider<CoinGeckoApi>((ref) {
  return CoinGeckoApi();
});

final coinRepositoryProvider = Provider<CoinRepository>((ref) {
  return CoinRepository(api: ref.watch(coinGeckoApiProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final watchlistRepositoryProvider = Provider<WatchlistRepository>((ref) {
  return WatchlistRepository();
});

// ==================== Auth Providers ====================

/// Auth state provider
final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

/// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authRepositoryProvider).currentUser;
});

/// Is authenticated provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

/// User profile provider
final userProfileProvider = FutureProvider<UserModel?>((ref) async {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);
  if (!isAuthenticated) return null;
  return ref.watch(authRepositoryProvider).getUserProfile();
});

// ==================== Coin Providers ====================

/// Top coins list provider
final coinsProvider = FutureProvider.autoDispose<List<CoinModel>>((ref) async {
  final currency = ref.watch(selectedCurrencyProvider);
  return ref.watch(coinRepositoryProvider).getTopCoins(currency: currency.code.toLowerCase());
});

/// Search query state
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Filtered coins based on search
final filteredCoinsProvider = Provider.autoDispose<AsyncValue<List<CoinModel>>>((ref) {
  final coinsAsync = ref.watch(coinsProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();

  return coinsAsync.whenData((coins) {
    if (query.isEmpty) return coins;
    return coins.where((coin) {
      return coin.name.toLowerCase().contains(query) ||
          coin.symbol.toLowerCase().contains(query);
    }).toList();
  });
});

/// Coin details provider
final coinDetailsProvider = FutureProvider.autoDispose.family<CoinDetailModel, String>((ref, coinId) async {
  return ref.watch(coinRepositoryProvider).getCoinDetails(coinId);
});

/// Selected time range for chart
final selectedTimeRangeProvider = StateProvider<ChartTimeRange>((ref) => ChartTimeRange.week1);

/// Coin chart data provider
final coinChartProvider = FutureProvider.autoDispose.family<ChartDataModel, String>((ref, coinId) async {
  final timeRange = ref.watch(selectedTimeRangeProvider);
  final currency = ref.watch(selectedCurrencyProvider);
  return ref.watch(coinRepositoryProvider).getCoinChart(
    coinId: coinId,
    timeRange: timeRange,
    currency: currency.code.toLowerCase(),
  );
});

/// Search results provider
final searchResultsProvider = FutureProvider.autoDispose.family<List<CoinSearchResult>, String>((ref, query) async {
  if (query.length < 2) return [];
  return ref.watch(coinRepositoryProvider).searchCoins(query);
});

// ==================== Watchlist Providers ====================

/// Watchlist coin IDs provider
final watchlistIdsProvider = FutureProvider<List<String>>((ref) async {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);
  if (!isAuthenticated) return [];
  return ref.watch(watchlistRepositoryProvider).getWatchlistCoinIds();
});

/// Watchlist coins provider
final watchlistCoinsProvider = FutureProvider<List<CoinModel>>((ref) async {
  final ids = await ref.watch(watchlistIdsProvider.future);
  if (ids.isEmpty) return [];
  final currency = ref.watch(selectedCurrencyProvider);
  return ref.watch(coinRepositoryProvider).getCoinsByIds(ids, currency: currency.code.toLowerCase());
});

/// Is coin in watchlist provider
final isInWatchlistProvider = FutureProvider.autoDispose.family<bool, String>((ref, coinId) async {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);
  if (!isAuthenticated) return false;
  return ref.watch(watchlistRepositoryProvider).isInWatchlist(coinId);
});

/// Watchlist notifier for toggling
class WatchlistNotifier extends StateNotifier<AsyncValue<Set<String>>> {
  final WatchlistRepository _repository;
  final Ref _ref;

  WatchlistNotifier(this._repository, this._ref) : super(const AsyncValue.loading()) {
    _loadWatchlist();
  }

  Future<void> _loadWatchlist() async {
    // Check if authenticated
    final isAuthenticated = _ref.read(isAuthenticatedProvider);
    if (!isAuthenticated) {
      state = const AsyncValue.data({});
      return;
    }
    
    try {
      final ids = await _repository.getWatchlistCoinIds();
      state = AsyncValue.data(ids.toSet());
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> toggle(String coinId) async {
    // Check authentication first
    final isAuthenticated = _ref.read(isAuthenticatedProvider);
    if (!isAuthenticated) {
      throw WatchlistNotAuthenticatedException();
    }
    
    final currentIds = state.valueOrNull ?? {};
    final isInList = currentIds.contains(coinId);

    // Optimistic update
    if (isInList) {
      state = AsyncValue.data({...currentIds}..remove(coinId));
    } else {
      state = AsyncValue.data({...currentIds, coinId});
    }

    try {
      await _repository.toggleWatchlist(coinId);
      // Invalidate related providers
      _ref.invalidate(watchlistCoinsProvider);
    } catch (e) {
      // Revert on error
      if (isInList) {
        state = AsyncValue.data({...currentIds, coinId});
      } else {
        state = AsyncValue.data({...currentIds}..remove(coinId));
      }
      rethrow;
    }
  }

  bool isInWatchlist(String coinId) {
    return state.valueOrNull?.contains(coinId) ?? false;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadWatchlist();
  }
}

/// Exception thrown when user is not authenticated and tries to use watchlist
class WatchlistNotAuthenticatedException implements Exception {
  @override
  String toString() => 'Please sign in to manage watchlist';
}

final watchlistNotifierProvider = StateNotifierProvider<WatchlistNotifier, AsyncValue<Set<String>>>((ref) {
  return WatchlistNotifier(
    ref.watch(watchlistRepositoryProvider),
    ref,
  );
});

// ==================== UI State Providers ====================

/// Bottom navigation index
final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

/// Loading state for auth operations
final authLoadingProvider = StateProvider<bool>((ref) => false);

// ==================== Settings Providers ====================

/// Available currencies
enum Currency {
  usd('USD', '\$', 'US Dollar'),
  eur('EUR', '€', 'Euro'),
  gbp('GBP', '£', 'British Pound'),
  jpy('JPY', '¥', 'Japanese Yen'),
  rub('RUB', '₽', 'Russian Ruble'),
  cny('CNY', '¥', 'Chinese Yuan');

  const Currency(this.code, this.symbol, this.name);
  final String code;
  final String symbol;
  final String name;
}

/// Selected currency provider
final selectedCurrencyProvider = StateProvider<Currency>((ref) => Currency.usd);

/// Theme mode provider
enum AppThemeMode {
  dark('Dark'),
  light('Light'),
  system('System');

  const AppThemeMode(this.label);
  final String label;
}

final themeModeProvider = StateProvider<AppThemeMode>((ref) => AppThemeMode.dark);

/// Notifications enabled provider
final notificationsEnabledProvider = StateProvider<bool>((ref) => true);

/// Language provider
final languageProvider = StateProvider<AppLanguage>((ref) => AppLanguage.english);

/// Localization provider
final localizationProvider = Provider<AppLocalizations>((ref) {
  final language = ref.watch(languageProvider);
  return AppLocalizations(language);
});

/// Guest mode provider - user is browsing without signing in
final isGuestModeProvider = StateProvider<bool>((ref) => false);
