import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/watchlist_model.dart';
import '../../core/config/supabase_config.dart';

/// Repository for watchlist operations
class WatchlistRepository {
  final SupabaseClient _client;

  WatchlistRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  String? get _userId => _client.auth.currentUser?.id;

  /// Get user's watchlist
  Future<List<WatchlistItem>> getWatchlist() async {
    if (_userId == null) return [];

    try {
      final response = await _client
          .from(SupabaseConfig.watchlistTable)
          .select()
          .eq('user_id', _userId!)
          .order('added_at', ascending: false);

      return (response as List)
          .map((json) => WatchlistItem.fromJson(json))
          .toList();
    } catch (e) {
      throw WatchlistException('Failed to load watchlist');
    }
  }

  /// Get watchlist coin IDs
  Future<List<String>> getWatchlistCoinIds() async {
    final watchlist = await getWatchlist();
    return watchlist.map((item) => item.coinId).toList();
  }

  /// Check if coin is in watchlist
  Future<bool> isInWatchlist(String coinId) async {
    if (_userId == null) return false;

    try {
      final response = await _client
          .from(SupabaseConfig.watchlistTable)
          .select('id')
          .eq('user_id', _userId!)
          .eq('coin_id', coinId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  /// Add coin to watchlist
  Future<void> addToWatchlist(String coinId) async {
    if (_userId == null) throw WatchlistException('Not authenticated');

    try {
      await _client.from(SupabaseConfig.watchlistTable).insert({
        'user_id': _userId,
        'coin_id': coinId,
      });
    } catch (e) {
      // Handle unique constraint violation
      if (e.toString().contains('duplicate') ||
          e.toString().contains('unique')) {
        return; // Already in watchlist
      }
      throw WatchlistException('Failed to add to watchlist');
    }
  }

  /// Remove coin from watchlist
  Future<void> removeFromWatchlist(String coinId) async {
    if (_userId == null) throw WatchlistException('Not authenticated');

    try {
      await _client
          .from(SupabaseConfig.watchlistTable)
          .delete()
          .eq('user_id', _userId!)
          .eq('coin_id', coinId);
    } catch (e) {
      throw WatchlistException('Failed to remove from watchlist');
    }
  }

  /// Toggle watchlist status
  Future<bool> toggleWatchlist(String coinId) async {
    final isInList = await isInWatchlist(coinId);
    if (isInList) {
      await removeFromWatchlist(coinId);
      return false;
    } else {
      await addToWatchlist(coinId);
      return true;
    }
  }

  /// Real-time watchlist stream
  Stream<List<WatchlistItem>> watchlistStream() {
    if (_userId == null) return Stream.value([]);

    return _client
        .from(SupabaseConfig.watchlistTable)
        .stream(primaryKey: ['id'])
        .eq('user_id', _userId!)
        .order('added_at', ascending: false)
        .map((data) => data.map((json) => WatchlistItem.fromJson(json)).toList());
  }
}

/// Custom exception for watchlist errors
class WatchlistException implements Exception {
  final String message;
  WatchlistException(this.message);

  @override
  String toString() => message;
}
