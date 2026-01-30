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

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authNotifierProvider.notifier).signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    if (mounted) {
      if (success) {
        final authState = ref.read(authNotifierProvider);
        if (authState.status == AuthStatus.authenticated) {
          // User is auto-logged in (email confirmation disabled)
          context.showSnackBar('Account created successfully!');
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          // Email confirmation required
          context.showSnackBar('Account created! Check your email to verify.');
          Navigator.of(context).pop();
        }
      } else {
        final error = ref.read(authNotifierProvider).errorMessage;
        context.showSnackBar(error ?? 'Sign up failed', isError: true);
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
                  // Top row with back button and language switcher
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
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
                            size: 20,
                          ),
                        ),
                      ),
                      _buildLanguageSwitcher(currentLanguage),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Header
                  _buildHeader(l10n),
                  const SizedBox(height: 48),
                  // Sign up form
                  _buildSignUpForm(isLoading, l10n),
                  const SizedBox(height: 24),
                  // Sign in link
                  _buildSignInLink(l10n),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSwitcher(AppLanguage currentLanguage) {
    return PopupMenuButton<AppLanguage>(
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
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Column(
      children: [
        // Icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.gradientBlueStart,
                AppColors.gradientBlueEnd,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.gradientBlueStart.withValues(alpha: 0.4),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.person_add_outlined,
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
          l10n.get('createAccount'),
          style: context.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
        const SizedBox(height: 8),
        Text(
          l10n.get('startTracking'),
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
      ],
    );
  }

  Widget _buildSignUpForm(bool isLoading, AppLocalizations l10n) {
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
              if (!value.contains('@') || !value.contains('.')) {
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
            textInputAction: TextInputAction.next,
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
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _confirmPasswordController,
            hintText: l10n.get('confirmPassword'),
            obscureText: true,
            textInputAction: TextInputAction.done,
            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textTertiary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.get('pleaseConfirmPassword');
              }
              if (value != _passwordController.text) {
                return l10n.get('passwordsDoNotMatch');
              }
              return null;
            },
            onSubmitted: (_) => _handleSignUp(),
          ),
          const SizedBox(height: 24),
          // Password requirements
          _buildPasswordRequirements(l10n),
          const SizedBox(height: 24),
          GradientButton(
            text: l10n.get('createAccount'),
            isLoading: isLoading,
            onPressed: isLoading ? null : _handleSignUp,
            gradient: const LinearGradient(
              colors: [
                AppColors.gradientBlueStart,
                AppColors.gradientBlueEnd,
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 600.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildPasswordRequirements(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.get('passwordMustContain'),
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          _buildRequirementRow(l10n.get('atLeast6Chars')),
          _buildRequirementRow(l10n.get('mixOfLettersNumbers')),
        ],
      ),
    );
  }

  Widget _buildRequirementRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 14,
            color: AppColors.textTertiary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: context.textTheme.bodySmall?.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInLink(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.get('alreadyHaveAccount'),
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            l10n.get('signIn'),
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
