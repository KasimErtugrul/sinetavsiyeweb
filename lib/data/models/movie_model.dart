import 'dart:convert';
import '../../domain/entities/movie_entity.dart';

// JSON → List<MovieModel>
List<MovieModel> movieModelFromJson(String str) =>
    List<MovieModel>.from(json.decode(str).map((x) => MovieModel.fromJson(x)));

// List<MovieModel> → JSON
String movieModelToJson(List<MovieModel> data) =>
    json.encode(data.map((x) => x.toJson()).toList());

// ────────────────────────────────────────────────
// MovieModel - API'dan gelen veriyi MovieEntity'ye dönüştürür
// ────────────────────────────────────────────────

class MovieModel extends MovieEntity {
  const MovieModel({
    super.id,
    super.createdAt,
    super.updatedAt,
    super.addedBy,
    super.tmdbId,
    super.imdbId,
    super.title,
    super.originalTitle,
    super.overview,
    super.tagline,
    super.posterPath,
    super.backdropPath,
    super.releaseDate,
    super.runtime,
    super.genres,
    super.genreNames,
    super.productionCountries,
    super.spokenLanguages,
    super.tmdbVoteAverage,
    super.tmdbVoteCount,
    super.tmdbPopularity,
    super.platformRating,
    super.platformRatingCount,
    super.isActive,
    super.adminNote,
    super.categoryId,
    super.category,
    super.categoryName,
    super.categorySlug,
    super.categoryDescription,
    super.categoryColor,
    super.viewCount,
    super.commentCount,
    super.likeCount,
    super.dislikeCount,
    super.listCount,
    super.watchlistCount,
    super.credits,
    super.images,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int?,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
      addedBy: json['added_by'] as String?,
      tmdbId: json['tmdb_id'] as int?,
      imdbId: json['imdb_id'] as String?,
      title: json['title'] as String?,
      originalTitle: json['original_title'] as String?,
      overview: json['overview'] as String?,
      tagline: json['tagline'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: _parseDate(json['release_date']),
      runtime: json['runtime'] as int?,
      // genres varsa detaylı obje, yoksa genreNames'i doldurabiliriz
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => MoviesGenreEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      // Eğer backend genreNames göndermiyorsa, genres'den türetebiliriz (aşağıda yorumlu)
      genreNames: json['genre_names'] as List<String>? ??
          (json['genres'] as List<dynamic>?)
              ?.map((e) => (e as Map<String, dynamic>)['name'] as String?)
              .whereType<String>()
              .toList(),
      productionCountries: (json['production_countries'] as List<dynamic>?)
          ?.map((e) => MovieProductionCountryEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      spokenLanguages: (json['spoken_languages'] as List<dynamic>?)
          ?.map((e) => MovieSpokenLanguageEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      tmdbVoteAverage: (json['tmdb_vote_average'] as num?)?.toDouble(),
      tmdbVoteCount: json['tmdb_vote_count'] as int?,
      tmdbPopularity: (json['tmdb_popularity'] as num?)?.toDouble(),
      platformRating: json['platform_rating'] as int?,
      platformRatingCount: json['platform_rating_count'] as int? ?? 0,
      isActive: json['is_active'] as bool?,
      adminNote: json['admin_note'] as String?,
      categoryId: json['category_id'] as int?,
      category: json['category'] != null
          ? MoviesCategoryEntity.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      categoryName: json['category_name'] as String?,
      categorySlug: json['category_slug'] as String?,
      categoryDescription: json['category_description'] as String?,
      categoryColor: json['category_color'] as String?,
      viewCount: json['view_count'] as int? ?? 0,
      commentCount: json['comment_count'] as int? ?? 0,
      likeCount: json['like_count'] as int? ?? 0,
      dislikeCount: json['dislike_count'] as int? ?? 0,
      listCount: json['list_count'] as int? ?? 0,
      watchlistCount: json['watchlist_count'] as int? ?? 0,
      credits:  json['credits'] as Map<dynamic, dynamic>?,
      images:  json['images'] as Map<dynamic, dynamic>?,);
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null || value is! String) return null;
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }

  // toJson'u da Entity'dekiyle aynı tutmak için override edebilirsin ama zorunlu değil
  // istersen entity'deki toJson'u kullan, istersen burayı da aynı şekilde yaz:
  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    // ekstra bir şey eklemek istersen buraya yazabilirsin
    return map;
  }
}

// ────────────────────────────────────────────────
// Diğer model sınıfları (daha güvenli hale getirildi)
// ────────────────────────────────────────────────

class Category extends MoviesCategoryEntity {
  const Category({
    super.id,
    super.name,
    super.slug,
    super.colorHex,
    super.createdAt,
    super.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as int?,
        name: json['name'] as String?,
        slug: json['slug'] as String?,
        colorHex: json['color_hex'] as String?,
        createdAt: _parseDate(json['created_at']),
        description: json['description'] as String?,
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'slug': slug,
        'color_hex': colorHex,
        'created_at': createdAt?.toIso8601String(),
        'description': description,
      };
}

class Genre extends MoviesGenreEntity {
  const Genre({
    super.id,
    super.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json['id'] as int?,
        name: json['name'] as String?,
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class MovieStats extends MovieMovieStatsEntity {
  const MovieStats({
    super.movieId,
    super.likeCount,
    super.listCount,
    super.updatedAt,
    super.viewCount,
    super.commentCount,
    super.dislikeCount,
    super.lastViewedAt,
    super.watchlistCount,
  });

  factory MovieStats.fromJson(Map<String, dynamic> json) => MovieStats(
        movieId: json['movie_id'] as int?,
        likeCount: json['like_count'] as int?,
        listCount: json['list_count'] as int?,
        updatedAt: _parseDate(json['updated_at']),
        viewCount: json['view_count'] as int?,
        commentCount: json['comment_count'] as int?,
        dislikeCount: json['dislike_count'] as int?,
        lastViewedAt: _parseDate(json['last_viewed_at']),
        watchlistCount: json['watchlist_count'] as int?,
      );

  @override
  Map<String, dynamic> toJson() => {
        'movie_id': movieId,
        'like_count': likeCount,
        'list_count': listCount,
        'updated_at': updatedAt?.toIso8601String(),
        'view_count': viewCount,
        'comment_count': commentCount,
        'dislike_count': dislikeCount,
        'last_viewed_at': lastViewedAt?.toIso8601String(),
        'watchlist_count': watchlistCount,
      };
}

class ProductionCountry extends MovieProductionCountryEntity {
  const ProductionCountry({
    super.name,
    super.iso31661,
  });

  factory ProductionCountry.fromJson(Map<String, dynamic> json) => ProductionCountry(
        name: json['name'] as String?,
        iso31661: json['iso_3166_1'] as String?,
      );

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'iso_3166_1': iso31661,
      };
}

class SpokenLanguage extends MovieSpokenLanguageEntity {
  const SpokenLanguage({
    super.name,
    super.iso6391,
    super.englishName,
  });

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) => SpokenLanguage(
        name: json['name'] as String?,
        iso6391: json['iso_639_1'] as String?,
        englishName: json['english_name'] as String?,
      );

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'iso_639_1': iso6391,
        'english_name': englishName,
      };
}

// ────────────────────────────────────────────────
// Diğer modeller (Profile, Comment, List, CategoryModel)
// ────────────────────────────────────────────────

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.username,
    super.fullName,
    super.avatarUrl,
    super.bio,
    required super.role,
    super.isBanned,
    super.isMuted,
    super.followersCount,
    super.followingCount,
    super.listsCount,
    super.commentsCount,
    required super.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json['id'] as String,
        username: json['username'] as String,
        fullName: json['full_name'] as String?,
        avatarUrl: json['avatar_url'] as String?,
        bio: json['bio'] as String?,
        role: json['role'] as String,
        isBanned: json['is_banned'] as bool? ?? false,
        isMuted: json['is_muted'] as bool? ?? false,
        followersCount: json['followers_count'] as int? ?? 0,
        followingCount: json['following_count'] as int? ?? 0,
        listsCount: json['lists_count'] as int? ?? 0,
        commentsCount: json['comments_count'] as int? ?? 0,
        createdAt: _parseDate(json['created_at']) ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'full_name': fullName,
        'avatar_url': avatarUrl,
        'bio': bio,
        'role': role,
        'is_banned': isBanned,
        'is_muted': isMuted,
        'followers_count': followersCount,
        'following_count': followingCount,
        'lists_count': listsCount,
        'comments_count': commentsCount,
        'created_at': createdAt.toIso8601String(),
      };
}

