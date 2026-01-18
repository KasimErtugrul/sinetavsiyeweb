// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

// Movie Entity

class MovieEntity extends Equatable {
  final int? id;                    // genelde backend'den gelir → nullable ama genelde dolu
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? addedBy;

  // TMDB temel bilgiler
  final int? tmdbId;
  final String? imdbId;
  final String? title;
  final String? originalTitle;
  final String? overview;
  final String? tagline;
  final String? posterPath;
  final String? backdropPath;
  final DateTime? releaseDate;
  final int? runtime;

  // Detaylı listeler
  final List<MoviesGenreEntity>? genres;                    // detaylı genre objeleri
  final List<String>? genreNames;                           // sadece isimler (isteğe bağlı flattened)
  final List<MovieProductionCountryEntity>? productionCountries;
  final List<MovieSpokenLanguageEntity>? spokenLanguages;

  // Oy & popülerlik
  final double? tmdbVoteAverage;
  final int? tmdbVoteCount;
  final double? tmdbPopularity;

  // Platforma özgü
  final int? platformRating;
  final int? platformRatingCount;
  final bool? isActive;
  final String? adminNote;

  // Category (hem obje hem flattened alanlar)
  final int? categoryId;
  final MoviesCategoryEntity? category;
  final String? categoryName;
  final String? categorySlug;
  final String? categoryDescription;
  final String? categoryColor;

  // Movie stats (flattened – MovieStats objesi yerine direkt alanlar)
  final int? viewCount;
  final int? commentCount;
  final int? likeCount;
  final int? dislikeCount;
  final int? listCount;
  final int? watchlistCount;

  final Map? credits;
    final Map? images;

  const MovieEntity({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.addedBy,
    this.tmdbId,
    this.imdbId,
    this.title,
    this.originalTitle,
    this.overview,
    this.tagline,
    this.posterPath,
    this.backdropPath,
    this.releaseDate,
    this.runtime,
    this.genres,
    this.genreNames,
    this.productionCountries,
    this.spokenLanguages,
    this.tmdbVoteAverage,
    this.tmdbVoteCount,
    this.tmdbPopularity,
    this.platformRating,
    this.platformRatingCount = 0,
    this.isActive,
    this.categoryId,
    this.adminNote,
    this.category,
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
    this.credits,
    this.images,
  });

  // ────────────────────────────────────────────────
  //               Getters (ikinci versiyondan)
  // ────────────────────────────────────────────────

  String get fullPosterUrl => posterPath != null
      ? 'https://image.tmdb.org/t/p/w500$posterPath'
      : '';

  String get fullBackdropUrl => backdropPath != null
      ? 'https://image.tmdb.org/t/p/w1280$backdropPath'
      : '';

  String get releaseYear => releaseDate?.year.toString() ?? 'N/A';

