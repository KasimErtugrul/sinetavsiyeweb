import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

        // Check if all data is empty
        final hasData = controller.trendingMovies.isNotEmpty ||
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = ResponsiveHelper.isMobile(context);
              
              return CustomScrollView(
                controller: controller.scrollController,
                slivers: [
                  _buildAppBar(context),
                  SliverToBoxAdapter(child: SizedBox(height: isMobile ? 20.h : 20)),
                  
                  // Hero Section - Trending Movies
                  if (controller.trendingMovies.isNotEmpty)
                    _buildHeroSection(context),
                  
                  SliverToBoxAdapter(child: SizedBox(height: isMobile ? 32.h : 48)),
                  
                  // Popular Movies Section
                  if (controller.popularMovies.isNotEmpty)
                    _buildPopularSection(context),
                  
                  SliverToBoxAdapter(child: SizedBox(height: isMobile ? 32.h : 48)),
                  
                  // Most Commented Movies Section
                  if (controller.mostCommentedMovies.isNotEmpty)
                    _buildMostCommentedSection(context),
                  
                  SliverToBoxAdapter(child: SizedBox(height: isMobile ? 32.h : 48)),
                  
                  // Top Rated Movies Section
                  if (controller.topRatedMovies.isNotEmpty)
                    _buildTopRatedSection(context),
                  
                  SliverToBoxAdapter(child: SizedBox(height: isMobile ? 32.h : 48)),
                  
                  // Most Viewed Movies Section
                  if (controller.mostViewedMovies.isNotEmpty)
                    _buildMostViewedSection(context),
                  
                  SliverToBoxAdapter(child: SizedBox(height: isMobile ? 32.h : 48)),
                  
                  // Controversial Movies Section
                  if (controller.controversialMovies.isNotEmpty)
                    _buildControversialSection(context),
                  
                  // Categories Sections
                  ..._buildCategorySections(context),
                  
                  // Loading More Indicator
                  SliverToBoxAdapter(
                    child: Obx(() {
                      if (controller.isLoadingMore) {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Daha fazla yükleniyor...',
                                style: TextStyle(
                                  fontSize: 14.sp,
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
                  
                  SliverToBoxAdapter(child: SizedBox(height: isMobile ? 40.h : 80)),
                ],
              );
            },
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
    
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppTheme.darkBackground.withOpacity(0.95),
      elevation: 0,
      title: FadeInDown(
        duration: const Duration(milliseconds: 600),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.local_movies,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'CineHub',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
      actions: [
        FadeInDown(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 100),
          child: IconButton(
            icon: Icon(Icons.search, size: 24.sp),
            onPressed: () {
              // TODO: Navigate to search
            },
          ),
        ),
        FadeInDown(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 200),
          child: IconButton(
            icon: Icon(Icons.notifications_outlined, size: 24.sp),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ),
        // User Profile / Login Button
        FadeInDown(
          duration: const Duration(milliseconds: 600),
          delay: const Duration(milliseconds: 300),
          child: Obx(() {
            if (authController.isAuthenticated) {
              // User is logged in - Show profile avatar
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: InkWell(
                  onTap: () {
                    Get.toNamed('/profile');
                  },
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: CircleAvatar(
                      radius: 18.r,
                      backgroundColor: AppTheme.darkCard,
                      backgroundImage: authController.currentUser?.userMetadata?['avatar_url'] != null
                          ? NetworkImage(authController.currentUser!.userMetadata!['avatar_url'])
                          : null,
                      child: authController.currentUser?.userMetadata?['avatar_url'] == null
                          ? Icon(Icons.person, size: 20.sp, color: AppTheme.textSecondary)
                          : null,
                    ),
                  ),
                ),
              );
            } else {
              // User not logged in - Show login button
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: TextButton.icon(
                  onPressed: () {
                    Get.toNamed('/auth/login');
                  },
                  icon: Icon(Icons.login, size: 20.sp),
                  label: Text(
                    'Giriş',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  ),
                ),
              );
            }
          }),
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  // Hero Section - Featured/Trending (Carousel)
  Widget _buildHeroSection(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    return SliverToBoxAdapter(
      child: FadeIn(
        duration: const Duration(milliseconds: 800),
        child: CarouselSlider.builder(
          itemCount: controller.trendingMovies.length,
          options: CarouselOptions(
            height: isMobile ? 400.h : 600,
            viewportFraction: isMobile ? 0.9 : 0.85,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
          ),
          itemBuilder: (context, index, realIndex) {
            final movie = controller.trendingMovies[index];
            
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: Stack(
                  children: [
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
                    
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.trending_up,
                                    size: 16.sp,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    'TREND #${index + 1}',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                            
                            Text(
                              movie.title ?? 'Başlıksız',
                              style: TextStyle(
                                fontSize: isMobile ? 24.sp : 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 12.h),
                            
                            Row(
                              children: [
                                StatBadge(
                                  icon: Icons.star,
                                  value: movie.platformRating?.toStringAsFixed(1) ?? 'N/A',
                                  color: AppTheme.secondaryColor,
                                ),
                                SizedBox(width: 16.w),
                                StatBadge(
                                  icon: Icons.calendar_today,
                                  value: movie.releaseYear,
                                  color: AppTheme.textSecondary,
                                ),
                                if (movie.runtime != null) ...[
                                  SizedBox(width: 16.w),
                                  StatBadge(
                                    icon: Icons.access_time,
                                    value: '${movie.runtime}dk',
                                    color: AppTheme.textSecondary,
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: 16.h),
                            
                            if (movie.overview != null && !isMobile)
                              Text(
                                movie.overview!,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppTheme.textSecondary,
                                  height: 1.5,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (!isMobile) SizedBox(height: 20.h),
                            
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Get.toNamed('/movie/${movie.id}');
                                    },
                                    icon: Icon(Icons.play_arrow, size: 24.sp),
                                    label: const Text('Detaylar'),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(vertical: isMobile ? 12.h : 14),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                OutlinedButton(
                                  onPressed: () {
                                    // TODO: Add to list
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.all(isMobile ? 12.w : 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  child: Icon(Icons.add, size: 24.sp),
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
    );
  }

  // Popular Movies Section
  Widget _buildPopularSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: FadeInUp(
        duration: const Duration(milliseconds: 600),
        child: Column(
          children: [
            SectionHeader(
              title: 'Popüler Filmler',
              subtitle: 'En çok beğenilen filmler',
              onViewAll: () {
                // TODO: Navigate to all popular
              },
            ),
            SizedBox(
              height: 280.h,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                scrollDirection: Axis.horizontal,
                itemCount: controller.popularMovies.length,
                itemBuilder: (context, index) {
                  final movie = controller.popularMovies[index];
                  return FadeInRight(
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    child: MovieCard(
                      posterPath: movie.fullPosterUrl,
                      title: movie.title ?? 'Başlıksız',
                      year: movie.releaseYear,
                      rating: movie.platformRating,
                      onTap: () {
                        Get.toNamed('/movie/${movie.id}');
                      },
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

  // Most Commented Movies Section
  Widget _buildMostCommentedSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: FadeInUp(
        duration: const Duration(milliseconds: 600),
        child: Column(
          children: [
            SectionHeader(
              title: 'En Çok Yorumlanan',
              subtitle: 'Tartışılan filmler',
              icon: Icons.comment_outlined,
              onViewAll: () {
                // TODO: Navigate to all most commented
              },
            ),
            SizedBox(
              height: 280.h,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                scrollDirection: Axis.horizontal,
                itemCount: controller.mostCommentedMovies.length,
                itemBuilder: (context, index) {
                  final movie = controller.mostCommentedMovies[index];
                  return FadeInRight(
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    child: MovieCard(
                      posterPath: movie.fullPosterUrl,
                      title: movie.title ?? 'Başlıksız',
                      year: movie.releaseYear,
                      rating: movie.platformRating,
                      badge: '${movie.commentCount} yorum',
                      onTap: () {
                        Get.toNamed('/movie/${movie.id}');
                      },
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

  // Top Rated Movies Section
  Widget _buildTopRatedSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: FadeInUp(
        duration: const Duration(milliseconds: 600),
        child: Column(
          children: [
            SectionHeader(
              title: 'En Yüksek Puanlı',
              subtitle: 'IMDb favorileri',
              icon: Icons.star,
              onViewAll: () {
                // TODO: Navigate to all top rated
              },
            ),
            SizedBox(
              height: 280.h,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                scrollDirection: Axis.horizontal,
                itemCount: controller.topRatedMovies.length,
                itemBuilder: (context, index) {
                  final movie = controller.topRatedMovies[index];
                  return FadeInRight(
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    child: MovieCard(
                      posterPath: movie.fullPosterUrl,
                      title: movie.title ?? 'Başlıksız',
                      year: movie.releaseYear,
                      rating: movie.platformRating,
                      onTap: () {
                        Get.toNamed('/movie/${movie.id}');
                      },
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

  // Most Viewed Movies Section
  Widget _buildMostViewedSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: FadeInUp(
        duration: const Duration(milliseconds: 600),
        child: Column(
          children: [
            SectionHeader(
              title: 'En Çok İzlenen',
              subtitle: 'Popüler tercihler',
              icon: Icons.visibility_outlined,
              onViewAll: () {
                // TODO: Navigate to all most viewed
              },
            ),
            SizedBox(
              height: 280.h,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                scrollDirection: Axis.horizontal,
                itemCount: controller.mostViewedMovies.length,
                itemBuilder: (context, index) {
                  final movie = controller.mostViewedMovies[index];
                  return FadeInRight(
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    child: MovieCard(
                      posterPath: movie.fullPosterUrl,
                      title: movie.title ?? 'Başlıksız',
                      year: movie.releaseYear,
                      rating: movie.platformRating,
                      badge: '${movie.viewCount} görüntüleme',
                      onTap: () {
                        Get.toNamed('/movie/${movie.id}');
                      },
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

  // Controversial Movies Section
  Widget _buildControversialSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: FadeInUp(
        duration: const Duration(milliseconds: 600),
        child: Column(
          children: [
            SectionHeader(
              title: 'Tartışmalı Filmler',
              subtitle: 'Fikir ayrılığı yaratan yapımlar',
              icon: Icons.question_mark,
              onViewAll: () {
                // TODO: Navigate to all controversial
              },
            ),
            SizedBox(
              height: 280.h,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                scrollDirection: Axis.horizontal,
                itemCount: controller.controversialMovies.length,
                itemBuilder: (context, index) {
                  final movie = controller.controversialMovies[index];
                  return FadeInRight(
                    duration: Duration(milliseconds: 400 + (index * 100)),
                    child: MovieCard(
                      posterPath: movie.fullPosterUrl,
                      title: movie.title ?? 'Başlıksız',
                      year: movie.releaseYear,
                      rating: movie.platformRating,
                      onTap: () {
                        Get.toNamed('/movie/${movie.id}');
                      },
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
    final isMobile = ResponsiveHelper.isMobile(context);
    
    for (var i = 0; i < controller.categories.length; i++) {
      final category = controller.categories[i];
      final movies = controller.moviesByCategory[category.id];
      
      if (movies == null || movies.isEmpty) continue;
      
      widgets.add(
        SliverToBoxAdapter(
          child: FadeInUp(
            duration: const Duration(milliseconds: 600),
            delay: Duration(milliseconds: i * 100),
            child: Column(
              children: [
                SizedBox(height: isMobile ? 32.h : 48),
                SectionHeader(
                  title: category.name,
                  subtitle: category.description,
                  onViewAll: () {
                    // TODO: Navigate to category
                  },
                ),
                SizedBox(
                  height: isMobile ? 280.h : 320,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 20.w : 64),
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return MovieCard(
                        posterPath: movie.fullPosterUrl,
                        title: movie.title ?? 'Başlıksız',
                        year: movie.releaseYear,
                        rating: movie.platformRating,
                        onTap: () {
                          Get.toNamed('/movie/${movie.id}');
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return widgets;
  }

  // Loading State
  Widget _buildLoadingState(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          title: Text('CineHub'),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              // Hero shimmer
              LoadingShimmer(
                width: double.infinity,
                height: 500.h,
                borderRadius: 24.r,
              ),
              SizedBox(height: 32.h),
              // Horizontal list shimmer
              SizedBox(
                height: 280.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: 5,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: LoadingShimmer(
                      width: 140.w,
                      height: 280.h,
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