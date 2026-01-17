import 'package:get/get.dart';
import '../../core/utils/logger.dart';
import '../../data/repositories/movie_repository.dart';
import '../../domain/entities/movie_entity.dart';

enum HomeViewState { initial, loading, success, error }

class HomeController extends GetxController {
  final MovieRepository _movieRepository = MovieRepository();

  // State
  final _viewState = HomeViewState.initial.obs;
  final _errorMessage = ''.obs;

  // Data
  final _trendingMovies = <MovieEntity>[].obs;
  final _popularMovies = <MovieEntity>[].obs;
  final _mostCommentedMovies = <MovieEntity>[].obs;
  final _mostViewedMovies = <MovieEntity>[].obs;
  final _topRatedMovies = <MovieEntity>[].obs;
  final _controversialMovies = <MovieEntity>[].obs;
  final _categories = <CategoryEntity>[].obs;
  final _moviesByCategory = <int, List<MovieEntity>>{}.obs;

  // Getters
  HomeViewState get viewState => _viewState.value;
  String get errorMessage => _errorMessage.value;
  List<MovieEntity> get trendingMovies => _trendingMovies;
  List<MovieEntity> get popularMovies => _popularMovies;
  List<MovieEntity> get mostCommentedMovies => _mostCommentedMovies;
  List<MovieEntity> get mostViewedMovies => _mostViewedMovies;
  List<MovieEntity> get topRatedMovies => _topRatedMovies;
  List<MovieEntity> get controversialMovies => _controversialMovies;
  List<CategoryEntity> get categories => _categories;
  Map<int, List<MovieEntity>> get moviesByCategory => _moviesByCategory;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      _viewState.value = HomeViewState.loading;
      AppLogger.info('Loading home data...');

      // Load all data in parallel
      final results = await Future.wait([
        _movieRepository.getTrendingMovies(limit: 10),
        _movieRepository.getPopularMovies(limit: 20),
        _movieRepository.getMostCommentedMovies(limit: 15),
        _movieRepository.getMostViewedMovies(limit: 15),
        _movieRepository.getTopRatedMovies(limit: 15),
        _movieRepository.getControversialMovies(limit: 15),
        _movieRepository.getAllMoviesByCategory(limit: 50),
      ]);

      // Handle trending movies
      results[0].fold(
        (failure) {
          AppLogger.error('Failed to load trending movies: ${failure.message}');
        },
        (movies) {
          _trendingMovies.value = movies;
          AppLogger.info('Loaded ${movies.length} trending movies');
        },
      );

      // Handle popular movies
      results[1].fold(
        (failure) {
          AppLogger.error('Failed to load popular movies: ${failure.message}');
        },
        (movies) {
          _popularMovies.value = movies;
          AppLogger.info('Loaded ${movies.length} popular movies');
        },
      );

      // Handle most commented movies
      results[2].fold(
        (failure) {
          AppLogger.error('Failed to load most commented movies: ${failure.message}');
        },
        (movies) {
          _mostCommentedMovies.value = movies;
          AppLogger.info('Loaded ${movies.length} most commented movies');
        },
      );

      // Handle most viewed movies
      results[3].fold(
        (failure) {
          AppLogger.error('Failed to load most viewed movies: ${failure.message}');
        },
        (movies) {
          _mostViewedMovies.value = movies;
          AppLogger.info('Loaded ${movies.length} most viewed movies');
        },
      );

      // Handle top rated movies
      results[4].fold(
        (failure) {
          AppLogger.error('Failed to load top rated movies: ${failure.message}');
        },
        (movies) {
          _topRatedMovies.value = movies;
          AppLogger.info('Loaded ${movies.length} top rated movies');
        },
      );

      // Handle controversial movies
      results[5].fold(
        (failure) {
          AppLogger.error('Failed to load controversial movies: ${failure.message}');
        },
        (movies) {
          _controversialMovies.value = movies;
          AppLogger.info('Loaded ${movies.length} controversial movies');
        },
      );

      // Handle movies grouped by category
      results[6].fold(
        (failure) {
          AppLogger.error('Failed to load movies by category: ${failure.message}');
        },
        (movies) {
          _groupMoviesByCategory(movies);
          AppLogger.info('Loaded ${movies.length} movies in categories');
        },
      );

      _viewState.value = HomeViewState.success;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load home data', e, stackTrace);
      _errorMessage.value = 'Veriler yüklenirken bir hata oluştu';
      _viewState.value = HomeViewState.error;
    }
  }

  void _groupMoviesByCategory(List<MovieEntity> movies) {
    _moviesByCategory.clear();
    _categories.clear();
    
    final Map<int, List<MovieEntity>> grouped = {};
    final Map<int, CategoryEntity> categoryMap = {};
    
    for (final movie in movies) {
      if (movie.categoryId != null) {
        if (!grouped.containsKey(movie.categoryId)) {
          grouped[movie.categoryId!] = [];
          
          categoryMap[movie.categoryId!] = CategoryEntity(
            id: movie.categoryId!,
            name: movie.categoryName ?? 'Bilinmeyen',
            slug: movie.categorySlug ?? '',
            description: movie.categoryDescription,
            colorHex: movie.categoryColor,
          );
        }
        
        grouped[movie.categoryId!]!.add(movie);
      }
    }
    
    _moviesByCategory.value = grouped;
    _categories.value = categoryMap.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    
    AppLogger.info('Grouped into ${_categories.length} categories');
    for (final cat in _categories) {
      AppLogger.info('  - ${cat.name}: ${_moviesByCategory[cat.id]?.length ?? 0} movies');
    }
  }

  @override
  Future<void> refresh() async {
    await loadHomeData();
  }
}
