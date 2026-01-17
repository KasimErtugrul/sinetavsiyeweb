import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_constants.dart';
import '../utils/logger.dart';

class SupabaseService {
  static SupabaseClient? _client;
  
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase client not initialized. Call initialize() first.');
    }
    return _client!;
  }
  
  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: AppConstants.supabaseUrl,
        anonKey: AppConstants.supabaseAnonKey,
      );
      _client = Supabase.instance.client;
      AppLogger.info('Supabase initialized successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Supabase initialization failed', e, stackTrace);
      rethrow;
    }
  }
  
  // Auth helpers
  static User? get currentUser => client.auth.currentUser;
  static String? get currentUserId => currentUser?.id;
  static bool get isAuthenticated => currentUser != null;
  
  // Sign in with email
  static Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      AppLogger.info('User signed in: ${response.user?.email}');
      return response;
    } catch (e, stackTrace) {
      AppLogger.error('Sign in failed', e, stackTrace);
      rethrow;
    }
  }
  
  // Sign up with email
  static Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String username,
    String? fullName,
  }) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username,
          'full_name': fullName,
        },
      );
      AppLogger.info('User signed up: ${response.user?.email}');
      return response;
    } catch (e, stackTrace) {
      AppLogger.error('Sign up failed', e, stackTrace);
      rethrow;
    }
  }
  
  // Sign out
  static Future<void> signOut() async {
    try {
      await client.auth.signOut();
      AppLogger.info('User signed out');
    } catch (e, stackTrace) {
      AppLogger.error('Sign out failed', e, stackTrace);
      rethrow;
    }
  }
  
  // Listen to auth state changes
  static Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
}