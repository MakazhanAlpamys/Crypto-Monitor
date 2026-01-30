import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/localization/app_localizations.dart';
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
    final isGuest = ref.watch(isGuestModeProvider);
    final user = ref.watch(currentUserProvider);
    final l10n = ref.watch(localizationProvider);

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
                _buildHeader(context, l10n),
                const SizedBox(height: 32),
                // Profile card or sign in prompt
                isAuthenticated
                    ? _buildProfileCard(context, ref, user, l10n)
                    : isGuest
                        ? _buildGuestCard(context, ref, l10n)
                        : _buildSignInCard(context, l10n),
                const SizedBox(height: 24),
                // Settings section
                _buildSettingsSection(context, ref, l10n),
                const SizedBox(height: 24),
                // About section
                _buildAboutSection(context, l10n),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.get('profile'),
              style: context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.get('manageYourAccount'),
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildProfileCard(BuildContext context, WidgetRef ref, dynamic user, AppLocalizations l10n) {
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
                Text(
                  l10n.get('signedIn'),
                  style: const TextStyle(
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
              onPressed: () => _showSignOutDialog(context, ref, l10n),
              icon: const Icon(Icons.logout, size: 18),
              label: Text(l10n.get('signOut')),
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

  Widget _buildGuestCard(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
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
              color: AppColors.surfaceLight,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.glassBorder, width: 2),
            ),
            child: const Center(
              child: Icon(
                Icons.visibility_outlined,
                color: AppColors.textSecondary,
                size: 36,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.get('guestMode'),
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.warning,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.get('guestMode'),
                  style: const TextStyle(
                    color: AppColors.warning,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.get('accessWatchlist'),
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Sign in button
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              text: l10n.get('signIn'),
              onPressed: () {
                ref.read(isGuestModeProvider.notifier).state = false;
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

  Future<void> _showSignOutDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(l10n.get('signOut')),
        content: Text(l10n.get('signOutConfirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.get('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              l10n.get('signOut'),
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(authNotifierProvider.notifier).signOut();
    }
  }

  Widget _buildSignInCard(BuildContext context, AppLocalizations l10n) {
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
            l10n.get('signInToAccount'),
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.get('accessWatchlist'),
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              text: l10n.get('signIn'),
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

  Widget _buildSettingsSection(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);
    final themeMode = ref.watch(themeModeProvider);
    final currentLanguage = ref.watch(languageProvider);

    final themeLabel = switch (themeMode) {
      AppThemeMode.dark => l10n.get('dark'),
      AppThemeMode.light => l10n.get('light'),
      AppThemeMode.system => l10n.get('system'),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            l10n.get('settings'),
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
                title: l10n.get('notifications'),
                subtitle: notificationsEnabled ? l10n.get('enabled') : l10n.get('disabled'),
                trailing: Switch(
                  value: notificationsEnabled,
                  onChanged: (value) {
                    ref.read(notificationsEnabledProvider.notifier).state = value;
                  },
                  activeThumbColor: AppColors.primary,
                ),
              ),
              const Divider(
                color: AppColors.glassBorder,
                height: 1,
                indent: 56,
              ),
              _buildSettingsTile(
                icon: Icons.language_outlined,
                title: l10n.get('language'),
                subtitle: currentLanguage.name,
                onTap: () => _showLanguagePicker(context, ref, l10n),
              ),
              const Divider(
                color: AppColors.glassBorder,
                height: 1,
                indent: 56,
              ),
              _buildSettingsTile(
                icon: Icons.palette_outlined,
                title: l10n.get('theme'),
                subtitle: themeLabel,
                onTap: () => _showThemePicker(context, ref, l10n),
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms);
  }

  Future<void> _showLanguagePicker(BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    final currentLanguage = ref.read(languageProvider);
    
    final selected = await showModalBottomSheet<AppLanguage>(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _LanguagePickerSheet(
        currentLanguage: currentLanguage,
        title: l10n.get('selectLanguage'),
      ),
    );

    if (selected != null) {
      ref.read(languageProvider.notifier).state = selected;
    }
  }

  Future<void> _showThemePicker(BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    final currentTheme = ref.read(themeModeProvider);
    
    final selected = await showModalBottomSheet<AppThemeMode>(
      context: context,
      backgroundColor: AppColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _ThemePickerSheet(
        currentTheme: currentTheme,
        l10n: l10n,
      ),
    );

    if (selected != null) {
      ref.read(themeModeProvider.notifier).state = selected;
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

  Widget _buildAboutSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            l10n.get('about'),
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
                title: l10n.get('version'),
                subtitle: '1.0.0',
              ),
              const Divider(
                color: AppColors.glassBorder,
                height: 1,
                indent: 56,
              ),
              _buildSettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: l10n.get('privacyPolicy'),
                subtitle: l10n.get('readPrivacyPolicy'),
                onTap: () {},
              ),
              const Divider(
                color: AppColors.glassBorder,
                height: 1,
                indent: 56,
              ),
              _buildSettingsTile(
                icon: Icons.description_outlined,
                title: l10n.get('termsOfService'),
                subtitle: l10n.get('readTerms'),
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
                l10n.get('poweredBy'),
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

// Language Picker Bottom Sheet
class _LanguagePickerSheet extends StatelessWidget {
  final AppLanguage currentLanguage;
  final String title;

  const _LanguagePickerSheet({
    required this.currentLanguage,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
              title,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...AppLanguage.values.map((language) {
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: language == currentLanguage
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      language.flag,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                title: Text(
                  language.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: language == currentLanguage
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
                trailing: language == currentLanguage
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                onTap: () => Navigator.of(context).pop(language),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// Theme Picker Bottom Sheet
class _ThemePickerSheet extends StatelessWidget {
  final AppThemeMode currentTheme;
  final AppLocalizations l10n;

  const _ThemePickerSheet({
    required this.currentTheme,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
              l10n.get('selectTheme'),
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
              final label = switch (theme) {
                AppThemeMode.dark => l10n.get('dark'),
                AppThemeMode.light => l10n.get('light'),
                AppThemeMode.system => l10n.get('system'),
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
                  label,
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
          ],
        ),
      ),
    );
  }
}
