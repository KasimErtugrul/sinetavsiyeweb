import 'package:equatable/equatable.dart';

// Movie Entity
class MovieEntity extends Equatable {
  final int id;
  final String title;
  final String? originalTitle;
  final String? overview;
  final String? tagline;
  final String? posterPath;
  final String? backdropPath;
  final DateTime? releaseDate;
  final int? runtime;
  final List<String> genres;
  final double? tmdbVoteAverage;
  final int? tmdbVoteCount;
  final double? platformRating;
  final int platformRatingCount;
  final CategoryEntity? category;
  final String? adminNote;
  final DateTime createdAt;
  
  // Flattened category fields (from view)
  final int? categoryId;
  final String? categoryName;
  final String? categorySlug;
  final String? categoryDescription;
  final String? categoryColor;
  
  // Stats
  final int viewCount;
  final int commentCount;
  final int likeCount;
  final int dislikeCount;
  final int listCount;
  final int watchlistCount;

  const MovieEntity({
    required this.id,
    required this.title,
    this.originalTitle,
    this.overview,
    this.tagline,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.runtime,
    this.genres = const [],
    this.tmdbVoteAverage,
    this.tmdbVoteCount,
    this.platformRating,
    this.platformRatingCount = 0,
    this.category,
    this.adminNote,
    required this.createdAt,
    this.categoryId,
    this.categoryName,
    this.categorySlug,
    this.categoryDescription,
    this.categoryColor,
    this.viewCount = 0,
    this.commentCount = 0,
    this.likeCount = 0,
    this.dislikeCount = 0,
    this.listCount = 0,
    this.watchlistCount = 0,
  });

  String get fullPosterUrl => posterPath != null 
      ? 'https://image.tmdb.org/t/p/w500$posterPath'
      : '';
      
  String get fullBackdropUrl => backdropPath != null
      ? 'https://image.tmdb.org/t/p/w1280$backdropPath'
      : '';
      
  String get releaseYear => releaseDate?.year.toString() ?? 'N/A';

  @override
  List<Object?> get props => [
    id, title, originalTitle, overview, posterPath, backdropPath,
    releaseDate, runtime, genres, tmdbVoteAverage, platformRating,
    category, createdAt, categoryId, categoryName,
  ];
}

// Profile Entity
class ProfileEntity extends Equatable {
  final String id;
  final String username;
  final String? fullName;
  final String? avatarUrl;
  final String? bio;
  final String role;
  final bool isBanned;
  final bool isMuted;
  final int followersCount;
  final int followingCount;
  final int listsCount;
  final int commentsCount;
  final DateTime createdAt;

  const ProfileEntity({
    required this.id,
    required this.username,
    this.fullName,
    this.avatarUrl,
    this.bio,
    required this.role,
    this.isBanned = false,
    this.isMuted = false,
    this.followersCount = 0,
    this.followingCount = 0,
    this.listsCount = 0,
    this.commentsCount = 0,
    required this.createdAt,
  });

  bool get isAdmin => role == 'admin';

  @override
  List<Object?> get props => [
    id, username, fullName, avatarUrl, bio, role,
    isBanned, isMuted, followersCount, followingCount,
    listsCount, commentsCount, createdAt,
  ];
}

// Comment Entity
class CommentEntity extends Equatable {
  final int id;
  final String userId;
  final int movieId;
  final int? parentId;
  final String content;
  final bool isEdited;
  final bool isDeleted;
  final int likeCount;
  final int replyCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProfileEntity? user;

  const CommentEntity({
    required this.id,
    required this.userId,
    required this.movieId,
    this.parentId,
    required this.content,
    this.isEdited = false,
    this.isDeleted = false,
    this.likeCount = 0,
    this.replyCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  @override
  List<Object?> get props => [
    id, userId, movieId, parentId, content, isEdited,
    isDeleted, likeCount, replyCount, createdAt, updatedAt,
  ];
}

// List Entity
class ListEntity extends Equatable {
  final int id;
  final String userId;
  final String title;
  final String? description;
  final String? coverImage;
  final bool isPublic;
  final bool isFeatured;
  final int likeCount;
  final int itemCount;
  final int viewCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProfileEntity? user;
  final List<MovieEntity>? movies;

  const ListEntity({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.coverImage,
    this.isPublic = true,
    this.isFeatured = false,
    this.likeCount = 0,
    this.itemCount = 0,
    this.viewCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.movies,
  });

  @override
  List<Object?> get props => [
    id, userId, title, description, isPublic, isFeatured,
    likeCount, itemCount, viewCount, createdAt, updatedAt,
  ];
}

// Category Entity
class CategoryEntity extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String? description;
  final String? colorHex;
  final DateTime? createdAt;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.colorHex,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, slug, description, colorHex, createdAt];
}


// Notification Entity
class NotificationEntity extends Equatable {
  final int id;
  final String userId;
  final String? actorId;
  final String type;
  final bool isRead;
  final DateTime? readAt;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final ProfileEntity? actor;

  const NotificationEntity({
    required this.id,
    required this.userId,
    this.actorId,
    required this.type,
    this.isRead = false,
    this.readAt,
    this.metadata = const {},
    required this.createdAt,
    this.actor,
  });

  @override
  List<Object?> get props => [
    id, userId, actorId, type, isRead, readAt, metadata, createdAt,
  ];
}