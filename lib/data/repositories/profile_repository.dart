import 'package:dartz/dartz.dart';
import '../../core/network/supabase_client.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/movie_entity.dart';

class ProfileRepository {
  final _client = SupabaseService.client;

  // Get Profile by User ID
  Future<Either<Failure, ProfileEntity>> getProfile(String userId) async {
    try {
      AppLogger.info('Fetching profile: $userId');

      final response = await _client
          .from('profiles')
          .select('*')
          .eq('id', userId)
          .single();

      final profile = ProfileModel.fromJson(response);
      AppLogger.info('Profile fetched: ${profile.username}');
      
      return Right(profile);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch profile', e, stackTrace);
      return Left(Failure('Profil yüklenemedi'));
    }
  }

  // Update Profile
  Future<Either<Failure, void>> updateProfile({
    required String userId,
    String? fullName,
    String? bio,
    String? avatarUrl,
  }) async {
    try {
      AppLogger.info('Updating profile: $userId');

      final updates = <String, dynamic>{};
      if (fullName != null) updates['full_name'] = fullName;
      if (bio != null) updates['bio'] = bio;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      updates['updated_at'] = DateTime.now().toIso8601String();

      await _client
          .from('profiles')
          .update(updates)
          .eq('id', userId);

      AppLogger.info('Profile updated successfully');
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to update profile', e, stackTrace);
      return Left(Failure('Profil güncellenemedi'));
    }
  }

  // Get User's Lists
  Future<Either<Failure, List<dynamic>>> getUserLists(String userId) async {
    try {
      final response = await _client
          .from('lists')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return Right(response as List);
    } catch (e) {
      return Left(Failure('Listeler yüklenemedi'));
    }
  }

  // Get User's Comments
  Future<Either<Failure, List<dynamic>>> getUserComments(String userId) async {
    try {
      final response = await _client
          .from('comments')
          .select('*, movies(*)')
          .eq('user_id', userId)
          .eq('is_deleted', false)
          .order('created_at', ascending: false)
          .limit(20);

      return Right(response as List);
    } catch (e) {
      return Left(Failure('Yorumlar yüklenemedi'));
    }
  }
}

class Failure {
  final String message;
  Failure(this.message);
}

// Profile Model
class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required String id,
    required String username,
    String? fullName,
    String? avatarUrl,
    String? bio,
    String role = 'user',
    bool isBanned = false,
    bool isMuted = false,
    required int followersCount,
    required int followingCount,
    required int listsCount,
    required int commentsCount,
    required DateTime createdAt,
  }) : super(
          id: id,
          username: username,
          fullName: fullName,
          avatarUrl: avatarUrl,
          bio: bio,
          role: role,
          isBanned: isBanned,
          isMuted: isMuted,
          followersCount: followersCount,
          followingCount: followingCount,
          listsCount: listsCount,
          commentsCount: commentsCount,
          createdAt: createdAt,
        );

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      username: json['username'] as String,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      role: json['role'] as String? ?? 'user',
      isBanned: json['is_banned'] as bool? ?? false,
      isMuted: json['is_muted'] as bool? ?? false,
      followersCount: json['followers_count'] as int? ?? 0,
      followingCount: json['following_count'] as int? ?? 0,
      listsCount: json['lists_count'] as int? ?? 0,
      commentsCount: json['comments_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