  // ────────────────────────────────────────────────
  //                    toJson
  // ────────────────────────────────────────────────

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'added_by': addedBy,
        'tmdb_id': tmdbId,
        'imdb_id': imdbId,
        'title': title,
        'original_title': originalTitle,
        'overview': overview,
        'tagline': tagline,
        'poster_path': posterPath,
        'backdrop_path': backdropPath,
        if (releaseDate != null)
          'release_date':
              '${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}',
        'runtime': runtime,
        'genres': genres?.map((g) => g.toJson()).toList() ?? genreNames ?? [],
        'production_countries': productionCountries?.map((c) => c.toJson()).toList() ?? [],
        'spoken_languages': spokenLanguages?.map((l) => l.toJson()).toList() ?? [],
        'tmdb_vote_average': tmdbVoteAverage,
        'tmdb_vote_count': tmdbVoteCount,
        'tmdb_popularity': tmdbPopularity,
        'platform_rating': platformRating,
        'platform_rating_count': platformRatingCount,
        'is_active': isActive,
        'category_id': categoryId,
        'admin_note': adminNote,
        'category': category?.toJson(),
        'category_name': categoryName,
        'category_slug': categorySlug,
        'category_description': categoryDescription,
        'category_color': categoryColor,
        'view_count': viewCount,
        'comment_count': commentCount,
        'like_count': likeCount,
        'dislike_count': dislikeCount,
        'list_count': listCount,
        'watchlist_count': watchlistCount,
        'credits': credits,
        'images': images,
      };

  // ────────────────────────────────────────────────
  //                   copyWith
  // ────────────────────────────────────────────────

  MovieEntity copyWith({
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? addedBy,
    int? tmdbId,
    String? imdbId,
    String? title,
    String? originalTitle,
    String? overview,
    String? tagline,
    String? posterPath,
    String? backdropPath,
    DateTime? releaseDate,
    int? runtime,
    List<MoviesGenreEntity>? genres,
    List<String>? genreNames,
    List<MovieProductionCountryEntity>? productionCountries,
    List<MovieSpokenLanguageEntity>? spokenLanguages,
    double? tmdbVoteAverage,
    int? tmdbVoteCount,
    double? tmdbPopularity,
    int? platformRating,
    int? platformRatingCount,
    bool? isActive,
    int? categoryId,
    String? adminNote,
    MoviesCategoryEntity? category,
    String? categoryName,
    String? categorySlug,
    String? categoryDescription,
    String? categoryColor,
    int? viewCount,
    int? commentCount,
    int? likeCount,
    int? dislikeCount,
    int? listCount,
    int? watchlistCount,
    Map<dynamic, dynamic>? credits,
    Map<dynamic, dynamic>? images,
  }) {
    return MovieEntity(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      addedBy: addedBy ?? this.addedBy,
      tmdbId: tmdbId ?? this.tmdbId,
      imdbId: imdbId ?? this.imdbId,
      title: title ?? this.title,
      originalTitle: originalTitle ?? this.originalTitle,
      overview: overview ?? this.overview,
      tagline: tagline ?? this.tagline,
      posterPath: posterPath ?? this.posterPath,
      backdropPath: backdropPath ?? this.backdropPath,
      releaseDate: releaseDate ?? this.releaseDate,
      runtime: runtime ?? this.runtime,
      genres: genres ?? this.genres,
      genreNames: genreNames ?? this.genreNames,
      productionCountries: productionCountries ?? this.productionCountries,
      spokenLanguages: spokenLanguages ?? this.spokenLanguages,
      tmdbVoteAverage: tmdbVoteAverage ?? this.tmdbVoteAverage,
      tmdbVoteCount: tmdbVoteCount ?? this.tmdbVoteCount,
      tmdbPopularity: tmdbPopularity ?? this.tmdbPopularity,
      platformRating: platformRating ?? this.platformRating,
      platformRatingCount: platformRatingCount ?? this.platformRatingCount,
      isActive: isActive ?? this.isActive,
      categoryId: categoryId ?? this.categoryId,
      adminNote: adminNote ?? this.adminNote,
      category: category ?? this.category,
      categoryName: categoryName ?? this.categoryName,
      categorySlug: categorySlug ?? this.categorySlug,
      categoryDescription: categoryDescription ?? this.categoryDescription,
      categoryColor: categoryColor ?? this.categoryColor,
      viewCount: viewCount ?? this.viewCount,
      commentCount: commentCount ?? this.commentCount,
      likeCount: likeCount ?? this.likeCount,
      dislikeCount: dislikeCount ?? this.dislikeCount,
      listCount: listCount ?? this.listCount,
      watchlistCount: watchlistCount ?? this.watchlistCount,
      credits: credits ?? this.credits,
      images: images ?? this.images,
    );
  }

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        addedBy,
        tmdbId,
        imdbId,
        title,
        originalTitle,
        overview,
        tagline,
        posterPath,
        backdropPath,
        releaseDate,
        runtime,
        genres,
        genreNames,
        productionCountries,
        spokenLanguages,
        tmdbVoteAverage,
        tmdbVoteCount,
        tmdbPopularity,
        platformRating,
        platformRatingCount,
        isActive,
        categoryId,
        adminNote,
        category,
        categoryName,
        categorySlug,
        categoryDescription,
        categoryColor,
        viewCount,
        commentCount,
        likeCount,
        dislikeCount,
        listCount,
        watchlistCount,
        credits,
        images,
      ];

  @override
  bool get stringify => true;
}

class MoviesCategoryEntity extends Equatable {
    final int? id;
    final String? name;
    final String? slug;
    final String? colorHex;
    final DateTime? createdAt;
    final String? description;

    const MoviesCategoryEntity({
        this.id,
        this.name,
        this.slug,
        this.colorHex,
        this.createdAt,
        this.description,
    });

    MoviesCategoryEntity copyWith({
        int? id,
        String? name,
        String? slug,
        String? colorHex,
        DateTime? createdAt,
        String? description,
    }) => 
        MoviesCategoryEntity(
            id: id ?? this.id,
            name: name ?? this.name,
            slug: slug ?? this.slug,
            colorHex: colorHex ?? this.colorHex,
            createdAt: createdAt ?? this.createdAt,
            description: description ?? this.description,
        );

factory MoviesCategoryEntity.fromJson(Map<String, dynamic> json) => MoviesCategoryEntity(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        colorHex: json["color_hex"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "color_hex": colorHex,
        "created_at": createdAt?.toIso8601String(),
        "description": description,
    };

  @override
  List<Object?> get props {
    return [
      id,
      name,
      slug,
      colorHex,
      createdAt,
      description,
    ];
  }
}

class MoviesGenreEntity extends Equatable {
    final int? id;
    final String? name;

