import 'package:supabase_flutter/supabase_flutter.dart';
import '../network/supabase_client.dart';
import '../utils/logger.dart';

class AuthService {
  final _client = SupabaseService.client;

  // Current User
  User? get currentUser => _client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;
  String? get currentUserId => currentUser?.id;

  // Auth State Stream
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // Sign Up
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
    String? fullName,
  }) async {
    try {
      AppLogger.info('Signing up user: $email');

      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username,
          'full_name': fullName,
        },
      );

      if (response.user != null) {
        AppLogger.info('User signed up successfully: ${response.user!.id}');
      }

      return response;
    } catch (e, stackTrace) {
      AppLogger.error('Sign up failed', e, stackTrace);
      rethrow;
    }
  }

  // Sign In
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.info('Signing in user: $email');

      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        AppLogger.info('User signed in successfully: ${response.user!.id}');
      }

      return response;
    } catch (e, stackTrace) {
      AppLogger.error('Sign in failed', e, stackTrace);
      rethrow;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      AppLogger.info('Signing out user');
      await _client.auth.signOut();
      AppLogger.info('User signed out successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Sign out failed', e, stackTrace);
      rethrow;
    }
  }

  // Reset Password
  Future<void> resetPassword({required String email}) async {
    try {
      AppLogger.info('Sending password reset email to: $email');
      await _client.auth.resetPasswordForEmail(email);
      AppLogger.info('Password reset email sent successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Password reset failed', e, stackTrace);
      rethrow;
    }
  }

  // Update User Data in Supabase Auth
  Future<UserResponse> updateAuthData({
    String? fullName,
    String? avatarUrl,
  }) async {
    try {
      AppLogger.info('Updating auth user data');

      final updates = <String, dynamic>{};
      if (fullName != null) updates['full_name'] = fullName;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      final response = await _client.auth.updateUser(
        UserAttributes(data: updates),
      );

      AppLogger.info('Auth data updated successfully');
      return response;
    } catch (e, stackTrace) {
      AppLogger.error('Auth data update failed', e, stackTrace);
      rethrow;
    }
  }

  // Get Session
  Session? get currentSession => _client.auth.currentSession;

  // Refresh Session
  Future<AuthResponse> refreshSession() async {
    try {
      AppLogger.info('Refreshing session');
      final response = await _client.auth.refreshSession();
      AppLogger.info('Session refreshed successfully');
      return response;
    } catch (e, stackTrace) {
      AppLogger.error('Session refresh failed', e, stackTrace);
      rethrow;
    }
  }
}
