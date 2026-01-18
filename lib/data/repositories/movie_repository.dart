
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/errors/failures.dart';
import '../../core/network/supabase_client.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/movie_entity.dart';
import '../models/movie_model.dart';

class MovieRepository {
  final client = SupabaseService.client;

  // Get all movies with stats
  Future<Either<Failure, List<MovieEntity>>> getMovies({
    int page = 1,
    int limit = 20,
    String? orderBy = 'created_at',
    bool ascending = false,
  }) async {
    try {
      AppLogger.info('Fetching movies: page=$page, limit=$limit');

      final response = await client
          .from('movies')
          .select('''
            *,
            category_id,
            category_name:categories!category_id(name),
            category_slug:categories!category_id(slug),
            category_description:categories!category_id(description),
            category_color:categories!category_id(color_hex),
            movie_stats(*)
          ''')
          .eq('is_active', true)
          .order(orderBy!, ascending: ascending)
          .range((page - 1) * limit, page * limit - 1);

      final movies = (response as List).map((json) {
        // Merge stats into movie JSON
        final movieJson = Map<String, dynamic>.from(json);
        if (json['movie_stats'] != null &&
            (json['movie_stats'] as List).isNotEmpty) {
          final stats = json['movie_stats'][0];
          movieJson['view_count'] = stats['view_count'] ?? 0;
          movieJson['comment_count'] = stats['comment_count'] ?? 0;
          movieJson['like_count'] = stats['like_count'] ?? 0;
          movieJson['dislike_count'] = stats['dislike_count'] ?? 0;
          movieJson['list_count'] = stats['list_count'] ?? 0;
          movieJson['watchlist_count'] = stats['watchlist_count'] ?? 0;
        }
        return MovieModel.fromJson(movieJson) as MovieEntity;
      }).toList();

      AppLogger.info('Fetched ${movies.length} movies');
      return Right(movies);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch movies', e, stackTrace);
      return Left(_handleError(e));
    }
  }

  // Get trending movies (from view)
  Future<Either<Failure, List<MovieEntity>>> getTrendingMovies({
    int limit = 20,
  }) async {
    try {
      AppLogger.info('Fetching trending movies');

      final response = await client
          .from('trending_movies')
          .select('*')
          .limit(limit);

      final movies = (response as List)
          .map((json) => MovieModel.fromJson(json) as MovieEntity)
          .toList();

      AppLogger.info('Fetched ${movies.length} trending movies');
      return Right(movies);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch trending movies', e, stackTrace);
      return Left(_handleError(e));
    }
  }

  // Get popular movies (from view)
  Future<Either<Failure, List<MovieEntity>>> getPopularMovies({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      AppLogger.info(
        'Fetching popular movies (limit: $limit, offset: $offset)',
      );

      final response = await client
          .from('popular_movies')
          .select('*')
          .order('popularity_score', ascending: false)
          .range(offset, offset + limit - 1);
      final movies = (response as List)
          .map((json) => MovieModel.fromJson(json) as MovieEntity)
          .toList();

      AppLogger.info('Fetched ${movies.length} popular movies');
      return Right(movies);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch popular movies', e, stackTrace);
      return Left(_handleError(e));
    }
  }

  // Get most commented movies (from view)
  Future<Either<Failure, List<MovieEntity>>> getMostCommentedMovies({
    int limit = 20,
  }) async {
    try {
      AppLogger.info('Fetching most commented movies');

      final response = await client
          .from('v_most_commented_movies')
          .select('*')
          .limit(limit);

      final movies = (response as List)
          .map((json) => MovieModel.fromJson(json) as MovieEntity)
          .toList();

      AppLogger.info('Fetched ${movies.length} most commented movies');
      return Right(movies);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch most commented movies', e, stackTrace);
      return Left(_handleError(e));
    }
  }

  // Get most viewed movies (from view)
  Future<Either<Failure, List<MovieEntity>>> getMostViewedMovies({
    int limit = 20,
  }) async {
    try {
      AppLogger.info('Fetching most viewed movies');

      final response = await client
          .from('v_most_viewed_movies')
          .select('*')
          .limit(limit);


      final movies = (response as List)
          .map((json) => MovieModel.fromJson(json) as MovieEntity)
          .toList();

      AppLogger.info('Fetched ${movies.length} most viewed movies');
      return Right(movies);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch most viewed movies', e, stackTrace);
      return Left(_handleError(e));
    }
  }

