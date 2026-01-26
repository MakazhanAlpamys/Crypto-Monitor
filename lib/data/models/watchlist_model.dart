/// Watchlist item model for Supabase
class WatchlistItem {
  final String? id;
  final String userId;
  final String coinId;
  final DateTime? addedAt;

  WatchlistItem({
    this.id,
    required this.userId,
    required this.coinId,
    this.addedAt,
  });

  factory WatchlistItem.fromJson(Map<String, dynamic> json) {
    return WatchlistItem(
      id: json['id'] as String?,
      userId: json['user_id'] as String,
      coinId: json['coin_id'] as String,
      addedAt: json['added_at'] != null
          ? DateTime.tryParse(json['added_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'coin_id': coinId,
      if (addedAt != null) 'added_at': addedAt!.toIso8601String(),
    };
  }

  WatchlistItem copyWith({
    String? id,
    String? userId,
    String? coinId,
    DateTime? addedAt,
  }) {
    return WatchlistItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      coinId: coinId ?? this.coinId,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchlistItem &&
          runtimeType == other.runtimeType &&
          coinId == other.coinId &&
          userId == other.userId;

  @override
  int get hashCode => coinId.hashCode ^ userId.hashCode;
}
