import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../controllers/home_controller.dart';
import '../controllers/auth_controller.dart';
import '../widgets/common_widgets.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.viewState == HomeViewState.loading) {
          return _buildLoadingState(context);
        }

        if (controller.viewState == HomeViewState.error) {
          return ErrorState(
            message: controller.errorMessage,
            onRetry: controller.loadHomeData,
          );
        }

        final hasData =
            controller.trendingMovies.isNotEmpty ||
            controller.popularMovies.isNotEmpty ||
            controller.mostCommentedMovies.isNotEmpty ||
            controller.mostViewedMovies.isNotEmpty ||
            controller.topRatedMovies.isNotEmpty ||
            controller.controversialMovies.isNotEmpty ||
            controller.categories.isNotEmpty;

        if (!hasData) {
          return _buildEmptyState(context);
        }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          color: AppTheme.primaryColor,
          child: CustomScrollView(
            controller: controller.scrollController,
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: ResponsiveHelper.getValue(
                    context,
                    mobile: 20,
                    tablet: 30,
                    desktop: 40,
                  ),
                ),
              ),

              // Hero Section
              if (controller.trendingMovies.isNotEmpty)
                _buildHeroSection(context),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: ResponsiveHelper.getVerticalSpacing(context),
                ),
              ),

              // Popular Movies
              if (controller.popularMovies.isNotEmpty)
                _buildMovieSection(
                  context,
                  title: 'Popüler Filmler',
                  subtitle: 'En çok beğenilen filmler',
                  movies: controller.popularMovies,
                ),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: ResponsiveHelper.getVerticalSpacing(context),
                ),
              ),

              // Most Commented
              if (controller.mostCommentedMovies.isNotEmpty)
                _buildMovieSection(
                  context,
                  title: 'En Çok Yorumlanan',
                  subtitle: 'Tartışılan filmler',
                  icon: Icons.comment_outlined,
                  movies: controller.mostCommentedMovies,
                  showBadge: true,
                  badgeBuilder: (movie) => '${movie.commentCount} yorum',
                ),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: ResponsiveHelper.getVerticalSpacing(context),
                ),
              ),

              // Top Rated
              if (controller.topRatedMovies.isNotEmpty)
                _buildMovieSection(
                  context,
                  title: 'En Yüksek Puanlı',
                  subtitle: 'IMDb favorileri',
                  icon: Icons.star,
                  movies: controller.topRatedMovies,
                ),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: ResponsiveHelper.getVerticalSpacing(context),
                ),
              ),

              // Most Viewed
              if (controller.mostViewedMovies.isNotEmpty)
                _buildMovieSection(
                  context,
                  title: 'En Çok İzlenen',
                  subtitle: 'Popüler tercihler',
                  icon: Icons.visibility_outlined,
                  movies: controller.mostViewedMovies,
                  showBadge: true,
                  badgeBuilder: (movie) => '${movie.viewCount} görüntüleme',
                ),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: ResponsiveHelper.getVerticalSpacing(context),
                ),
              ),

              // Controversial
              if (controller.controversialMovies.isNotEmpty)
                _buildMovieSection(
                  context,
                  title: 'Tartışmalı Filmler',
                  subtitle: 'Fikir ayrılığı yaratan yapımlar',
                  icon: Icons.question_mark,
                  movies: controller.controversialMovies,
                ),

              // Categories
              ..._buildCategorySections(context),

              // Loading More
              SliverToBoxAdapter(
                child: Obx(() {
                  if (controller.isLoadingMore) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveHelper.getValue(
                          context,
                          mobile: 20,
                          tablet: 24,
                          desktop: 32,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Daha fazla yükleniyor...',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getBodyTextSize(context),
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: ResponsiveHelper.getValue(
                    context,
                    mobile: 40,
                    tablet: 60,
                    desktop: 80,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Empty State
  Widget _buildEmptyState(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context),
        SliverFillRemaining(
          child: EmptyState(
            title: 'Henüz Film Yok',
            message: 'Veritabanınıza film ekleyerek başlayın',
            icon: Icons.movie_filter_outlined,
            onAction: controller.refresh,
            actionLabel: 'Yenile',
          ),
        ),
      ],
    );
  }

  // App Bar
  Widget _buildAppBar(BuildContext context) {
    final authController = Get.find<AuthController>();
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppTheme.darkBackground.withOpacity(0.95),
      elevation: 0,
      centerTitle: !isDesktop,
      title: FadeInDown(
        duration: const Duration(milliseconds: 600),
        child: Row(
          mainAxisSize: isDesktop ? MainAxisSize.min : MainAxisSize.max,
          mainAxisAlignment: isDesktop ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(
                ResponsiveHelper.getValue(
                  context,
                  mobile: 8,
                  tablet: 10,
                  desktop: 12,
                ),
              ),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(
                  ResponsiveHelper.getBorderRadius(context),
                ),
              ),
              child: Icon(
                Icons.local_movies,
                color: Colors.white,
                size: ResponsiveHelper.getIconSize(context),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'CineHub',
              style: TextStyle(
                fontSize: ResponsiveHelper.getValue(
                  context,
                  mobile: 20,
                  tablet: 24,
                  desktop: 28,
                ),
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
      actions: [
        // Search
        FadeInDown(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 100),
          child: IconButton(
            icon: Icon(
              Icons.search,
              size: ResponsiveHelper.getIconSize(context),
            ),
            onPressed: () {
              // TODO: Navigate to search
            },
          ),
        ),
        // Notifications
        FadeInDown(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 200),
          child: IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              size: ResponsiveHelper.getIconSize(context),
            ),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ),
        // Profile / Login
        FadeInDown(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 300),
          child: Obx(() {
            if (authController.isAuthenticated) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: InkWell(
                  onTap: () => Get.toNamed('/profile'),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CircleAvatar(
                      radius: ResponsiveHelper.getValue(
                        context,
                        mobile: 18,
                        tablet: 20,
                        desktop: 22,
                      ),
                      backgroundColor: AppTheme.darkCard,
                      backgroundImage: authController.currentUser?.userMetadata?['avatar_url'] != null
                          ? NetworkImage(authController.currentUser!.userMetadata!['avatar_url'])
                          : null,
                      child: authController.currentUser?.userMetadata?['avatar_url'] == null
                          ? Icon(
                              Icons.person,
                              size: ResponsiveHelper.getIconSize(context, baseSize: 20),
                              color: AppTheme.textSecondary,
                            )
                          : null,
                    ),
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextButton.icon(
                  onPressed: () => Get.toNamed('/auth/login'),
                  icon: Icon(
                    Icons.login,
                    size: ResponsiveHelper.getValue(
                      context,
                      mobile: 18,
                      tablet: 20,
                      desktop: 22,
                    ),
                  ),
                  label: Text(
                    'Giriş',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getBodyTextSize(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.getValue(
                        context,
                        mobile: 12,
                        tablet: 16,
                        desktop: 20,
                      ),
                      vertical: 8,
                    ),
                  ),
                ),
              );
            }
          }),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // Hero Section
  Widget _buildHeroSection(BuildContext context) {
    final heroHeight = ResponsiveHelper.getHeroHeight(context);
    final viewportFraction = ResponsiveHelper.getCarouselViewportFraction(context);
    final isDesktop = ResponsiveHelper.isDesktop(context);

    return SliverToBoxAdapter(
      child: ResponsiveContainer(
        child: FadeIn(
          duration: const Duration(milliseconds: 800),
          child: CarouselSlider.builder(
            itemCount: controller.trendingMovies.length,
            options: CarouselOptions(
              height: heroHeight,
              viewportFraction: viewportFraction,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
            ),
            itemBuilder: (context, index, realIndex) {
              final movie = controller.trendingMovies[index];

              return Container(
                margin: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getValue(
                    context,
                    mobile: 8,
                    tablet: 12,
                    desktop: 16,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    ResponsiveHelper.getBorderRadius(context, baseRadius: 24),
                  ),
                  child: Stack(
                    children: [
                      // Background Image
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(movie.fullBackdropUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                                Colors.black.withOpacity(0.95),
                              ],
                              stops: const [0.0, 0.6, 1.0],
                            ),
                          ),
                        ),
                      ),

                      // Content
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: EdgeInsets.all(
                            ResponsiveHelper.getValue(
                              context,
                              mobile: 20,
                              tablet: 28,
                              desktop: 36,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Trend Badge
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveHelper.getValue(
                                    context,
                                    mobile: 12,
                                    tablet: 14,
                                    desktop: 16,
                                  ),
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.trending_up,
                                      size: ResponsiveHelper.getValue(
                                        context,
                                        mobile: 14,
                                        tablet: 16,
                                        desktop: 18,
                                      ),
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'TREND #${index + 1}',
                                      style: TextStyle(
                                        fontSize: ResponsiveHelper.getValue(
                                          context,
                                          mobile: 12,
                                          tablet: 13,
                                          desktop: 14,
                                        ),
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
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

                              // Title
                              Text(
                                movie.title ?? 'Başlıksız',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getHeroTitleSize(context),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),

                              // Stats
                              Wrap(
                                spacing: ResponsiveHelper.getValue(
                                  context,
                                  mobile: 12,
                                  tablet: 16,
                                  desktop: 20,
                                ),
                                runSpacing: 8,
                                children: [
                                  StatBadge(
                                    icon: Icons.star,
                                    value: movie.platformRating?.toStringAsFixed(1) ?? 'N/A',
                                    color: AppTheme.secondaryColor,
                                  ),
                                  StatBadge(
                                    icon: Icons.calendar_today,
                                    value: movie.releaseDate?.year.toString() ?? 'N/A',
                                    color: AppTheme.textSecondary,
                                  ),
                                  if (movie.runtime != null)
                                    StatBadge(
                                      icon: Icons.access_time,
                                      value: '${movie.runtime}dk',
                                      color: AppTheme.textSecondary,
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

                              // Overview (Desktop & Tablet only)
                              if (movie.overview != null && isDesktop)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    movie.overview!,
                                    style: TextStyle(
                                      fontSize: ResponsiveHelper.getBodyTextSize(context),
                                      color: AppTheme.textSecondary,
                                      height: 1.5,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                              // Buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => Get.toNamed('/movie/${movie.id}'),
                                      icon: Icon(
                                        Icons.play_arrow,
                                        size: ResponsiveHelper.getIconSize(context),
                                      ),
                                      label: const Text('Detaylar'),
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                          vertical: ResponsiveHelper.getValue(
                                            context,
                                            mobile: 12,
                                            tablet: 14,
                                            desktop: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  OutlinedButton(
                                    onPressed: () {
                                      // TODO: Add to list
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.all(
                                        ResponsiveHelper.getValue(
                                          context,
                                          mobile: 12,
                                          tablet: 14,
                                          desktop: 16,
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          ResponsiveHelper.getBorderRadius(context),
                                        ),
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: ResponsiveHelper.getIconSize(context),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Generic Movie Section
  Widget _buildMovieSection(
    BuildContext context, {
    required String title,
    String? subtitle,
    IconData? icon,
    required List movies,
    bool showBadge = false,
    String Function(dynamic)? badgeBuilder,
  }) {
    return SliverToBoxAdapter(
      child: FadeInUp(
        duration: const Duration(milliseconds: 600),
        child: Column(
          children: [
            ResponsivePadding(
              child: SectionHeader(
                title: title,
                subtitle: subtitle,
                icon: icon,
                onViewAll: () {
                  // TODO: Navigate
                },
              ),
            ),
            SizedBox(
              height: ResponsiveHelper.getMovieCardHeight(context) + 70,
              child: ListView.builder(
                padding: ResponsiveHelper.getHorizontalPadding(context),
                scrollDirection: Axis.horizontal,
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return FadeInRight(
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    child: MovieCard(
                      posterPath: movie.fullPosterUrl,
                      title: movie.title ?? 'Başlıksız',
                      year: movie.releaseYear ?? movie.releaseDate?.year.toString(),
                      rating: movie.platformRating?.toDouble(),
                      badge: showBadge && badgeBuilder != null ? badgeBuilder(movie) : null,
                      width: ResponsiveHelper.getMovieCardWidth(context),
                      height: ResponsiveHelper.getMovieCardHeight(context),
                      onTap: () => Get.toNamed('/movie/${movie.id}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Category Sections
  List<Widget> _buildCategorySections(BuildContext context) {
    final widgets = <Widget>[];

    for (var i = 0; i < controller.categories.length; i++) {
      final category = controller.categories[i];
      final movies = controller.moviesByCategory[category.id];

      if (movies == null || movies.isEmpty) continue;

      widgets.add(
        SliverToBoxAdapter(
          child: SizedBox(
            height: ResponsiveHelper.getVerticalSpacing(context),
          ),
        ),
      );

      widgets.add(
        _buildMovieSection(
          context,
          title: category.name,
          subtitle: category.description,
          movies: movies,
        ),
      );
    }

    return widgets;
  }

  // Loading State
  Widget _buildLoadingState(BuildContext context) {
    final cardWidth = ResponsiveHelper.getMovieCardWidth(context);
    final cardHeight = ResponsiveHelper.getMovieCardHeight(context);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: const Text('CineHub'),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              SizedBox(height: ResponsiveHelper.getValue(context, mobile: 20, tablet: 30, desktop: 40)),
              // Hero shimmer
              ResponsiveContainer(
                child: LoadingShimmer(
                  width: double.infinity,
                  height: ResponsiveHelper.getHeroHeight(context),
                  borderRadius: ResponsiveHelper.getBorderRadius(context, baseRadius: 24),
                ),
              ),
              SizedBox(height: ResponsiveHelper.getVerticalSpacing(context)),
              // Horizontal list shimmer
              SizedBox(
                height: cardHeight + 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: ResponsiveHelper.getHorizontalPadding(context),
                  itemCount: ResponsiveHelper.getVisibleItemCount(context),
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: LoadingShimmer(
                      width: cardWidth,
                      height: cardHeight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}