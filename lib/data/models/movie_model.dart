import '../../domain/entities/movie_entity.dart';

class MovieModel extends MovieEntity {
  const MovieModel({
    required super.id,
    required super.title,
    super.originalTitle,
    super.overview,
    super.tagline,
    super.posterPath,
    super.backdropPath,
    super.releaseDate,
    super.runtime,
    super.genres,
    super.tmdbVoteAverage,
    super.tmdbVoteCount,
    super.platformRating,
    super.platformRatingCount,
    super.category,
    super.adminNote,
    required super.createdAt,
    super.categoryId,
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
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int,
      title: json['title'] as String,
      originalTitle: json['original_title'] as String?,
      overview: json['overview'] as String?,
      tagline: json['tagline'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: json['release_date'] != null
          ? DateTime.parse(json['release_date'])
          : null,
      runtime: json['runtime'] as int?,
      genres: json['genres'] != null
          ? (json['genres'] as List).map((e) => e.toString()).toList()
          : [],
      tmdbVoteAverage: json['tmdb_vote_average'] != null
          ? (json['tmdb_vote_average'] as num).toDouble()
          : null,
      tmdbVoteCount: json['tmdb_vote_count'] as int?,
      platformRating: json['platform_rating'] != null
          ? (json['platform_rating'] as num).toDouble()
          : null,
      platformRatingCount: json['platform_rating_count'] as int? ?? 0,
      category: json['category_id'] != null && json['category_name'] != null
          ? CategoryModel.fromJson({
              'id': json['category_id'],
              'name': json['category_name'],
              'slug': json['category_slug'] ?? '',
              'description': json['category_description'],
              'color_hex': json['category_color'],
            })
          : null,
      adminNote: json['admin_note'] as String?,
      createdAt: DateTime.parse(json['created_at']),
      categoryId: json['category_id'] as int?,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'original_title': originalTitle,
      'overview': overview,
      'tagline': tagline,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate?.toIso8601String(),
      'runtime': runtime,
      'genres': genres,
      'tmdb_vote_average': tmdbVoteAverage,
      'tmdb_vote_count': tmdbVoteCount,
      'platform_rating': platformRating,
      'platform_rating_count': platformRatingCount,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

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

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
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
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
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

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      movieId: json['movie_id'] as int,
      parentId: json['parent_id'] as int?,
      content: json['content'] as String,
      isEdited: json['is_edited'] as bool? ?? false,
      isDeleted: json['is_deleted'] as bool? ?? false,
      likeCount: json['like_count'] as int? ?? 0,
      replyCount: json['reply_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: json['profiles'] != null
          ? ProfileModel.fromJson(json['profiles'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
}

class ListModel extends ListEntity {
  const ListModel({
    required super.id,
    required super.userId,
    required super.title,
    super.description,
    super.coverImage,
    super.isPublic,
    super.isFeatured,
    super.likeCount,
    super.itemCount,
    super.viewCount,
    required super.createdAt,
    required super.updatedAt,
    super.user,
    super.movies,
  });

  factory ListModel.fromJson(Map<String, dynamic> json) {
    return ListModel(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      coverImage: json['cover_image'] as String?,
      isPublic: json['is_public'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      likeCount: json['like_count'] as int? ?? 0,
      itemCount: json['item_count'] as int? ?? 0,
      viewCount: json['view_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: json['profiles'] != null
          ? ProfileModel.fromJson(json['profiles'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'cover_image': coverImage,
      'is_public': isPublic,
      'is_featured': isFeatured,
      'like_count': likeCount,
      'item_count': itemCount,
      'view_count': viewCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.slug,
    super.description,
    super.colorHex,
    super.createdAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      colorHex: json['color_hex'] as String?,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'color_hex': colorHex,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}