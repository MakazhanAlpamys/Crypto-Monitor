import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/coin_model.dart';
import '../../../providers/portfolio_provider.dart';
import '../../pages/coin_details/coin_details_page.dart';

/// Horizontal scrolling trending coins section
class TrendingCoinsSection extends ConsumerWidget {
  final String title;
  final bool showGainers;
  
  const TrendingCoinsSection({
    super.key,
    this.title = 'Trending',
    this.showGainers = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinsAsync = showGainers 
        ? ref.watch(trendingCoinsProvider)
        : ref.watch(topLosersProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    showGainers ? Icons.trending_up : Icons.trending_down,
                    color: showGainers ? AppColors.success : AppColors.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: coinsAsync.when(
            data: (coins) => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: coins.length.clamp(0, 10),
              itemBuilder: (context, index) {
                return _TrendingCoinCard(
                  coin: coins[index],
                  index: index,
                );
              },
            ),
            loading: () => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: 5,
              itemBuilder: (context, index) => const _TrendingCoinCardSkeleton(),
            ),
            error: (e, _) => Center(
              child: Text(
                'Failed to load',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TrendingCoinCard extends StatelessWidget {
  final CoinModel coin;
  final int index;

  const _TrendingCoinCard({
    required this.coin,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isUp = coin.isPriceUp;
    final changeColor = isUp ? AppColors.success : AppColors.error;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CoinDetailsPage(coinId: coin.id),
          ),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surfaceLight,
              AppColors.surfaceDark,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: changeColor.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: changeColor.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and change
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceDark,
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: coin.image != null
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: coin.image!,
                            fit: BoxFit.cover,
                            errorWidget: (_, error, stack) => _buildPlaceholder(),
                          ),
                        )
                      : _buildPlaceholder(),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: changeColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isUp ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                        color: changeColor,
                        size: 16,
                      ),
                      Text(
                        '${(coin.priceChangePercentage24h ?? 0).abs().toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: changeColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            // Symbol
            Text(
              coin.symbol.toUpperCase(),
              style: TextStyle(
                color: AppColors.textTertiary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            // Price
            Text(
              Formatters.formatPrice(coin.currentPrice),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Mini sparkline
            if (coin.sparklineIn7d != null && coin.sparklineIn7d!.isNotEmpty)
              SizedBox(
                height: 24,
                child: CustomPaint(
                  size: const Size(double.infinity, 24),
                  painter: _SparklinePainter(
                    data: coin.sparklineIn7d!,
                    color: changeColor,
                  ),
                ),
              ),
          ],
        ),
      ).animate().fadeIn(
        duration: 400.ms,
        delay: Duration(milliseconds: 100 * index),
      ).slideX(begin: 0.2),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Text(
        coin.symbol.isNotEmpty ? coin.symbol[0].toUpperCase() : '?',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _TrendingCoinCardSkeleton extends StatelessWidget {
  const _TrendingCoinCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceDark,
                ),
              ),
              Container(
                width: 40,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 40,
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 80,
            height: 16,
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    ).animate(onPlay: (c) => c.repeat())
      .shimmer(duration: 1500.ms, color: AppColors.glassBorder);
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;

  _SparklinePainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.3),
          color.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = data.reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;
    
    if (range == 0) return;

    final path = Path();
    final fillPath = Path();
    final stepX = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - ((data[i] - minValue) / range * size.height);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
