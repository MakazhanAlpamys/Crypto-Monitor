import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../../core/config/supabase_config.dart';

/// Repository for authentication operations
class AuthRepository {
  final SupabaseClient _client;

  AuthRepository({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Get current user
  User? get currentUser => _client.auth.currentUser;

  /// Check if user is logged in
  bool get isAuthenticated => currentUser != null;

  /// Get current user ID
  String? get currentUserId => currentUser?.id;

  /// Auth state changes stream
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw AuthRepositoryException(e.message);
    }
  }

  /// Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw AuthRepositoryException(e.message);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (e) {
      throw AuthRepositoryException(e.message);
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw AuthRepositoryException(e.message);
    }
  }

  /// Get user profile
  Future<UserModel?> getUserProfile() async {
    final userId = currentUserId;
    if (userId == null) return null;

    try {
      final response = await _client
          .from(SupabaseConfig.profilesTable)
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response != null) {
        return UserModel.fromJson(response);
      }
      return null;
    } catch (e) {
      throw AuthRepositoryException('Failed to load profile');
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? username,
    String? avatarUrl,
  }) async {
    final userId = currentUserId;
    if (userId == null) throw AuthRepositoryException('Not authenticated');

    try {
      await _client.from(SupabaseConfig.profilesTable).update({
        if (username != null) 'username': username,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);
    } catch (e) {
      throw AuthRepositoryException('Failed to update profile');
    }
  }
}

/// Custom exception for auth errors
class AuthRepositoryException implements Exception {
  final String message;
  AuthRepositoryException(this.message);

  @override
  String toString() => message;
}
