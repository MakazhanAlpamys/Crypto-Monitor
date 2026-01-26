import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../providers/providers.dart';
import '../../../providers/auth_notifier.dart';
import '../../widgets/common/glass_container.dart';
import '../../widgets/common/gradient_button.dart';
import '../auth/login_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final isAuthenticated = authState.status == AuthStatus.authenticated;
    final user = ref.watch(currentUserProvider);

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Header
                _buildHeader(context),
                const SizedBox(height: 32),
                // Profile card or sign in prompt
                isAuthenticated
                    ? _buildProfileCard(context, ref, user)
                    : _buildSignInCard(context),
                const SizedBox(height: 24),
                // Settings section
                _buildSettingsSection(context, ref),
                const SizedBox(height: 24),
                // About section
                _buildAboutSection(context),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage your account',
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildProfileCard(BuildContext context, WidgetRef ref, dynamic user) {
    final email = user?.email ?? 'User';
    final initial = email.isNotEmpty ? email[0].toUpperCase() : 'U';

    return GlassContainer(
      padding: const EdgeInsets.all(24),
      borderRadius: 24,
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Email
          Text(
            email,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Signed In',
                  style: TextStyle(
                    color: AppColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Sign out button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showSignOutDialog(context, ref),
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('Sign Out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Future<void> _showSignOutDialog(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Sign Out',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(authNotifierProvider.notifier).signOut();
    }
  }

  Widget _buildSignInCard(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(32),
      borderRadius: 24,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Sign in to your account',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Access your watchlist and sync across devices',
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              text: 'Sign In',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _buildSettingsSection(BuildContext context, WidgetRef ref) {
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);
    final selectedCurrency = ref.watch(selectedCurrencyProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Settings',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        GlassContainer(
          padding: EdgeInsets.zero,
          borderRadius: 20,
          child: Column(
            children: [
              _buildSettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: notificationsEnabled ? 'Enabled' : 'Disabled',
                trailing: Switch(
                  value: notificationsEnabled,
                  onChanged: (value) {
                    ref.read(notificationsEnabledProvider.notifier).state = value;
                  },
                  activeColor: AppColors.primary,
                ),
              ),
              const Divider(
                color: AppColors.glassBorder,
                height: 1,
                indent: 56,
              ),
              _buildSettingsTile(
                icon: Icons.currency_exchange,
                title: 'Currency',
                subtitle: '${selectedCurrency.code} (${selectedCurrency.symbol})',
                onTap: () => _showCurrencyPicker(context, ref),
              ),
              const Divider(
                color: AppColors.glassBorder,
                height: 1,
                indent: 56,
              ),
              _buildSettingsTile(
                icon: Icons.palette_outlined,
                title: 'Theme',
                subtitle: themeMode.label,
                onTap: () => _showThemePicker(context, ref),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Future<void> _showCurrencyPicker(BuildContext context, WidgetRef ref) async {
    final currentCurrency = ref.read(selectedCurrencyProvider);
    
    final selected = await showModalBottomSheet<Currency>(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _CurrencyPickerSheet(currentCurrency: currentCurrency),
    );

    if (selected != null) {
      ref.read(selectedCurrencyProvider.notifier).state = selected;
      // Refresh coins with new currency
      ref.invalidate(coinsProvider);
      ref.invalidate(watchlistCoinsProvider);
    }
  }

  Future<void> _showThemePicker(BuildContext context, WidgetRef ref) async {
    final currentTheme = ref.read(themeModeProvider);
    
    final selected = await showModalBottomSheet<AppThemeMode>(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _ThemePickerSheet(currentTheme: currentTheme),
    );

    if (selected != null) {
      ref.read(themeModeProvider.notifier).state = selected;
      if (context.mounted) {
        context.showSnackBar('Theme changed to ${selected.label}');
      }
    }
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.textSecondary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.textTertiary,
          fontSize: 12,
        ),
      ),
      trailing: trailing ??
          const Icon(
            Icons.chevron_right,
            color: AppColors.textTertiary,
          ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'About',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        GlassContainer(
          padding: EdgeInsets.zero,
          borderRadius: 20,
          child: Column(
            children: [
              _buildSettingsTile(
                icon: Icons.info_outline,
                title: 'Version',
                subtitle: '1.0.0',
              ),
              const Divider(
                color: AppColors.glassBorder,
                height: 1,
                indent: 56,
              ),
              _buildSettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                subtitle: 'Read our privacy policy',
                onTap: () {},
              ),
              const Divider(
                color: AppColors.glassBorder,
                height: 1,
                indent: 56,
              ),
              _buildSettingsTile(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                subtitle: 'Read our terms',
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: Column(
            children: [
              Text(
                'CryptoTracker',
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Powered by CoinGecko API',
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }
}

// Currency Picker Bottom Sheet
class _CurrencyPickerSheet extends StatelessWidget {
  final Currency currentCurrency;

  const _CurrencyPickerSheet({required this.currentCurrency});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.glassBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Select Currency',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...Currency.values.map((currency) => ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: currency == currentCurrency
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      currency.symbol,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: currency == currentCurrency
                            ? AppColors.primary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  currency.code,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: currency == currentCurrency
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
                subtitle: Text(
                  currency.name,
                  style: const TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                  ),
                ),
                trailing: currency == currentCurrency
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                onTap: () => Navigator.of(context).pop(currency),
              )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// Theme Picker Bottom Sheet
class _ThemePickerSheet extends StatelessWidget {
  final AppThemeMode currentTheme;

  const _ThemePickerSheet({required this.currentTheme});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.glassBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Select Theme',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...AppThemeMode.values.map((theme) {
            final icon = switch (theme) {
              AppThemeMode.dark => Icons.dark_mode,
              AppThemeMode.light => Icons.light_mode,
              AppThemeMode.system => Icons.settings_suggest,
            };
            
            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme == currentTheme
                      ? AppColors.primary.withValues(alpha: 0.2)
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: theme == currentTheme
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),
              title: Text(
                theme.label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: theme == currentTheme
                      ? AppColors.primary
                      : AppColors.textPrimary,
                ),
              ),
              trailing: theme == currentTheme
                  ? const Icon(Icons.check_circle, color: AppColors.primary)
                  : null,
              onTap: () => Navigator.of(context).pop(theme),
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