    const MoviesGenreEntity({
        this.id,
        this.name,
    });

    MoviesGenreEntity copyWith({
        int? id,
        String? name,
    }) => 
        MoviesGenreEntity(
            id: id ?? this.id,
            name: name ?? this.name,
        );
 factory MoviesGenreEntity.fromJson(Map<String, dynamic> json) => MoviesGenreEntity(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
  @override
  List<Object?> get props => [id, name];
}

class MovieMovieStatsEntity extends Equatable {
    final int? movieId;
    final int? likeCount;
    final int? listCount;
    final DateTime? updatedAt;
    final int? viewCount;
    final int? commentCount;
    final int? dislikeCount;
    final DateTime? lastViewedAt;
    final int? watchlistCount;

    const MovieMovieStatsEntity({
        this.movieId,
        this.likeCount,
        this.listCount,
        this.updatedAt,
        this.viewCount,
        this.commentCount,
        this.dislikeCount,
        this.lastViewedAt,
        this.watchlistCount,
    });

    MovieMovieStatsEntity copyWith({
        int? movieId,
        int? likeCount,
        int? listCount,
        DateTime? updatedAt,
        int? viewCount,
        int? commentCount,
        int? dislikeCount,
        DateTime? lastViewedAt,
        int? watchlistCount,
    }) => 
        MovieMovieStatsEntity(
            movieId: movieId ?? this.movieId,
            likeCount: likeCount ?? this.likeCount,
            listCount: listCount ?? this.listCount,
            updatedAt: updatedAt ?? this.updatedAt,
            viewCount: viewCount ?? this.viewCount,
            commentCount: commentCount ?? this.commentCount,
            dislikeCount: dislikeCount ?? this.dislikeCount,
            lastViewedAt: lastViewedAt ?? this.lastViewedAt,
            watchlistCount: watchlistCount ?? this.watchlistCount,
        );

 factory MovieMovieStatsEntity.fromJson(Map<String, dynamic> json) => MovieMovieStatsEntity(
        movieId: json["movie_id"],
        likeCount: json["like_count"],
        listCount: json["list_count"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        viewCount: json["view_count"],
        commentCount: json["comment_count"],
        dislikeCount: json["dislike_count"],
        lastViewedAt: json["last_viewed_at"] == null ? null : DateTime.parse(json["last_viewed_at"]),
        watchlistCount: json["watchlist_count"],
    );

    Map<String, dynamic> toJson() => {
        "movie_id": movieId,
        "like_count": likeCount,
        "list_count": listCount,
        "updated_at": updatedAt?.toIso8601String(),
        "view_count": viewCount,
        "comment_count": commentCount,
        "dislike_count": dislikeCount,
        "last_viewed_at": lastViewedAt?.toIso8601String(),
        "watchlist_count": watchlistCount,
    };

  @override
  List<Object?> get props {
    return [
      movieId,
      likeCount,
      listCount,
      updatedAt,
      viewCount,
      commentCount,
      dislikeCount,
      lastViewedAt,
      watchlistCount,
    ];
  }
}

class MovieProductionCountryEntity extends Equatable {
    final String? name;
    final String? iso31661;

    const MovieProductionCountryEntity({
        this.name,
        this.iso31661,
    });

    MovieProductionCountryEntity copyWith({
        String? name,
        String? iso31661,
    }) => 
        MovieProductionCountryEntity(
            name: name ?? this.name,
            iso31661: iso31661 ?? this.iso31661,
        );

  factory MovieProductionCountryEntity.fromJson(Map<String, dynamic> json) => MovieProductionCountryEntity(
        name: json["name"],
        iso31661: json["iso_3166_1"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "iso_3166_1": iso31661,
    };

  @override
  List<Object?> get props => [name, iso31661];
}

class MovieSpokenLanguageEntity extends Equatable {
    final String? name;
    final String? iso6391;
    final String? englishName;

    const MovieSpokenLanguageEntity({
        this.name,
        this.iso6391,
        this.englishName,
    });

    MovieSpokenLanguageEntity copyWith({
        String? name,
        String? iso6391,
        String? englishName,
    }) => 
        MovieSpokenLanguageEntity(
            name: name ?? this.name,
            iso6391: iso6391 ?? this.iso6391,
            englishName: englishName ?? this.englishName,
        );

 factory MovieSpokenLanguageEntity.fromJson(Map<String, dynamic> json) => MovieSpokenLanguageEntity(
        name: json["name"],
        iso6391: json["iso_639_1"],
        englishName: json["english_name"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "iso_639_1": iso6391,
        "english_name": englishName,
    };

  @override
  List<Object?> get props => [name, iso6391, englishName];
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