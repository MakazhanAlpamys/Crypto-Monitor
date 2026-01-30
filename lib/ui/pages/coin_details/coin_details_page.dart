import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/chart_data_model.dart';
import '../../../providers/providers.dart';
import '../../widgets/charts/price_chart.dart';
import '../../widgets/cards/stat_card.dart';
import '../../widgets/common/shimmer_loading.dart';
import '../../widgets/common/glass_container.dart';
import '../auth/login_page.dart';

class CoinDetailsPage extends ConsumerWidget {
  final String coinId;

  const CoinDetailsPage({super.key, required this.coinId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinAsync = ref.watch(coinsProvider);
    final chartAsync = ref.watch(coinChartProvider(coinId));
    final timeRange = ref.watch(selectedTimeRangeProvider);
    final watchlistAsync = ref.watch(watchlistNotifierProvider);

    // Find the coin from the cached list
    final coin = coinAsync.whenOrNull(
      data: (coins) => coins.firstWhere(
        (c) => c.id == coinId,
        orElse: () => coins.first,
      ),
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0F14),
              AppColors.background,
            ],
          ),
        ),
        child: coin == null
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  // App Bar
                  _buildAppBar(context, ref, coin, watchlistAsync),
                  // Content
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Price header
                        _buildPriceHeader(context, coin),
                        const SizedBox(height: 24),
                        // Chart
                        chartAsync.when(
                          data: (data) => _buildChart(ref, data, timeRange),
                          loading: () => const ShimmerDetailStats(),
                          error: (e, _) => _buildChartError(context, ref),
                        ),
                        const SizedBox(height: 24),
                        // Stats
                        _buildStatsSection(context, coin),
                        const SizedBox(height: 24),
                        // Additional info
                        _buildAdditionalInfo(context, coin),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, WidgetRef ref, dynamic coin,
      AsyncValue<Set<String>> watchlistAsync) {
    final isInWatchlist = watchlistAsync.valueOrNull?.contains(coinId) ?? false;

    return SliverAppBar(
      expandedHeight: 80,
      floating: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
            size: 18,
          ),
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (coin.image != null)
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: coin.image!,
                width: 32,
                height: 32,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(width: 8),
          Text(
            coin.symbol.toUpperCase(),
            style: context.textTheme.titleLarge,
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () async {
            try {
              await ref.read(watchlistNotifierProvider.notifier).toggle(coinId);
              if (context.mounted) {
                context.showSnackBar(
                  isInWatchlist
                      ? 'Removed from watchlist'
                      : 'Added to watchlist',
                );
              }
            } on WatchlistNotAuthenticatedException {
              if (context.mounted) {
                _showSignInDialog(context);
              }
            } catch (e) {
              if (context.mounted) {
                context.showSnackBar(
                  'Failed to update watchlist',
                  isError: true,
                );
              }
            }
          },
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isInWatchlist
                  ? AppColors.warning.withValues(alpha: 0.2)
                  : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isInWatchlist ? Icons.star : Icons.star_border,
              color: isInWatchlist ? AppColors.warning : AppColors.textPrimary,
              size: 22,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildPriceHeader(BuildContext context, dynamic coin) {
    final isPositive = coin.isPriceUp;
    final changeColor = isPositive ? AppColors.success : AppColors.error;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            coin.name,
            style: context.textTheme.titleSmall?.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatters.formatPrice(coin.currentPrice),
                style: context.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: changeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      color: changeColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      Formatters.formatPercentChange(
                        coin.priceChangePercentage24h,
                      ),
                      style: TextStyle(
                        color: changeColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildChart(WidgetRef ref, ChartDataModel data, ChartTimeRange timeRange) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        borderRadius: 24,
        child: PriceChart(
          chartData: data,
          timeRange: timeRange,
          onTimeRangeChanged: (range) {
            ref.read(selectedTimeRangeProvider.notifier).state = range;
          },
        ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Widget _buildChartError(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassContainer(
        padding: const EdgeInsets.all(40),
        borderRadius: 24,
        child: Column(
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load chart',
              style: context.textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => ref.invalidate(coinChartProvider(coinId)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, dynamic coin) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Statistics',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Market Cap',
                  value: Formatters.formatLargeNumber(coin.marketCap),
                  icon: Icons.pie_chart_outline,
                  isHighlighted: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: '24h Volume',
                  value: Formatters.formatLargeNumber(coin.totalVolume),
                  icon: Icons.bar_chart,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Circulating Supply',
                  value: Formatters.formatSupply(coin.circulatingSupply),
                  subtitle: coin.symbol.toUpperCase(),
                  icon: Icons.sync,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: 'Max Supply',
                  value: coin.maxSupply != null
                      ? Formatters.formatSupply(coin.maxSupply)
                      : '∞',
                  subtitle: coin.symbol.toUpperCase(),
                  icon: Icons.all_inclusive,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: '24h High',
                  value: Formatters.formatPrice(coin.high24h),
                  icon: Icons.arrow_upward,
                  iconColor: AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: '24h Low',
                  value: Formatters.formatPrice(coin.low24h),
                  icon: Icons.arrow_downward,
                  iconColor: AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  Widget _buildAdditionalInfo(BuildContext context, dynamic coin) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'All-Time Records',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GlassContainer(
            padding: const EdgeInsets.all(20),
            borderRadius: 20,
            child: Column(
              children: [
                _buildRecordRow(
                  context,
                  'All-Time High',
                  Formatters.formatPrice(coin.ath),
                  '${coin.athChangePercentage?.toStringAsFixed(2) ?? '0'}% from ATH',
                  coin.athDate != null
                      ? Formatters.formatDate(coin.athDate!)
                      : null,
                  isPositive: false,
                ),
                const Divider(color: AppColors.glassBorder, height: 24),
                _buildRecordRow(
                  context,
                  'All-Time Low',
                  Formatters.formatPrice(coin.atl),
                  '+${coin.atlChangePercentage?.toStringAsFixed(0) ?? '0'}% from ATL',
                  coin.atlDate != null
                      ? Formatters.formatDate(coin.atlDate!)
                      : null,
                  isPositive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms);
  }

  Widget _buildRecordRow(
    BuildContext context,
    String label,
    String value,
    String change,
    String? date, {
    required bool isPositive,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isPositive
                ? AppColors.success.withValues(alpha: 0.1)
                : AppColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            color: isPositive ? AppColors.success : AppColors.error,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              change,
              style: TextStyle(
                color: isPositive ? AppColors.success : AppColors.error,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (date != null) ...[
              const SizedBox(height: 2),
              Text(
                date,
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  void _showSignInDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Sign In Required'),
        content: const Text(
          'Please sign in to add coins to your watchlist.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}
