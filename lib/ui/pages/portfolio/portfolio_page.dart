import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/portfolio_model.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../providers/providers.dart';
import '../../widgets/common/glass_container.dart';
import '../coin_details/coin_details_page.dart';
import '../exchange/exchange_page.dart';

class PortfolioPage extends ConsumerWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(portfolioSummaryProvider);

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
          child: RefreshIndicator(
            onRefresh: () => ref.read(portfolioNotifierProvider.notifier).refresh(),
            color: AppColors.primary,
            backgroundColor: AppColors.surfaceLight,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                _buildAppBar(context),
                SliverToBoxAdapter(
                  child: summaryAsync.when(
                    data: (summary) => Column(
                      children: [
                        _buildBalanceCard(context, summary),
                        const SizedBox(height: 24),
                        _buildQuickActions(context, ref),
                        const SizedBox(height: 24),
                        if (summary.assets.isNotEmpty) ...[
                          _buildDistributionChart(context, summary),
                          const SizedBox(height: 24),
                        ],
                        _buildAssetsSection(context, ref, summary.assets),
                        const SizedBox(height: 100),
                      ],
                    ),
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(64.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (e, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            const Icon(Icons.error_outline, 
                                color: AppColors.error, size: 48),
                            const SizedBox(height: 16),
                            Text('Failed to load portfolio',
                                style: context.textTheme.bodyLarge),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => ref
                                  .read(portfolioNotifierProvider.notifier)
                                  .refresh(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Portfolio',
        style: context.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ).animate().fadeIn(duration: 400.ms),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.history, color: AppColors.textPrimary, size: 22),
          ),
        ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.2),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBalanceCard(BuildContext context, PortfolioSummary summary) {
    final currency = '\$';
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C5CE7), Color(0xFF8B5CF6), Color(0xFFA855F7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.account_balance_wallet, 
                          color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Total Balance',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.visibility_off,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '$currency${Formatters.formatLargePrice(summary.totalValue)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildChangeChip(
                  '${summary.is24hUp ? '+' : ''}$currency${Formatters.formatPrice(summary.change24h.abs())}',
                  '(${summary.changePercentage24h.toStringAsFixed(2)}%)',
                  summary.is24hUp,
                ),
                const SizedBox(width: 12),
                Text(
                  'Today',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBalanceInfo(
                    'Invested',
                    '$currency${Formatters.formatLargePrice(summary.totalInvested)}',
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  _buildBalanceInfo(
                    'Profit/Loss',
                    '${summary.isProfit ? '+' : ''}$currency${Formatters.formatPrice(summary.totalProfitLoss.abs())}',
                    valueColor: summary.isProfit 
                        ? const Color(0xFF34D399) 
                        : const Color(0xFFF87171),
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  _buildBalanceInfo(
                    'Return',
                    '${summary.isProfit ? '+' : ''}${summary.profitLossPercentage.toStringAsFixed(2)}%',
                    valueColor: summary.isProfit 
                        ? const Color(0xFF34D399) 
                        : const Color(0xFFF87171),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1);
  }

  Widget _buildChangeChip(String amount, String percent, bool isUp) {
    final color = isUp ? const Color(0xFF34D399) : const Color(0xFFF87171);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isUp ? Icons.trending_up : Icons.trending_down,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            '$amount $percent',
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceInfo(String label, String value, {Color? valueColor}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              context,
              Icons.arrow_downward_rounded,
              'Deposit',
              AppColors.success,
              () => _showComingSoonSnackBar(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              context,
              Icons.arrow_upward_rounded,
              'Withdraw',
              AppColors.error,
              () => _showComingSoonSnackBar(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              context,
              Icons.swap_horiz_rounded,
              'Exchange',
              AppColors.primary,
              () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ExchangePage()),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 100.ms);
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionChart(BuildContext context, PortfolioSummary summary) {
    if (summary.assets.isEmpty) return const SizedBox();
    
    final colors = [
      const Color(0xFFF7931A), // Bitcoin orange
      const Color(0xFF627EEA), // Ethereum blue
      const Color(0xFFF3BA2F), // BNB yellow
      const Color(0xFF14F195), // Solana green
      AppColors.primary,       // Default purple
      const Color(0xFF00D4FF), // Light blue
      const Color(0xFFFF6B6B), // Red
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        borderRadius: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Portfolio Distribution',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${summary.assets.length} Assets',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 180,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 3,
                        centerSpaceRadius: 50,
                        sections: summary.assets.asMap().entries.map((entry) {
                          final asset = entry.value;
                          final percentage = summary.totalValue > 0
                              ? (asset.currentValue / summary.totalValue) * 100
                              : 0.0;
                          final color = colors[entry.key % colors.length];
                          
                          return PieChartSectionData(
                            value: asset.currentValue,
                            color: color,
                            title: '${percentage.toStringAsFixed(0)}%',
                            radius: 40,
                            titleStyle: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: summary.assets.take(5).toList().asMap().entries.map((entry) {
                      final asset = entry.value;
                      final color = colors[entry.key % colors.length];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              asset.symbol.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 200.ms);
  }

  Widget _buildAssetsSection(
    BuildContext context,
    WidgetRef ref,
    List<PortfolioAsset> assets,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Assets',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('See All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (assets.isEmpty)
            _buildEmptyAssetsState(context)
          else
            ...assets.asMap().entries.map((entry) {
              return _buildAssetItem(context, entry.value, entry.key);
            }),
        ],
      ).animate().fadeIn(duration: 500.ms, delay: 300.ms),
    );
  }

  Widget _buildAssetItem(BuildContext context, PortfolioAsset asset, int index) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => CoinDetailsPage(coinId: asset.coinId)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            // Coin icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: asset.image != null
                  ? ClipOval(
                      child: Image.network(
                        asset.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, error, stack) => Center(
                          child: Text(
                            asset.symbol[0].toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        asset.symbol[0].toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            // Name and amount
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asset.name,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${Formatters.formatCryptoAmount(asset.amount)} ${asset.symbol.toUpperCase()}',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Value and P/L
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${Formatters.formatPrice(asset.currentValue)}',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (asset.isProfit ? AppColors.success : AppColors.error)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${asset.isProfit ? '+' : ''}${asset.profitLossPercentage.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: asset.isProfit ? AppColors.success : AppColors.error,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ).animate().fadeIn(
        duration: 400.ms,
        delay: Duration(milliseconds: 100 * index),
      ).slideX(begin: 0.1),
    );
  }

  Widget _buildEmptyAssetsState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: AppColors.primary,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No assets yet',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start building your portfolio by\nadding your first cryptocurrency',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Add Asset'),
          ),
        ],
      ),
    );
  }

  void _showComingSoonSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Coming soon!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
