import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'providers/providers.dart';
import 'providers/auth_notifier.dart';
import 'ui/pages/home/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0D0D0F),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Supabase
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  runApp(
    const ProviderScope(
      child: CryptoApp(),
    ),
  );
}

class CryptoApp extends ConsumerWidget {
  const CryptoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    
    return MaterialApp(
      title: 'CryptoTracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: switch (themeMode) {
        AppThemeMode.dark => ThemeMode.dark,
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.system => ThemeMode.system,
      },
      home: const AuthWrapper(),
    );
  }
}

/// Wrapper that handles auth state and shows appropriate screen
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    // Show loading while checking auth state
    if (authState.status == AuthStatus.initial) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Always show HomePage - auth is handled within the app
    // Users can browse market without signing in
    // Watchlist will prompt for sign in if needed
    return const HomePage();
  }
}
