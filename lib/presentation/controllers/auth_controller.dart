import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/logger.dart';
import '../../data/repositories/profile_repository.dart';
import '../../domain/entities/movie_entity.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final ProfileRepository _profileRepository = ProfileRepository();

  // State
  final _currentUser = Rxn<User>();
  final _currentProfile = Rxn<ProfileEntity>();
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;

  // Getters
  User? get currentUser => _currentUser.value;
  ProfileEntity? get currentProfile => _currentProfile.value;
  bool get isAuthenticated => currentUser != null;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  String? get currentUserId => currentUser?.id;

  @override
  void onInit() {
    super.onInit();
    _initAuthListener();
    _checkCurrentUser();
  }

  void _initAuthListener() {
    _authService.authStateChanges.listen((AuthState data) {
      _currentUser.value = data.session?.user;
      if (data.session?.user != null) {
        _loadUserProfile();
      } else {
        _currentProfile.value = null;
      }
    });
  }

  Future<void> _checkCurrentUser() async {
    try {
      final user = _authService.currentUser;
      if (user != null) {
        _currentUser.value = user;
        await _loadUserProfile();
      }
    } catch (e) {
      AppLogger.error('Failed to check current user', e);
    }
  }

  Future<void> _loadUserProfile() async {
    if (currentUserId == null) return;

    try {
      AppLogger.info('Loading profile for user: $currentUserId');
      
      final result = await _profileRepository.getProfile(currentUserId!);
      
      result.fold(
        (failure) {
          AppLogger.error('Failed to load profile: ${failure.message}');
        },
        (profile) {
          _currentProfile.value = profile;
          AppLogger.info('Profile loaded: ${profile.username}');
        },
      );
    } catch (e) {
      AppLogger.error('Failed to load user profile', e);
    }
  }

  // Sign Up
  Future<bool> signUp({
    required String email,
    required String password,
    required String username,
    String? fullName,
  }) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final response = await _authService.signUp(
        email: email,
        password: password,
        username: username,
        fullName: fullName,
      );

      if (response.user == null) {
        _errorMessage.value = 'Kayıt başarısız oldu';
        return false;
      }

      Get.snackbar(
        'Başarılı',
        'Hesabınız oluşturuldu! Email adresinizi doğrulayın.',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } on AuthException catch (e) {
      _errorMessage.value = _getAuthErrorMessage(e);
      Get.snackbar('Hata', _errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return false;
    } catch (e) {
      _errorMessage.value = 'Bir hata oluştu';
      Get.snackbar('Hata', _errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Sign In
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final response = await _authService.signIn(
        email: email,
        password: password,
      );

      if (response.user == null) {
        _errorMessage.value = 'Giriş başarısız oldu';
        return false;
      }

      Get.snackbar(
        'Hoş Geldiniz',
        'Başarıyla giriş yaptınız',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } on AuthException catch (e) {
      _errorMessage.value = _getAuthErrorMessage(e);
      Get.snackbar('Hata', _errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return false;
    } catch (e) {
      _errorMessage.value = 'Bir hata oluştu';
      Get.snackbar('Hata', _errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      _isLoading.value = true;
      await _authService.signOut();
      Get.offAllNamed('/');
      Get.snackbar(
        'Çıkış Yapıldı',
        'Başarıyla çıkış yaptınız',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Hata', 'Çıkış yapılırken bir hata oluştu', snackPosition: SnackPosition.BOTTOM);
    } finally {
      _isLoading.value = false;
    }
  }

  // Reset Password
  Future<bool> resetPassword({required String email}) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      await _authService.resetPassword(email: email);

      Get.snackbar(
        'Email Gönderildi',
        'Şifre sıfırlama linki email adresinize gönderildi',
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      _errorMessage.value = 'Email gönderilemedi';
      Get.snackbar('Hata', _errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  String _getAuthErrorMessage(AuthException error) {
    switch (error.message) {
      case 'Invalid login credentials':
        return 'Email veya şifre hatalı';
      case 'User already registered':
        return 'Bu email adresi zaten kayıtlı';
      case 'Email not confirmed':
        return 'Email adresinizi doğrulayın';
      default:
        return error.message;
    }
  }

  // Require Auth - Redirect to login if not authenticated
  bool requireAuth() {
    if (!isAuthenticated) {
      Get.toNamed('/auth/login');
      Get.snackbar(
        'Giriş Gerekli',
        'Bu işlem için giriş yapmanız gerekiyor',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return true;
  }
}
