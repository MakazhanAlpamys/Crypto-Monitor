import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/coin_model.dart';
import '../charts/sparkline_chart.dart';

/// Coin list card widget
class CoinCard extends StatelessWidget {
  final CoinModel coin;
  final VoidCallback? onTap;
  final int index;

  const CoinCard({
    super.key,
    required this.coin,
    this.onTap,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [
        FadeEffect(
          delay: Duration(milliseconds: 50 * (index % 10)),
          duration: const Duration(milliseconds: 300),
        ),
        SlideEffect(
          begin: const Offset(0.1, 0),
          end: Offset.zero,
          delay: Duration(milliseconds: 50 * (index % 10)),
          duration: const Duration(milliseconds: 300),
        ),
      ],
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.cardBackground,
                AppColors.surfaceLight.withValues(alpha: 0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.glassBorder,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Rank
              SizedBox(
                width: 28,
                child: Text(
                  '${coin.marketCapRank ?? '-'}',
                  style: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Coin image
              _buildCoinImage(),
              const SizedBox(width: 12),
              // Name and symbol
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coin.name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      coin.symbol.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Sparkline
              if (coin.sparklineIn7d != null && coin.sparklineIn7d!.isNotEmpty)
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SizedBox(
                      height: 40,
                      child: SparklineChart(
                        data: coin.sparklineIn7d!,
                        isPositive: coin.isPriceUp,
                      ),
                    ),
                  ),
                )
              else
                const Expanded(flex: 2, child: SizedBox()),
              // Price and change
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Formatters.formatPrice(coin.currentPrice),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildPriceChange(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoinImage() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: coin.image != null
            ? CachedNetworkImage(
                imageUrl: coin.image!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.surfaceLight,
                  child: const Icon(
                    Icons.currency_bitcoin,
                    color: AppColors.textTertiary,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.currency_bitcoin,
                  color: AppColors.textTertiary,
                ),
              )
            : const Icon(
                Icons.currency_bitcoin,
                color: AppColors.textTertiary,
              ),
      ),
    );
  }

  Widget _buildPriceChange() {
    final change = coin.priceChangePercentage24h ?? 0;
    final isPositive = change >= 0;
    final color = isPositive ? AppColors.success : AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            color: color,
            size: 16,
          ),
          Text(
            '${change.abs().toStringAsFixed(2)}%',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
