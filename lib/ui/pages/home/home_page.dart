import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/providers.dart';
import '../market/market_page.dart';
import '../watchlist/watchlist_page.dart';
import '../portfolio/portfolio_page.dart';
import 'profile_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          MarketPage(),
          PortfolioPage(),
          WatchlistPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context, ref, currentIndex),
    );
  }

  Widget _buildBottomNav(BuildContext context, WidgetRef ref, int currentIndex) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(
          top: BorderSide(
            color: AppColors.glassBorder,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                ref: ref,
                index: 0,
                currentIndex: currentIndex,
                icon: Icons.show_chart,
                activeIcon: Icons.show_chart,
                label: 'Market',
              ),
              _buildNavItem(
                ref: ref,
                index: 1,
                currentIndex: currentIndex,
                icon: Icons.pie_chart_outline,
                activeIcon: Icons.pie_chart,
                label: 'Portfolio',
              ),
              _buildNavItem(
                ref: ref,
                index: 2,
                currentIndex: currentIndex,
                icon: Icons.star_border,
                activeIcon: Icons.star,
                label: 'Watchlist',
              ),
              _buildNavItem(
                ref: ref,
                index: 3,
                currentIndex: currentIndex,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required WidgetRef ref,
    required int index,
    required int currentIndex,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () {
        ref.read(bottomNavIndexProvider.notifier).state = index;
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.2),
                    AppColors.primary.withValues(alpha: 0.1),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppColors.primary : AppColors.textTertiary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