  // Get top rated movies (from view)
  Future<Either<Failure, List<MovieEntity>>> getTopRatedMovies({
    int limit = 20,
  }) async {
    try {
      AppLogger.info('Fetching top rated movies');

      final response = await client
          .from('v_top_rated_movies')
          .select('*')
          .limit(limit);

      final movies = (response as List)
          .map((json) => MovieModel.fromJson(json) as MovieEntity)
          .toList();

      AppLogger.info('Fetched ${movies.length} top rated movies');
      return Right(movies);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch top rated movies', e, stackTrace);
      return Left(_handleError(e));
    }
  }

  // Get controversial movies (from view)
  Future<Either<Failure, List<MovieEntity>>> getControversialMovies({
    int limit = 20,
  }) async {
    try {
      AppLogger.info('Fetching controversial movies');

      final response = await client
          .from('v_controversial_movies')
          .select('*')
          .limit(limit);

      final movies = (response as List)
          .map((json) => MovieModel.fromJson(json) as MovieEntity)
          .toList();

      AppLogger.info('Fetched ${movies.length} controversial movies');
      return Right(movies);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch controversial movies', e, stackTrace);
      return Left(_handleError(e));
    }
  }

  // Repository'deki getMoviesByCategory metodunu basitleştirin:

  Future<Either<Failure, List<MovieEntity>>> getMoviesByCategory({
    required int categoryId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      AppLogger.info('Fetching movies for category: $categoryId');

      // View'dan direkt al, zaten her şey hazır!
      final response = await client
          .from('movies_by_category_view')
          .select('*')
          .eq('category_id', categoryId)
          .order('platform_rating', ascending: false)
          .range((page - 1) * limit, page * limit - 1);

      final movies = (response as List)
          .map((json) => MovieModel.fromJson(json) as MovieEntity)
          .toList();

      AppLogger.info(
        'Fetched ${movies.length} movies for category $categoryId',
      );
      return Right(movies);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch movies by category', e, stackTrace);
      return Left(_handleError(e));
    }
  }

  // Tüm kategorilerdeki filmleri tek sorguda getir
  Future<Either<Failure, List<MovieEntity>>> getAllMoviesByCategory({
    int limit = 100,
  }) async {
    try {
      AppLogger.info('Fetching all movies grouped by category');

      final response = await client
          .from('movies_by_category_view')
          .select('*')
          .not('category_id', 'is', null)
          .limit(limit);

      final movies = (response as List)
          .map((json) => MovieModel.fromJson(json) as MovieEntity)
          .toList();

      AppLogger.info('Fetched ${movies.length} movies from categories');
      return Right(movies);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch movies by category', e, stackTrace);
      return Left(_handleError(e));
    }
  }

  // Get movie by ID
  Future<Either<Failure, MovieEntity>> getMovieById(int id) async {
    try {
      AppLogger.info('Fetching movie: $id');

      // ÖNEMLİ DÜZELTME:
      // '.from('movies_by_category_view')' yerine '.from('movies')' kullanıyoruz.
      // Ana tablo ('movies') ilişkilendirme (Foreign Key) mantığını destekler.
      final response = await client
          .from('movies')
          .select('''
          *,
          category:categories!category_id(*),
          movie_stats(*)
        ''')
          .eq('id', id)
          .eq('is_active', true)
          .maybeSingle();

      // Handle null response
      if (response == null) {
        AppLogger.warning('Movie not found: $id');
        return const Left(NotFoundFailure('Film bulunamadı'));
      }

      final movieJson = Map<String, dynamic>.from(response);

      // 1. İstatistikleri (Stats) birleştir
      if (response['movie_stats'] != null &&
          (response['movie_stats']).isNotEmpty) {
        final stats = response['movie_stats'];
        movieJson['view_count'] = stats['view_count'] ?? 0;
        movieJson['comment_count'] = stats['comment_count'] ?? 0;
        movieJson['like_count'] = stats['like_count'] ?? 0;
        movieJson['dislike_count'] = stats['dislike_count'] ?? 0;
        movieJson['list_count'] = stats['list_count'] ?? 0;
        movieJson['watchlist_count'] = stats['watchlist_count'] ?? 0;
      }

      // 2. Kategori bilgilerini ana seviyeye taşı (MovieModelinizin yapısına göre)
      // Supabase relationları 'category' objesi içinde döner.
      // Sizin kodunuzda category_name, category_slug gibi direkt alanlar varsa,
      // buraya almak daha pratik olabilir:
      if (response['category'] != null) {
        final category = response['category'];
        movieJson['category_name'] = category['name'];
        movieJson['category_slug'] = category['slug'];
        movieJson['category_description'] = category['description'];
        movieJson['category_color'] = category['color_hex'];
      }

      final movie = MovieModel.fromJson(movieJson);
      AppLogger.info('Fetched movie: ${movie.title}');
      return Right(movie);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch movie', e, stackTrace);
      return Left(_handleError(e));
    }
  }

