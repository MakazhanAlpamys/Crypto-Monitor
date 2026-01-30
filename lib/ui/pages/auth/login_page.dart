import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../providers/providers.dart';
import '../../../providers/auth_notifier.dart';
import '../../widgets/common/gradient_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/glass_container.dart';
import 'signup_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authNotifierProvider.notifier).signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (mounted) {
      if (success) {
        context.showSnackBar('Welcome back!');
        // Close all auth screens and go back to main
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        final error = ref.read(authNotifierProvider).errorMessage;
        context.showSnackBar(error ?? 'Login failed', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.status == AuthStatus.loading;
    final l10n = ref.watch(localizationProvider);
    final currentLanguage = ref.watch(languageProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              Color(0xFF0F0F14),
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Language switcher
                  _buildLanguageSwitcher(currentLanguage),
                  const SizedBox(height: 40),
                  // Logo and title
                  _buildHeader(l10n),
                  const SizedBox(height: 48),
                  // Login form
                  _buildLoginForm(isLoading, l10n),
                  const SizedBox(height: 16),
                  // Guest mode
                  _buildGuestMode(l10n),
                  const SizedBox(height: 24),
                  // Sign up link
                  _buildSignUpLink(l10n),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSwitcher(AppLanguage currentLanguage) {
    return Align(
      alignment: Alignment.topRight,
      child: PopupMenuButton<AppLanguage>(
        initialValue: currentLanguage,
        onSelected: (language) {
          ref.read(languageProvider.notifier).state = language;
        },
        offset: const Offset(0, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: AppColors.surfaceDark,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                currentLanguage.flag,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 8),
              Text(
                currentLanguage.code.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
        itemBuilder: (context) => AppLanguage.values.map((language) {
          return PopupMenuItem<AppLanguage>(
            value: language,
            child: Row(
              children: [
                Text(language.flag, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 12),
                Text(
                  language.name,
                  style: TextStyle(
                    color: language == currentLanguage
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    fontWeight: language == currentLanguage
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                if (language == currentLanguage) ...[
                  const Spacer(),
                  const Icon(Icons.check, color: AppColors.primary, size: 18),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Column(
      children: [
        // App Icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.currency_bitcoin,
            color: Colors.white,
            size: 40,
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms)
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
        const SizedBox(height: 24),
        // Title
        Text(
          l10n.get('welcomeBack'),
          style: context.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
        const SizedBox(height: 8),
        Text(
          l10n.get('signInToContinue'),
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
      ],
    );
  }

  Widget _buildLoginForm(bool isLoading, AppLocalizations l10n) {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: _emailController,
            hintText: l10n.get('emailAddress'),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textTertiary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.get('pleaseEnterEmail');
              }
              if (!value.contains('@')) {
                return l10n.get('pleaseEnterValidEmail');
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _passwordController,
            hintText: l10n.get('password'),
            obscureText: true,
            textInputAction: TextInputAction.done,
            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textTertiary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.get('pleaseEnterPassword');
              }
              if (value.length < 6) {
                return l10n.get('passwordTooShort');
              }
              return null;
            },
            onSubmitted: (_) => _handleLogin(),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // TODO: Implement forgot password
              },
              child: Text(
                l10n.get('forgotPassword'),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          GradientButton(
            text: l10n.get('signIn'),
            isLoading: isLoading,
            onPressed: isLoading ? null : _handleLogin,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 600.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildGuestMode(AppLocalizations l10n) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider(color: AppColors.glassBorder)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.get('or'),
                style: const TextStyle(color: AppColors.textTertiary),
              ),
            ),
            const Expanded(child: Divider(color: AppColors.glassBorder)),
          ],
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {
            ref.read(isGuestModeProvider.notifier).state = true;
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          icon: const Icon(Icons.visibility_outlined),
          label: Text(l10n.get('continueAsGuest')),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            side: const BorderSide(color: AppColors.glassBorder),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 700.ms, duration: 600.ms);
  }

  Widget _buildSignUpLink(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.get('dontHaveAccount'),
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const SignUpPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            );
          },
          child: Text(
            l10n.get('signUp'),
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 800.ms, duration: 600.ms);
  }
}
