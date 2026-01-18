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

          // Film başarıyla yüklendi → view count artır
          _recordView(movieId);
        },
      );
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load movie detail', e, stackTrace);
      _errorMessage.value = 'Film detayları yüklenirken bir hata oluştu';
      _viewState.value = MovieDetailViewState.error;
    }
  }

  /// Film görüntülendiğinde view count'u artırır (sessiz işlem)
  Future<void> _recordView(int movieId) async {
    try {
      AppLogger.info('Recording view for movie: $movieId');
      await _movieRepository.recordMovieView(movieId);
      AppLogger.info('View recorded successfully for movie: $movieId');
    } catch (e) {
      // View kaydetme hatası kritik değil → sadece logla, kullanıcıya gösterme
      AppLogger.warning('Failed to record view for movie $movieId: $e');
    }
  }

  Future<void> toggleWatchlist() async {
    if (movie == null) return;

    try {
      final result = await _movieRepository.toggleWatchlist(movie!.id!);
      result.fold(
        (failure) {
          Get.snackbar('Hata', failure.message);
        },
        (_) {
          Get.snackbar('Başarılı', 'İzleme listesi güncellendi');
          // Opsiyonel: watchlist değiştiğinde detayları yenile
          // loadMovieDetail(movie!.id);
        },
      );
    } catch (e) {
      AppLogger.error('Failed to toggle watchlist', e);
    }
  }

  Future<void> toggleLike(bool isLike) async {
    if (movie == null) return;

    try {
      final result = await _movieRepository.toggleMovieLike(movie!.id!, isLike);
      result.fold(
        (failure) {
          Get.snackbar('Hata', failure.message);
        },
        (_) {
          // Like değişti → detayları yenile (istatistikler güncellenir)
          loadMovieDetail(movie!.id!);
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