import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
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
    final isMobile = ResponsiveHelper.isMobile(context);

    return CustomScrollView(
      slivers: [
        _buildAppBar(context),
        SliverToBoxAdapter(
          child: Column(
            children: [
              _buildBackdropSection(context, movie),
              ResponsiveContainer(
                child: ResponsivePadding(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: ResponsiveHelper.getValue(
                          context,
                          mobile: 32,
                          tablet: 40,
                          desktop: 48,
                        ),
                      ),
                      isMobile
                          ? _buildMobileContent(context, movie)
                          : _buildDesktopContent(context, movie),
                      SizedBox(
                        height: ResponsiveHelper.getValue(
                          context,
                          mobile: 48,
                          tablet: 64,
                          desktop: 80,
                        ),
                      ),
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

    if (movie.backdropPath != null) {
      backdrops.add(movie.fullBackdropUrl);
    }

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
      backdrops.add('');
    }

    final backdropHeight = ResponsiveHelper.getValue(
      context,
      mobile: 400.0,
      tablet: 500.0,
      desktop: 600.0,
    );

    return Stack(
      children: [
        SizedBox(
          height: backdropHeight,
          child: CarouselSlider(
            options: CarouselOptions(
              height: backdropHeight,
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
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ResponsiveContainer(
            child: ResponsivePadding(child: _buildHeader(context, movie)),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final iconSize = ResponsiveHelper.getValue(
      context,
      mobile: 20.0,
      tablet: 22.0,
      desktop: 24.0,
    );

    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(
            ResponsiveHelper.getValue(
              context,
              mobile: 8,
              tablet: 9,
              desktop: 10,
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.arrow_back, color: Colors.white, size: iconSize),
        ),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(
              ResponsiveHelper.getValue(
                context,
                mobile: 8,
                tablet: 9,
                desktop: 10,
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.share_outlined,
              color: Colors.white,
              size: iconSize,
            ),
          ),
          onPressed: () {},
        ),
        SizedBox(
          width: ResponsiveHelper.getValue(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, MovieEntity movie) {
    final isMobile = ResponsiveHelper.isMobile(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: ResponsiveHelper.getValue(
          context,
          mobile: 24,
          tablet: 32,
          desktop: 40,
        ),
      ),
      child: isMobile
          ? _buildMobileHeader(context, movie)
          : _buildDesktopHeader(context, movie),
    );
  }

  Widget _buildMobileHeader(BuildContext context, MovieEntity movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FadeInLeft(
              child: Container(
                width: ResponsiveHelper.getValue(
                  context,
                  mobile: 120.0,
                  tablet: 160.0,
                  desktop: 180.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getBorderRadius(context, baseRadius: 8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getBorderRadius(context, baseRadius: 8),
                  ),
                  child: AspectRatio(
                    aspectRatio: 2 / 3,
                    child: Image.network(
                      movie.fullPosterUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppTheme.darkCard,
                        child: Icon(
                          Icons.movie,
                          size: ResponsiveHelper.getIconSize(
                            context,
                            baseSize: 48,
                          ),
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: ResponsiveHelper.getValue(
                context,
                mobile: 16,
                tablet: 24,
                desktop: 32,
              ),
            ),
            Expanded(
              child: FadeInRight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (movie.platformRating != null)
                      _buildCompactRating(
                        context,
                        icon: Icons.star,
                        value: movie.platformRating!.toStringAsFixed(1),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: ResponsiveHelper.getValue(
            context,
            mobile: 16,
            tablet: 20,
            desktop: 24,
          ),
        ),
        Text(
          movie.title ?? '',
          style: TextStyle(
            fontSize: ResponsiveHelper.getValue(
              context,
              mobile: 24.0,
              tablet: 32.0,
              desktop: 42.0,
            ),
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        if (movie.originalTitle != null &&
            movie.originalTitle != movie.title) ...[
          SizedBox(
            height: ResponsiveHelper.getValue(
              context,
              mobile: 6,
              tablet: 8,
              desktop: 8,
            ),
          ),
          Text(
            movie.originalTitle!,
            style: TextStyle(
              fontSize: ResponsiveHelper.getValue(
                context,
                mobile: 14.0,
                tablet: 16.0,
                desktop: 20.0,
              ),
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
        SizedBox(
          height: ResponsiveHelper.getValue(
            context,
            mobile: 12,
            tablet: 16,
            desktop: 24,
          ),
        ),
        Wrap(
          spacing: ResponsiveHelper.getValue(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          ),
          runSpacing: 8,
          children: [
            if (movie.releaseDate != null)
              Text(
                movie.releaseYear,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getBodyTextSize(context),
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            if (movie.productionCountries != null &&
                movie.productionCountries!.isNotEmpty)
              Text(
                movie.productionCountries!.first.name ?? '',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getBodyTextSize(context),
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            if (movie.runtime != null)
              Text(
                _formatRuntime(movie.runtime!),
                style: TextStyle(
                  fontSize: ResponsiveHelper.getBodyTextSize(context),
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
          ],
        ),
        SizedBox(
          height: ResponsiveHelper.getValue(
            context,
            mobile: 12,
            tablet: 16,
            desktop: 20,
          ),
        ),
        if (movie.genres != null && movie.genres!.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: movie.genres!.map((genre) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getValue(
                    context,
                    mobile: 10,
                    tablet: 11,
                    desktop: 12,
                  ),
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getBorderRadius(context, baseRadius: 4),
                  ),
                ),
                child: Text(
                  genre.name ?? '',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getValue(
                      context,
                      mobile: 12.0,
                      tablet: 13.0,
                      desktop: 13.0,
                    ),
                    color: Colors.white,
                  ),
                ),
              );
            }).toList(),
          ),
        SizedBox(
          height: ResponsiveHelper.getValue(
            context,
            mobile: 20,
            tablet: 24,
            desktop: 32,
          ),
        ),
        _buildActions(context, movie),
      ],
    );
  }

  Widget _buildDesktopHeader(BuildContext context, MovieEntity movie) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FadeInLeft(
          child: Container(
            width: ResponsiveHelper.getValue(
              context,
              mobile: 200.0,
              tablet: 240.0,
              desktop: 280.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getBorderRadius(context, baseRadius: 8),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getBorderRadius(context, baseRadius: 8),
              ),
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: Image.network(
                  movie.fullPosterUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppTheme.darkCard,
                    child: Icon(
                      Icons.movie,
                      size: ResponsiveHelper.getIconSize(context, baseSize: 64),
                      color: AppTheme.textTertiary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: ResponsiveHelper.getValue(
            context,
            mobile: 40,
            tablet: 50,
            desktop: 60,
          ),
        ),
        Expanded(
          child: FadeInRight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  movie.title ?? '',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getValue(
                      context,
                      mobile: 28.0,
                      tablet: 36.0,
                      desktop: 42.0,
                    ),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                    shadows: const [
                      Shadow(color: Colors.black, blurRadius: 20),
                    ],
                  ),
                ),
                if (movie.originalTitle != null &&
                    movie.originalTitle != movie.title) ...[
                  const SizedBox(height: 8),
                  Text(
                    movie.originalTitle!,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getValue(
                        context,
                        mobile: 16.0,
                        tablet: 18.0,
                        desktop: 20.0,
                      ),
                      color: Colors.white.withOpacity(0.8),
                      shadows: const [
                        Shadow(color: Colors.black, blurRadius: 15),
                      ],
                    ),
                  ),
                ],
                SizedBox(
                  height: ResponsiveHelper.getValue(
                    context,
                    mobile: 16,
                    tablet: 20,
                    desktop: 24,
                  ),
                ),
                Wrap(
                  spacing: ResponsiveHelper.getValue(
                    context,
                    mobile: 12,
                    tablet: 14,
                    desktop: 16,
                  ),
                  runSpacing: 8,
                  children: [
                    if (movie.releaseDate != null)
                      Text(
                        movie.releaseYear,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getBodyTextSize(context),
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    if (movie.productionCountries != null &&
                        movie.productionCountries!.isNotEmpty)
                      Text(
                        movie.productionCountries!.first.name ?? '',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getBodyTextSize(context),
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    if (movie.runtime != null)
                      Text(
                        _formatRuntime(movie.runtime!),
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getBodyTextSize(context),
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                if (movie.genres != null && movie.genres!.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: movie.genres!.map((genre) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.getValue(
                            context,
                            mobile: 10,
                            tablet: 11,
                            desktop: 12,
                          ),
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(
                            ResponsiveHelper.getBorderRadius(
                              context,
                              baseRadius: 4,
                            ),
                          ),
                        ),
                        child: Text(
                          genre.name ?? '',
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getValue(
                              context,
                              mobile: 12.0,
                              tablet: 13.0,
                              desktop: 13.0,
                            ),
                            color: Colors.white,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 32),
                _buildActions(context, movie),
                const SizedBox(height: 32),
                Row(
                  children: [
                    if (movie.platformRating != null)
                      _buildRating(
                        context,
                        icon: Icons.star,
                        value: movie.platformRating!.toStringAsFixed(1),
                        count: movie.platformRatingCount ?? 0,
                        label: 'Platform',
                      ),
                    if (movie.platformRating != null &&
                        movie.tmdbVoteAverage != null)
                      SizedBox(
                        width: ResponsiveHelper.getValue(
                          context,
                          mobile: 24,
                          tablet: 28,
                          desktop: 32,
                        ),
                      ),
                    if (movie.tmdbVoteAverage != null)
                      _buildRating(
                        context,
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
    );
  }

  Widget _buildCompactRating(
    BuildContext context, {
    required IconData icon,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.getValue(
          context,
          mobile: 10,
          tablet: 12,
          desktop: 14,
        ),
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getBorderRadius(context, baseRadius: 6),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: ResponsiveHelper.getValue(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
            color: AppTheme.secondaryColor,
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.getValue(
                context,
                mobile: 16,
                tablet: 18,
                desktop: 20,
              ),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, MovieEntity movie) {
    final authController = Get.find<AuthController>();

    return Wrap(
      spacing: ResponsiveHelper.getValue(
        context,
        mobile: 8,
        tablet: 10,
        desktop: 12,
      ),
      runSpacing: 8,
      children: [
        _buildActionButton(
          context,
          icon: Icons.thumb_up_outlined,
          label: 'Beğen',
          count: movie.likeCount,
          onPressed: () {
            if (authController.requireAuth()) {
              controller.toggleLike(true);
            }
          },
        ),
        _buildActionButton(
          context,
          icon: Icons.bookmark_border,
          label: 'İzlenecek',
          count: movie.watchlistCount,
          onPressed: () {
            if (authController.requireAuth()) {
              controller.toggleWatchlist();
            }
          },
        ),
        _buildActionButton(
          context,
          icon: Icons.list_outlined,
          label: 'Liste',
          count: movie.listCount,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    int? count,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(
        ResponsiveHelper.getBorderRadius(context, baseRadius: 4),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getValue(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          ),
          vertical: ResponsiveHelper.getValue(
            context,
            mobile: 8,
            tablet: 9,
            desktop: 10,
          ),
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.textTertiary.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getBorderRadius(context, baseRadius: 4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: ResponsiveHelper.getValue(
                context,
                mobile: 16,
                tablet: 17,
                desktop: 18,
              ),
              color: AppTheme.textPrimary,
            ),
            SizedBox(
              width: ResponsiveHelper.getValue(
                context,
                mobile: 6,
                tablet: 7,
                desktop: 8,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveHelper.getValue(
                  context,
                  mobile: 13,
                  tablet: 14,
                  desktop: 14,
                ),
                color: AppTheme.textPrimary,
              ),
            ),
            if (count != null && count > 0) ...[
              const SizedBox(width: 6),
              Text(
                _formatCount(count),
                style: TextStyle(
                  fontSize: ResponsiveHelper.getValue(
                    context,
                    mobile: 12,
                    tablet: 13,
                    desktop: 13,
                  ),
                  color: AppTheme.textSecondary.withOpacity(0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRating(
    BuildContext context, {
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
            Icon(
              icon,
              size: ResponsiveHelper.getValue(
                context,
                mobile: 18,
                tablet: 19,
                desktop: 20,
              ),
              color: AppTheme.secondaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: ResponsiveHelper.getValue(
                  context,
                  mobile: 20,
                  tablet: 22,
                  desktop: 24,
                ),
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: const [Shadow(color: Colors.black, blurRadius: 10)],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '$label · ${_formatCount(count)} oy',
          style: TextStyle(
            fontSize: ResponsiveHelper.getValue(
              context,
              mobile: 11,
              tablet: 12,
              desktop: 12,
            ),
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileContent(BuildContext context, MovieEntity movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (movie.tagline != null && movie.tagline!.isNotEmpty) ...[
          Text(
            movie.tagline!,
            style: TextStyle(
              fontSize: ResponsiveHelper.getValue(
                context,
                mobile: 15,
                tablet: 16,
                desktop: 18,
              ),
              fontStyle: FontStyle.italic,
              color: AppTheme.textSecondary.withOpacity(0.9),
              height: 1.5,
            ),
          ),
          SizedBox(
            height: ResponsiveHelper.getValue(
              context,
              mobile: 16,
              tablet: 20,
              desktop: 24,
            ),
          ),
        ],
        if (movie.overview != null && movie.overview!.isNotEmpty) ...[
          Text(
            movie.overview!,
            style: TextStyle(
              fontSize: ResponsiveHelper.getBodyTextSize(context),
              color: AppTheme.textSecondary,
              height: 1.7,
            ),
          ),
          SizedBox(
            height: ResponsiveHelper.getValue(
              context,
              mobile: 24,
              tablet: 32,
              desktop: 40,
            ),
          ),
        ],
        _buildStats(context, movie),
        SizedBox(
          height: ResponsiveHelper.getValue(
            context,
            mobile: 24,
            tablet: 32,
            desktop: 40,
          ),
        ),
        _buildSidebar(context, movie),
        SizedBox(
          height: ResponsiveHelper.getValue(
            context,
            mobile: 32,
            tablet: 40,
            desktop: 48,
          ),
        ),
        _buildCredits(context, movie),
      ],
    );
  }

  Widget _buildDesktopContent(BuildContext context, MovieEntity movie) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (movie.tagline != null && movie.tagline!.isNotEmpty) ...[
                    Text(
                      movie.tagline!,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getValue(
                          context,
                          mobile: 16,
                          tablet: 17,
                          desktop: 18,
                        ),
                        fontStyle: FontStyle.italic,
                        color: AppTheme.textSecondary.withOpacity(0.9),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (movie.overview != null && movie.overview!.isNotEmpty) ...[
                    Text(
                      movie.overview!,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.getBodyTextSize(context),
                        color: AppTheme.textSecondary,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                  _buildStats(context, movie),
                ],
              ),
            ),
            SizedBox(
              width: ResponsiveHelper.getValue(
                context,
                mobile: 40,
                tablet: 50,
                desktop: 60,
              ),
            ),
            SizedBox(
              width: ResponsiveHelper.getValue(
                context,
                mobile: 220.0,
                tablet: 250.0,
                desktop: 280.0,
              ),
              child: _buildSidebar(context, movie),
            ),
          ],
        ),
        SizedBox(
          height: ResponsiveHelper.getValue(
            context,
            mobile: 48,
            tablet: 56,
            desktop: 64,
          ),
        ),
        _buildCredits(context, movie),
      ],
    );
  }

  Widget _buildStats(BuildContext context, MovieEntity movie) {
    return Container(
      padding: EdgeInsets.all(
        ResponsiveHelper.getValue(context, mobile: 20, tablet: 22, desktop: 24),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.textTertiary.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(
          ResponsiveHelper.getBorderRadius(context, baseRadius: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'İstatistikler',
            style: TextStyle(
              fontSize: ResponsiveHelper.getValue(
                context,
                mobile: 15,
                tablet: 16,
                desktop: 16,
              ),
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(
            height: ResponsiveHelper.getValue(
              context,
              mobile: 16,
              tablet: 18,
              desktop: 20,
            ),
          ),
          _buildStatRow(context, 'Görüntülenme', movie.viewCount ?? 0),
          const SizedBox(height: 12),
          _buildStatRow(context, 'Yorum', movie.commentCount ?? 0),
          const SizedBox(height: 12),
          _buildStatRow(context, 'Beğeni', movie.likeCount ?? 0),
          const SizedBox(height: 12),
          _buildStatRow(context, 'Beğenmeme', movie.dislikeCount ?? 0),
        ],
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.getValue(
              context,
              mobile: 13,
              tablet: 14,
              desktop: 14,
            ),
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          _formatCount(value),
          style: TextStyle(
            fontSize: ResponsiveHelper.getValue(
              context,
              mobile: 13,
              tablet: 14,
              desktop: 14,
            ),
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
          context,
          title: 'Detaylar',
          items: [
            if (movie.releaseDate != null)
              _buildDetailItem(
                context,
                'Yayın Tarihi',
                movie.releaseDate!.toString().split(' ')[0],
              ),
            if (movie.runtime != null)
              _buildDetailItem(context, 'Süre', '${movie.runtime} dakika'),
            if (movie.spokenLanguages != null &&
                movie.spokenLanguages!.isNotEmpty)
              _buildDetailItem(
                context,
                'Dil',
                movie.spokenLanguages!.map((l) => l.name ?? '').join(', '),
              ),
            if (movie.imdbId != null)
              _buildDetailItem(context, 'IMDb', movie.imdbId!),
            if (movie.tmdbPopularity != null)
              _buildDetailItem(
                context,
                'Popülerlik',
                movie.tmdbPopularity!.toStringAsFixed(1),
              ),
          ],
        ),
        SizedBox(
          height: ResponsiveHelper.getValue(
            context,
            mobile: 24,
            tablet: 28,
            desktop: 32,
          ),
        ),
        if (movie.categoryName != null)
          _buildSidebarSection(
            context,
            title: 'Kategori',
            items: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getValue(
                    context,
                    mobile: 10,
                    tablet: 11,
                    desktop: 12,
                  ),
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
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getBorderRadius(context, baseRadius: 4),
                  ),
                ),
                child: Text(
                  movie.categoryName!,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.getValue(
                      context,
                      mobile: 12,
                      tablet: 13,
                      desktop: 13,
                    ),
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

  Widget _buildSidebarSection(
    BuildContext context, {
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveHelper.getValue(
              context,
              mobile: 13,
              tablet: 14,
              desktop: 14,
            ),
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(
          height: ResponsiveHelper.getValue(
            context,
            mobile: 14,
            tablet: 15,
            desktop: 16,
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveHelper.getValue(
                context,
                mobile: 11,
                tablet: 12,
                desktop: 12,
              ),
              color: AppTheme.textSecondary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.getValue(
                context,
                mobile: 13,
                tablet: 14,
                desktop: 14,
              ),
              color: AppTheme.textPrimary,
            ),
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
          Text(
            'Oyuncular',
            style: TextStyle(
              fontSize: ResponsiveHelper.getValue(
                context,
                mobile: 20,
                tablet: 22,
                desktop: 24,
              ),
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(
            height: ResponsiveHelper.getValue(
              context,
              mobile: 20,
              tablet: 22,
              desktop: 24,
            ),
          ),
          SizedBox(
            height: ResponsiveHelper.getValue(
              context,
              mobile: 220.0,
              tablet: 230.0,
              desktop: 240.0,
            ),
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
                  return _buildCastCard(context, person);
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

  Widget _buildCastCard(BuildContext context, Map<String, dynamic> person) {
    final profilePath = person['profile_path'];
    final imageUrl = profilePath != null
        ? 'https://image.tmdb.org/t/p/w185$profilePath'
        : null;

    final cardWidth = ResponsiveHelper.getValue(
      context,
      mobile: 130.0,
      tablet: 135.0,
      desktop: 140.0,
    );
    final cardHeight = ResponsiveHelper.getValue(
      context,
      mobile: 170.0,
      tablet: 175.0,
      desktop: 180.0,
    );

    return Container(
      width: cardWidth,
      margin: EdgeInsets.only(
        right: ResponsiveHelper.getValue(
          context,
          mobile: 12,
          tablet: 14,
          desktop: 16,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: cardHeight,
            decoration: BoxDecoration(
              color: AppTheme.darkCard,
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getBorderRadius(context, baseRadius: 4),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getBorderRadius(context, baseRadius: 4),
              ),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Center(
                        child: Icon(
                          Icons.person,
                          size: ResponsiveHelper.getIconSize(
                            context,
                            baseSize: 48,
                          ),
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.person,
                        size: ResponsiveHelper.getIconSize(
                          context,
                          baseSize: 48,
                        ),
                        color: AppTheme.textTertiary,
                      ),
                    ),
            ),
          ),
          SizedBox(
            height: ResponsiveHelper.getValue(
              context,
              mobile: 6,
              tablet: 7,
              desktop: 8,
            ),
          ),
          Text(
            person['name'] ?? '',
            style: TextStyle(
              fontSize: ResponsiveHelper.getValue(
                context,
                mobile: 13,
                tablet: 14,
                desktop: 14,
              ),
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
              fontSize: ResponsiveHelper.getValue(
                context,
                mobile: 11,
                tablet: 12,
                desktop: 12,
              ),
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
    final cardWidth = ResponsiveHelper.getValue(
      context,
      mobile: 200.0,
      tablet: 240.0,
      desktop: 280.0,
    );
    final cardHeight = cardWidth * 1.5;

    return CustomScrollView(
      slivers: [
        _buildAppBar(context),
        SliverToBoxAdapter(
          child: ResponsiveContainer(
            child: ResponsivePadding(
              child: Column(
                children: [
                  SizedBox(
                    height: ResponsiveHelper.getValue(
                      context,
                      mobile: 32,
                      tablet: 36,
                      desktop: 40,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LoadingShimmer(
                        width: cardWidth,
                        height: cardHeight,
                        borderRadius: ResponsiveHelper.getBorderRadius(
                          context,
                          baseRadius: 8,
                        ),
                      ),
                      SizedBox(
                        width: ResponsiveHelper.getValue(
                          context,
                          mobile: 24,
                          tablet: 40,
                          desktop: 60,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LoadingShimmer(
                              width: ResponsiveHelper.getValue(
                                context,
                                mobile: 250.0,
                                tablet: 350.0,
                                desktop: 400.0,
                              ),
                              height: ResponsiveHelper.getValue(
                                context,
                                mobile: 32,
                                tablet: 36,
                                desktop: 40,
                              ),
                            ),
                            SizedBox(
                              height: ResponsiveHelper.getValue(
                                context,
                                mobile: 12,
                                tablet: 14,
                                desktop: 16,
                              ),
                            ),
                            LoadingShimmer(
                              width: ResponsiveHelper.getValue(
                                context,
                                mobile: 200.0,
                                tablet: 250.0,
                                desktop: 300.0,
                              ),
                              height: ResponsiveHelper.getValue(
                                context,
                                mobile: 16,
                                tablet: 18,
                                desktop: 20,
                              ),
                            ),
                            SizedBox(
                              height: ResponsiveHelper.getValue(
                                context,
                                mobile: 24,
                                tablet: 28,
                                desktop: 32,
                              ),
                            ),
                            LoadingShimmer(
                              width: double.infinity,
                              height: ResponsiveHelper.getValue(
                                context,
                                mobile: 150.0,
                                tablet: 180.0,
                                desktop: 200.0,
                              ),
                            ),
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