class CommentModel extends CommentEntity {
  const CommentModel({
    required super.id,
    required super.userId,
    required super.movieId,
    super.parentId,
    required super.content,
    super.isEdited,
    super.isDeleted,
    super.likeCount,
    super.replyCount,
    required super.createdAt,
    required super.updatedAt,
    super.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json['id'] as int,
        userId: json['user_id'] as String,
        movieId: json['movie_id'] as int,
        parentId: json['parent_id'] as int?,
        content: json['content'] as String? ?? '',
        isEdited: json['is_edited'] as bool? ?? false,
        isDeleted: json['is_deleted'] as bool? ?? false,
        likeCount: json['like_count'] as int? ?? 0,
        replyCount: json['reply_count'] as int? ?? 0,
        createdAt: _parseDate(json['created_at']) ?? DateTime.now(),
        updatedAt: _parseDate(json['updated_at']) ?? DateTime.now(),
        user: json['profiles'] != null
            ? ProfileModel.fromJson(json['profiles'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'movie_id': movieId,
        'parent_id': parentId,
        'content': content,
        'is_edited': isEdited,
        'is_deleted': isDeleted,
        'like_count': likeCount,
        'reply_count': replyCount,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}

// ListModel ve CategoryModel için de benzer şekilde güvenli cast ve _parseDate kullanabilirsin

 DateTime? _parseDate(dynamic value) {
  if (value == null || value is! String) return null;
  return DateTime.tryParse(value);
}