  // Search movies
  Future<Either<Failure, List<MovieEntity>>> searchMovies(String query) async {
    try {
      AppLogger.info('Searching movies: $query');

      final response = await client
          .from('movies')
          .select('''
            *,
            movie_stats(*)
          ''')
          .eq('is_active', true)
          .or('title.ilike.%$query%,original_title.ilike.%$query%')
          .limit(20);

      // Handle null or empty response

      final movies = (response as List).map((json) {
        final movieJson = Map<String, dynamic>.from(json);
        if (json['movie_stats'] != null &&
            (json['movie_stats'] as List).isNotEmpty) {
          final stats = json['movie_stats'][0];
          movieJson['view_count'] = stats['view_count'] ?? 0;
          movieJson['comment_count'] = stats['comment_count'] ?? 0;
          movieJson['like_count'] = stats['like_count'] ?? 0;
          movieJson['dislike_count'] = stats['dislike_count'] ?? 0;
          movieJson['list_count'] = stats['list_count'] ?? 0;
          movieJson['watchlist_count'] = stats['watchlist_count'] ?? 0;
        }
        return MovieModel.fromJson(movieJson) as MovieEntity;
      }).toList();

      AppLogger.info('Found ${movies.length} movies');
      return Right(movies);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to search movies', e, stackTrace);
      return Left(_handleError(e));
    }
  }

  // Get all categories
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      AppLogger.info('Fetching categories');

      final response = await client
          .from('categories')
          .select('*')
          .order('name');

      final categories = (response as List)
          .map((json) => Category.fromJson(json) as CategoryEntity)
          .toList();

