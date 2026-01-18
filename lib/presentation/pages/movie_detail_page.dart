import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:sinetavsiyeweb/domain/entities/movie_entity.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../controllers/movie_detail_controller.dart';
import '../controllers/auth_controller.dart';
import '../widgets/common_widgets.dart';

class MovieDetailPage extends GetView<MovieDetailController> {
  final int movieId;
  const MovieDetailPage({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: Obx(() {
        if (controller.viewState == MovieDetailViewState.loading) {
          return _buildLoadingState(context);
        }
        if (controller.viewState == MovieDetailViewState.error) {
          return ErrorState(
            message: controller.errorMessage,
            onRetry: () => controller.loadMovieDetail(movieId),
          );
        }
        if (controller.movie == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildContent(context);
      }),
    );
  }

  Widget _buildContent(BuildContext context) {
    final movie = controller.movie!;
    return CustomScrollView(
      slivers: [
        _buildAppBar(context),
        SliverToBoxAdapter(
          child: Column(
            children: [
              _buildBackdropSection(context, movie),
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 48),
                      _buildMainContent(context, movie),
                      const SizedBox(height: 60),
                      _buildCredits(context, movie),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackdropSection(BuildContext context, MovieEntity movie) {
    List<String> backdrops = [];

    // Ana backdrop
    if (movie.backdropPath != null) {
      backdrops.add(movie.fullBackdropUrl);
    }

    // Images'tan gelen backdrop'lar
    if (movie.images != null) {
      final imageBackdrops = movie.images!['backdrops'] as List?;
      if (imageBackdrops != null && imageBackdrops.isNotEmpty) {
        for (var backdrop in imageBackdrops) {
          final path = backdrop['file_path'];
          if (path != null &&
              !backdrops.contains('https://image.tmdb.org/t/p/w1280$path')) {
            backdrops.add('https://image.tmdb.org/t/p/w1280$path');
          }
        }
      }
    }

    if (backdrops.isEmpty) {
      backdrops.add(''); // Boş backdrop
    }

    return Stack(
      children: [
        // Backdrop Carousel
        SizedBox(
          height: 600,
          child: CarouselSlider(
            options: CarouselOptions(
              height: 600,
              viewportFraction: 1.0,
              autoPlay: backdrops.length > 1,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              enlargeCenterPage: false,
            ),
            items: backdrops.map((url) {
              return Builder(
                builder: (BuildContext context) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      url.isNotEmpty
                          ? Image.network(
                              url,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  Container(color: AppTheme.darkCard),
                            )
                          : Container(color: AppTheme.darkCard),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppTheme.darkBackground.withOpacity(0.4),
                              AppTheme.darkBackground.withOpacity(0.7),
                              AppTheme.darkBackground,
                            ],
                            stops: const [0.0, 0.6, 1.0],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          ),
        ),

        // Header Content Over Carousel
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: _buildHeader(context, movie),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.share_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, MovieEntity movie) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Poster
          FadeInLeft(
            child: Container(
              width: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: Image.network(
                    movie.fullPosterUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppTheme.darkCard,
                      child: const Icon(
                        Icons.movie,
                        size: 64,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 60),

          // Info
          Expanded(
            child: FadeInRight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    movie.title ?? '',
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                      shadows: [Shadow(color: Colors.black, blurRadius: 20)],
                    ),
                  ),
                  if (movie.originalTitle != null &&
                      movie.originalTitle != movie.title) ...[
                    const SizedBox(height: 8),
                    Text(
                      movie.originalTitle!,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white.withOpacity(0.8),
                        shadows: const [
                          Shadow(color: Colors.black, blurRadius: 15),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),

                  // Meta
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      if (movie.releaseDate != null)
                        Text(
                          movie.releaseYear,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      if (movie.productionCountries != null &&
                          movie.productionCountries!.isNotEmpty)
                        Text(
                          movie.productionCountries!.first.name ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      if (movie.runtime != null)
                        Text(
                          _formatRuntime(movie.runtime!),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Genres
                  if (movie.genres != null && movie.genres!.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: movie.genres!.map((genre) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            genre.name ?? '',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 32),

                  // Actions
                  _buildActions(context, movie),

                  const SizedBox(height: 32),

                  // Ratings
                  Row(
                    children: [
                      if (movie.platformRating != null)
                        _buildRating(
                          icon: Icons.star,
                          value: movie.platformRating!.toStringAsFixed(1),
                          count: movie.platformRatingCount ?? 0,
                          label: 'Platform',
                        ),
                      if (movie.platformRating != null &&
                          movie.tmdbVoteAverage != null)
                        const SizedBox(width: 32),
                      if (movie.tmdbVoteAverage != null)
                        _buildRating(
                          icon: Icons.movie,
                          value: movie.tmdbVoteAverage!.toStringAsFixed(1),
                          count: movie.tmdbVoteCount ?? 0,
                          label: 'TMDb',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, MovieEntity movie) {
    final authController = Get.find<AuthController>();

    return Row(
      children: [
        _buildActionButton(
          icon: Icons.thumb_up_outlined,
          label: 'Beğen',
          count: movie.likeCount,
          onPressed: () {
            if (authController.requireAuth()) {
              controller.toggleLike(true);
            }
          },
        ),
        const SizedBox(width: 12),
        _buildActionButton(
          icon: Icons.bookmark_border,
          label: 'İzlenecek',
          count: movie.watchlistCount,
          onPressed: () {
            if (authController.requireAuth()) {
              controller.toggleWatchlist();
            }
          },
        ),
        const SizedBox(width: 12),
        _buildActionButton(
          icon: Icons.list_outlined,
          label: 'Liste',
          count: movie.listCount,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    int? count,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.textTertiary.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppTheme.textPrimary),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary),
            ),
            if (count != null && count > 0) ...[
              const SizedBox(width: 6),
              Text(
                _formatCount(count),
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary.withOpacity(0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRating({
    required IconData icon,
    required String value,
    required int count,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppTheme.secondaryColor),
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black, blurRadius: 10)],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '$label · ${_formatCount(count)} oy',
          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
        ),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context, MovieEntity movie) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tagline
              if (movie.tagline != null && movie.tagline!.isNotEmpty) ...[
                Text(
                  movie.tagline!,
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.textSecondary.withOpacity(0.9),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Overview
              if (movie.overview != null && movie.overview!.isNotEmpty) ...[
                Text(
                  movie.overview!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 40),
              ],

              // Stats
              _buildStats(context, movie),
            ],
          ),
        ),
        const SizedBox(width: 60),

        // Sidebar
        SizedBox(width: 280, child: _buildSidebar(context, movie)),
      ],
    );
  }

  Widget _buildStats(BuildContext context, MovieEntity movie) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.textTertiary.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'İstatistikler',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          _buildStatRow('Görüntülenme', movie.viewCount ?? 0),
          const SizedBox(height: 12),
          _buildStatRow('Yorum', movie.commentCount ?? 0),
          const SizedBox(height: 12),
          _buildStatRow('Beğeni', movie.likeCount ?? 0),
          const SizedBox(height: 12),
          _buildStatRow('Beğenmeme', movie.dislikeCount ?? 0),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
        ),
        Text(
          _formatCount(value),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSidebar(BuildContext context, MovieEntity movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSidebarSection(
          title: 'Detaylar',
          items: [
            if (movie.releaseDate != null)
              _buildDetailItem(
                'Yayın Tarihi',
                movie.releaseDate!.toString().split(' ')[0],
              ),
            if (movie.runtime != null)
              _buildDetailItem('Süre', '${movie.runtime} dakika'),
            if (movie.spokenLanguages != null &&
                movie.spokenLanguages!.isNotEmpty)
              _buildDetailItem(
                'Dil',
                movie.spokenLanguages!.map((l) => l.name ?? '').join(', '),
              ),
            if (movie.imdbId != null) _buildDetailItem('IMDb', movie.imdbId!),
            if (movie.tmdbPopularity != null)
              _buildDetailItem(
                'Popülerlik',
                movie.tmdbPopularity!.toStringAsFixed(1),
              ),
          ],
        ),
        const SizedBox(height: 32),
        if (movie.categoryName != null)
          _buildSidebarSection(
            title: 'Kategori',
            items: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: movie.categoryColor != null
                      ? Color(
                          int.parse(
                            '0xFF${movie.categoryColor!.replaceFirst('#', '')}',
                          ),
                        )
                      : AppTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  movie.categoryName!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildSidebarSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        ...items,
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildCredits(BuildContext context, MovieEntity movie) {
    if (movie.credits == null) return const SizedBox.shrink();

    try {
      final cast = movie.credits!['cast'] as List?;

      if (cast == null || cast.isEmpty) return const SizedBox.shrink();

      final scrollController = ScrollController();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Oyuncular',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 240,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
                scrollbars: false,
              ),
              child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: cast.length > 12 ? 12 : cast.length,
                itemBuilder: (context, index) {
                  final person = cast[index];
                  return _buildCastCard(person);
                },
              ),
            ),
          ),
        ],
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }

  Widget _buildCastCard(Map<String, dynamic> person) {
    final profilePath = person['profile_path'];
    final imageUrl = profilePath != null
        ? 'https://image.tmdb.org/t/p/w185$profilePath'
        : null;

    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: AppTheme.darkCard,
              borderRadius: BorderRadius.circular(4),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.person,
                        size: 48,
                        color: AppTheme.textTertiary,
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.person,
                        size: 48,
                        color: AppTheme.textTertiary,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            person['name'] ?? '',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            person['character'] ?? '',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary.withOpacity(0.7),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context),
        SliverToBoxAdapter(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LoadingShimmer(width: 280, height: 420, borderRadius: 8),
                      const SizedBox(width: 60),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LoadingShimmer(width: 400, height: 40),
                            const SizedBox(height: 16),
                            LoadingShimmer(width: 300, height: 20),
                            const SizedBox(height: 32),
                            LoadingShimmer(width: double.infinity, height: 200),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatRuntime(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0) {
      return '${hours}s ${mins}dk';
    }
    return '${mins}dk';
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
