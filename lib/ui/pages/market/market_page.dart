import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../providers/providers.dart';
import '../../widgets/cards/coin_card.dart';
import '../../widgets/common/shimmer_loading.dart';
import '../../widgets/common/custom_text_field.dart';
import '../coin_details/coin_details_page.dart';

class MarketPage extends ConsumerStatefulWidget {
  const MarketPage({super.key});

  @override
  ConsumerState<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends ConsumerState<MarketPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    ref.invalidate(coinsProvider);
    await ref.read(coinsProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final filteredCoins = ref.watch(filteredCoinsProvider);

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
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              // Search bar
              _buildSearchBar(),
              const SizedBox(height: 8),
              // Market stats
              _buildMarketStats(),
              const SizedBox(height: 8),
              // Coin list
              Expanded(
                child: filteredCoins.when(
                  data: (coins) => _buildCoinList(coins),
                  loading: () => const ShimmerCoinList(),
                  error: (error, stack) => _buildErrorState(error.toString()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Crypto Market',
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Top 100 by Market Cap',
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Refresh button
          IconButton(
            onPressed: _onRefresh,
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: const Icon(
                Icons.refresh,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SearchTextField(
        controller: _searchController,
        hintText: 'Search coins...',
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).state = value;
        },
        onClear: () {
          ref.read(searchQueryProvider.notifier).state = '';
        },
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildMarketStats() {
    return ref.watch(coinsProvider).when(
          data: (coins) {
            if (coins.isEmpty) return const SizedBox();
            
            final totalMarketCap = coins.fold<double>(
              0,
              (sum, coin) => sum + (coin.marketCap ?? 0),
            );
            
            final totalVolume = coins.fold<double>(
              0,
              (sum, coin) => sum + (coin.totalVolume ?? 0),
            );
            
            final gainers = coins.where((c) => (c.priceChangePercentage24h ?? 0) > 0).length;
            final losers = coins.length - gainers;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.gradientBlueEnd.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'Market Cap',
                    _formatLargeNumber(totalMarketCap),
                    Icons.pie_chart,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: AppColors.glassBorder,
                  ),
                  _buildStatItem(
                    '24h Volume',
                    _formatLargeNumber(totalVolume),
                    Icons.show_chart,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: AppColors.glassBorder,
                  ),
                  _buildStatItem(
                    'Gainers/Losers',
                    '$gainers / $losers',
                    Icons.trending_up,
                    valueColor: AppColors.success,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
          },
          loading: () => const SizedBox(height: 80),
          error: (_, _) => const SizedBox(),
        );
  }

  Widget _buildStatItem(String label, String value, IconData icon, {Color? valueColor}) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.textTertiary),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textTertiary,
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatLargeNumber(double number) {
    if (number >= 1e12) {
      return '\$${(number / 1e12).toStringAsFixed(2)}T';
    } else if (number >= 1e9) {
      return '\$${(number / 1e9).toStringAsFixed(2)}B';
    } else if (number >= 1e6) {
      return '\$${(number / 1e6).toStringAsFixed(2)}M';
    }
    return '\$${number.toStringAsFixed(0)}';
  }

  Widget _buildCoinList(List coins) {
    if (coins.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: AppColors.primary,
      backgroundColor: AppColors.surfaceLight,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 8, bottom: 100),
        itemCount: coins.length,
        itemBuilder: (context, index) {
          final coin = coins[index];
          return CoinCard(
            coin: coin,
            index: index,
            onTap: () => _navigateToDetails(coin.id),
          );
        },
      ),
    );
  }

  void _navigateToDetails(String coinId) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CoinDetailsPage(coinId: coinId),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              )),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  Widget _buildEmptyState() {
    final query = ref.watch(searchQueryProvider);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            query.isNotEmpty
                ? 'No coins found for "$query"'
                : 'No coins available',
            style: context.textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Failed to load data',
              style: context.textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