      AppLogger.info('Fetched ${categories.length} categories');
      return Right(categories);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch categories', e, stackTrace);
      return Left(_handleError(e));
    }
  }

  Future<Either<Failure, void>> recordMovieView(int movieId) async {
    try {
      await client.rpc(
        'increment_movie_view_count',
        params: {
          'p_movie_id': movieId,
          // İstersen user_id de ekleyebilirsin:
          // 'p_user_id': SupabaseService.currentUserId,
        },
      );
      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to record movie view', e, stackTrace);
      return Left(ServerFailure('Görüntüleme kaydedilemedi'));
    }
  }

  Future<Either<Failure, void>> toggleMovieLike(
    int movieId,
    bool isLike,
  ) async {
    try {
      // 1. Gerçek Supabase oturumunu kontrol et (en kritik kısım)
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) {
        AppLogger.error(
          '❌ Supabase oturum yok! currentUser null. Kullanıcı giriş yapmamış veya session expired.',
        );
        return const Left(
          AuthenticationFailure(
            'Oturum bulunamadı. Lütfen tekrar giriş yapın.',
          ),
        );
      }

      final realAuthUid = currentUser.id;
      final serviceUserId = SupabaseService.currentUserId;

      AppLogger.info('🔍 Supabase gerçek auth.uid       : $realAuthUid');
      AppLogger.info('🔍 SupabaseService.currentUserId  : $serviceUserId');

      if (realAuthUid != serviceUserId) {
        AppLogger.error('❌ UID MISMATCH! Gerçek auth uid ile service farklı.');
        AppLogger.error('Gerçek: $realAuthUid');
        AppLogger.error('Service: $serviceUserId');
        return const Left(
          AuthenticationFailure(
            'Kullanıcı kimliği uyuşmazlığı. Lütfen uygulamayı yeniden başlatın veya çıkış yapıp giriş yapın.',
          ),
        );
      }

      final userId = realAuthUid; // Bundan sonra sadece bunu kullanalım
      AppLogger.info('✅ Kullanılan güvenli userId: $userId');

      AppLogger.info(
        'Toggling movie ${isLike ? 'like' : 'dislike'} → movieId: $movieId',
      );

      // 2. Mevcut reaction var mı kontrol et
      final existingResponse = await client
          .from('movie_reactions')
          .select()
          .eq('user_id', userId)
          .eq('movie_id', movieId)
          .maybeSingle();

      final existing = existingResponse;

      if (existing != null) {
        AppLogger.info('Mevcut reaction bulundu: ${existing['reaction']}');

        if (existing['reaction'] == (isLike ? 'like' : 'dislike')) {
          // Aynı tepki → kaldır
          AppLogger.info('Aynı tepki var → beğeni/karşıt beğeni kaldırılıyor');
          await client
              .from('movie_reactions')
              .delete()
              .eq('user_id', userId)
              .eq('movie_id', movieId);
          AppLogger.info('Beğeni başarıyla kaldırıldı');
        } else {
          // Farklı tepki → değiştir
          AppLogger.info(
            'Farklı tepki → değiştiriliyor: ${isLike ? 'like' : 'dislike'}',
          );
          await client
              .from('movie_reactions')
              .update({'reaction': isLike ? 'like' : 'dislike'})
              .eq('user_id', userId)
              .eq('movie_id', movieId);
          AppLogger.info('Beğeni başarıyla değiştirildi');
        }
      } else {
        // Yeni ekleme
        AppLogger.info(
          '📥 Yeni reaction ekleniyor → user_id=$userId, movie_id=$movieId, reaction=${isLike ? 'like' : 'dislike'}',
        );

        await client.from('movie_reactions').insert({
          'user_id': userId,
          'movie_id': movieId,
          'reaction': isLike ? 'like' : 'dislike',
        });

        AppLogger.info('✅ Yeni beğeni başarıyla eklendi');
      }

      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        '❌ toggleMovieLike HATASI ────────────────────────────────',
      );
      AppLogger.error('Hata tipi     : ${e.runtimeType}');
      AppLogger.error('Hata mesajı   : $e');
      AppLogger.error('Stack trace   : $stackTrace');
      AppLogger.error(
        '───────────────────────────────────────────────────────────',
      );

      // Supabase spesifik hata mı?
      if (e.toString().contains('row-level security policy')) {
        AppLogger.error(
          'RLS HATASI → Büyük ihtimal user_id ile auth.uid() eşleşmiyor veya oturum geçersiz',
        );
      }

      return Left(_handleError(e));
    }
  }

  // Add to watchlist
  Future<Either<Failure, void>> toggleWatchlist(int movieId) async {
    try {
      final userId = SupabaseService.currentUserId;
      if (userId == null) {
        return const Left(AuthenticationFailure());
      }

      AppLogger.info('Toggling watchlist: $movieId');

      final existing = await client
          .from('watchlist')
          .select()
          .eq('user_id', userId)
          .eq('movie_id', movieId)
          .maybeSingle();

      if (existing != null) {
        await client
            .from('watchlist')
            .delete()
            .eq('user_id', userId)
            .eq('movie_id', movieId);
      } else {
        await client.from('watchlist').insert({
          'user_id': userId,
          'movie_id': movieId,
        });
      }

      return const Right(null);
    } catch (e, stackTrace) {
      AppLogger.error('Failed to toggle watchlist', e, stackTrace);
      return Left(_handleError(e));
    }
  }

  Failure _handleError(dynamic error) {
    if (error.toString().contains('network')) {
      return const NetworkFailure();
    }
    return ServerFailure(error.toString());
  }
}
