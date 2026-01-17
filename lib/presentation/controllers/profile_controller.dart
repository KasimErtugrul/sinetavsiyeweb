import 'package:get/get.dart';
import '../../core/utils/logger.dart';
import '../../data/repositories/profile_repository.dart';
import '../../domain/entities/movie_entity.dart';
import 'auth_controller.dart';

enum ProfileViewState { initial, loading, success, error }

class ProfileController extends GetxController {
  final ProfileRepository _profileRepository = ProfileRepository();
  final AuthController _authController = Get.find<AuthController>();

  final _viewState = ProfileViewState.initial.obs;
  final _profile = Rxn<ProfileEntity>();
  final _errorMessage = ''.obs;
  final _isEditing = false.obs;

  ProfileViewState get viewState => _viewState.value;
  ProfileEntity? get profile => _profile.value;
  String get errorMessage => _errorMessage.value;
  bool get isEditing => _isEditing.value;
  bool get isOwnProfile => _authController.currentUserId == profile?.id;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile({String? userId}) async {
    try {
      _viewState.value = ProfileViewState.loading;
      
      final targetUserId = userId ?? _authController.currentUserId;
      if (targetUserId == null) {
        _errorMessage.value = 'Kullanıcı bulunamadı';
        _viewState.value = ProfileViewState.error;
        return;
      }

      AppLogger.info('Loading profile: $targetUserId');

      final result = await _profileRepository.getProfile(targetUserId);

      result.fold(
        (failure) {
          _errorMessage.value = failure.message;
          _viewState.value = ProfileViewState.error;
        },
        (profile) {
          _profile.value = profile;
          _viewState.value = ProfileViewState.success;
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load profile', e, stackTrace);
      _errorMessage.value = 'Profil yüklenemedi';
      _viewState.value = ProfileViewState.error;
    }
  }

  Future<bool> updateProfile({
    String? fullName,
    String? bio,
    String? avatarUrl,
  }) async {
    if (_authController.currentUserId == null) return false;

    try {
      final result = await _profileRepository.updateProfile(
        userId: _authController.currentUserId!,
        fullName: fullName,
        bio: bio,
        avatarUrl: avatarUrl,
      );

      return result.fold(
        (failure) {
          Get.snackbar('Hata', failure.message);
          return false;
        },
        (_) {
          Get.snackbar('Başarılı', 'Profil güncellendi');
          loadProfile();
          return true;
        },
      );
    } catch (e) {
      Get.snackbar('Hata', 'Profil güncellenemedi');
      return false;
    }
  }

  void startEditing() => _isEditing.value = true;
  void cancelEditing() => _isEditing.value = false;
}
