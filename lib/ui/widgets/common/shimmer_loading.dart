import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';

/// Shimmer loading widget
class ShimmerLoading extends StatelessWidget {
  final Widget child;

  const ShimmerLoading({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceLight,
      highlightColor: AppColors.surfaceDark.withValues(alpha: 0.5),
      child: child,
    );
  }
}

/// Shimmer box placeholder
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Shimmer coin card placeholder
class ShimmerCoinCard extends StatelessWidget {
  const ShimmerCoinCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          children: [
            // Coin image placeholder
            const ShimmerBox(width: 48, height: 48, borderRadius: 24),
            const SizedBox(width: 12),
            // Name and symbol
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 80, height: 16, borderRadius: 4),
                  const SizedBox(height: 6),
                  ShimmerBox(width: 50, height: 12, borderRadius: 4),
                ],
              ),
            ),
            // Sparkline placeholder
            ShimmerBox(width: 80, height: 40, borderRadius: 8),
            const SizedBox(width: 12),
            // Price and change
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ShimmerBox(width: 70, height: 16, borderRadius: 4),
                const SizedBox(height: 6),
                ShimmerBox(width: 50, height: 12, borderRadius: 4),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer list placeholder
class ShimmerCoinList extends StatelessWidget {
  final int itemCount;

  const ShimmerCoinList({
    super.key,
    this.itemCount = AppConstants.shimmerItemCount,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => const ShimmerCoinCard(),
    );
  }
}

/// Shimmer detail stats placeholder
class ShimmerDetailStats extends StatelessWidget {
  const ShimmerDetailStats({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Column(
        children: [
          // Chart placeholder
          Container(
            height: 250,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          // Stats grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatPlaceholder(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatPlaceholder(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatPlaceholder(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatPlaceholder(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: 60, height: 12, borderRadius: 4),
          const SizedBox(height: 8),
          ShimmerBox(width: 100, height: 20, borderRadius: 4),
        ],
      ),
    );
  }
}
