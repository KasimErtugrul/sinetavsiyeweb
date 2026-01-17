import 'package:get/get.dart';
import '../../core/utils/logger.dart';
import '../../data/repositories/movie_repository.dart';
import '../../domain/entities/movie_entity.dart';

enum MovieDetailViewState { initial, loading, success, error }

class MovieDetailController extends GetxController {
  final MovieRepository _movieRepository = MovieRepository();

  final _viewState = MovieDetailViewState.initial.obs;
  final _errorMessage = ''.obs;
  final _movie = Rxn<MovieEntity>();

  MovieDetailViewState get viewState => _viewState.value;
  String get errorMessage => _errorMessage.value;
  MovieEntity? get movie => _movie.value;

  void loadMovieDetail(int movieId) async {
    try {
      _viewState.value = MovieDetailViewState.loading;
      AppLogger.info('Loading movie detail: $movieId');

      final result = await _movieRepository.getMovieById(movieId);

      result.fold(
        (failure) {
          AppLogger.error('Failed to load movie detail: ${failure.message}');
          _errorMessage.value = failure.message;
          _viewState.value = MovieDetailViewState.error;
        },
        (movie) {
          _movie.value = movie;
          AppLogger.info('Loaded movie: ${movie.title}');
          _viewState.value = MovieDetailViewState.success;
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load movie detail', e, stackTrace);
      _errorMessage.value = 'Film detayları yüklenirken bir hata oluştu';
      _viewState.value = MovieDetailViewState.error;
    }
  }

  Future<void> toggleWatchlist() async {
    if (movie == null) return;

    try {
      final result = await _movieRepository.toggleWatchlist(movie!.id);
      result.fold(
        (failure) {
          Get.snackbar('Hata', failure.message);
        },
        (_) {
          Get.snackbar('Başarılı', 'İzleme listesi güncellendi');
        },
      );
    } catch (e) {
      AppLogger.error('Failed to toggle watchlist', e);
    }
  }

  Future<void> toggleLike(bool isLike) async {
    if (movie == null) return;

    try {
      final result = await _movieRepository.toggleMovieLike(movie!.id, isLike);
      result.fold(
        (failure) {
          Get.snackbar('Hata', failure.message);
        },
        (_) {
          loadMovieDetail(movie!.id);
        },
      );
    } catch (e) {
      AppLogger.error('Failed to toggle like', e);
    }
  }

  @override
  void onClose() {
    _movie.value = null;
    super.onClose();
  }
}
