import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import '../controllers/movie_detail_controller.dart';
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

        return ResponsiveLayout(
          mobile: _buildMobileLayout(context),
          tablet: _buildTabletLayout(context),
          desktop: _buildDesktopLayout(context),
        );
      }),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final movie = controller.movie!;
    
    return CustomScrollView(
      slivers: [
        _buildAppBar(context),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroSection(context, movie),
              SizedBox(height: 24.h),
              _buildInfoSection(context, movie),
              SizedBox(height: 24.h),
              _buildStatsSection(context, movie),
              SizedBox(height: 24.h),
              _buildOverviewSection(context, movie),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    final movie = controller.movie!;
    
    return CustomScrollView(
      slivers: [
        _buildAppBar(context),
        SliverToBoxAdapter(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroSection(context, movie),
                  const SizedBox(height: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildInfoSection(context, movie)),
                      const SizedBox(width: 24),
                      Expanded(child: _buildStatsSection(context, movie)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _buildOverviewSection(context, movie),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final movie = controller.movie!;
    
    return CustomScrollView(
      slivers: [
        _buildAppBar(context),
        SliverToBoxAdapter(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              padding: const EdgeInsets.symmetric(horizontal: 64),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 400,
                        child: _buildPosterCard(context, movie),
                      ),
                      const SizedBox(width: 48),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitleSection(context, movie),
                            const SizedBox(height: 24),
                            _buildInfoSection(context, movie),
                            const SizedBox(height: 32),
                            _buildStatsSection(context, movie),
                            const SizedBox(height: 32),
                            _buildOverviewSection(context, movie),
                            const SizedBox(height: 32),
                            _buildActionButtons(context, movie),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    return SliverAppBar(
      floating: true,
      backgroundColor: AppTheme.darkBackground.withOpacity(0.95),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Get.back(),
      ),
      title: isMobile
          ? Text(
              controller.movie?.title ?? '',
              style: TextStyle(fontSize: 18.sp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.bookmark_border),
          onPressed: controller.toggleWatchlist,
        ),
        SizedBox(width: isMobile ? 8.w : 16),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context, movie) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    return Container(
      height: isMobile ? 400.h : 500,
      margin: EdgeInsets.symmetric(horizontal: isMobile ? 16.w : 0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(isMobile ? 24.r : 24),
            child: Container(
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
          ),
          if (isMobile)
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
                    if (movie.categoryName != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          movie.categoryName!,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    SizedBox(height: 12.h),
                    Text(
                      movie.title,
                      style: TextStyle(
                        fontSize: 28.sp,
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
                        if (movie.platformRating != null)
                          StatBadge(
                            icon: Icons.star,
                            value: movie.platformRating!.toStringAsFixed(1),
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
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPosterCard(BuildContext context, movie) {
    return FadeInLeft(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            movie.fullPosterUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context, movie) {
    return FadeInRight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (movie.categoryName != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                movie.categoryName!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            movie.title,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
              height: 1.2,
            ),
          ),
          if (movie.originalTitle != null &&
              movie.originalTitle != movie.title) ...[
            const SizedBox(height: 8),
            Text(
              movie.originalTitle!,
              style: TextStyle(
                fontSize: 20,
                color: AppTheme.textSecondary.withOpacity(0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          if (movie.tagline != null) ...[
            const SizedBox(height: 16),
            Text(
              '"${movie.tagline}"',
              style: const TextStyle(
                fontSize: 18,
                color: AppTheme.secondaryColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, movie) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    return FadeInUp(
      child: Container(
        padding: EdgeInsets.all(isMobile ? 20.w : 24),
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(isMobile ? 16.r : 16),
          border: Border.all(
            color: AppTheme.textTertiary.withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bilgiler',
              style: TextStyle(
                fontSize: isMobile ? 18.sp : 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: isMobile ? 16.h : 16),
            _buildInfoRow(
              icon: Icons.calendar_today,
              label: 'Yayın Tarihi',
              value: movie.releaseDate?.toString().split(' ')[0] ?? 'Bilinmiyor',
              isMobile: isMobile,
            ),
            if (movie.runtime != null) ...[
              SizedBox(height: isMobile ? 12.h : 12),
              _buildInfoRow(
                icon: Icons.access_time,
                label: 'Süre',
                value: '${movie.runtime} dakika',
                isMobile: isMobile,
              ),
            ],
            if (movie.platformRating != null) ...[
              SizedBox(height: isMobile ? 12.h : 12),
              _buildInfoRow(
                icon: Icons.star,
                label: 'Platform Puanı',
                value:
                    '${movie.platformRating!.toStringAsFixed(1)} (${movie.platformRatingCount} oy)',
                isMobile: isMobile,
              ),
            ],
            if (movie.tmdbVoteAverage != null) ...[
              SizedBox(height: isMobile ? 12.h : 12),
              _buildInfoRow(
                icon: Icons.movie,
                label: 'TMDB Puanı',
                value: movie.tmdbVoteAverage!.toStringAsFixed(1),
                isMobile: isMobile,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isMobile,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isMobile ? 8.w : 8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(isMobile ? 8.r : 8),
          ),
          child: Icon(
            icon,
            size: isMobile ? 16.sp : 16,
            color: AppTheme.primaryColor,
          ),
        ),
        SizedBox(width: isMobile ? 12.w : 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isMobile ? 12.sp : 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              SizedBox(height: isMobile ? 2.h : 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: isMobile ? 14.sp : 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context, movie) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    return FadeInUp(
      delay: const Duration(milliseconds: 100),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 20.w : 24),
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(isMobile ? 16.r : 16),
          border: Border.all(
            color: AppTheme.textTertiary.withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'İstatistikler',
              style: TextStyle(
                fontSize: isMobile ? 18.sp : 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: isMobile ? 16.h : 16),
            Wrap(
              spacing: isMobile ? 16.w : 24,
              runSpacing: isMobile ? 16.h : 16,
              children: [
                _buildStatItem(
                  icon: Icons.visibility,
                  label: 'Görüntülenme',
                  value: movie.viewCount.toString(),
                  isMobile: isMobile,
                ),
                _buildStatItem(
                  icon: Icons.comment,
                  label: 'Yorum',
                  value: movie.commentCount.toString(),
                  isMobile: isMobile,
                ),
                _buildStatItem(
                  icon: Icons.thumb_up,
                  label: 'Beğeni',
                  value: movie.likeCount.toString(),
                  isMobile: isMobile,
                ),
                _buildStatItem(
                  icon: Icons.thumb_down,
                  label: 'Beğenmeme',
                  value: movie.dislikeCount.toString(),
                  isMobile: isMobile,
                ),
                _buildStatItem(
                  icon: Icons.list,
                  label: 'Liste',
                  value: movie.listCount.toString(),
                  isMobile: isMobile,
                ),
                _buildStatItem(
                  icon: Icons.bookmark,
                  label: 'İzlenecek',
                  value: movie.watchlistCount.toString(),
                  isMobile: isMobile,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isMobile,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(isMobile ? 12.w : 12),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(isMobile ? 12.r : 12),
          ),
          child: Icon(
            icon,
            size: isMobile ? 20.sp : 20,
            color: Colors.white,
          ),
        ),
        SizedBox(height: isMobile ? 8.h : 8),
        Text(
          value,
          style: TextStyle(
            fontSize: isMobile ? 16.sp : 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        SizedBox(height: isMobile ? 2.h : 2),
        Text(
          label,
          style: TextStyle(
            fontSize: isMobile ? 11.sp : 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewSection(BuildContext context, movie) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    if (movie.overview == null) return const SizedBox.shrink();

    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 20.w : 24),
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(isMobile ? 16.r : 16),
          border: Border.all(
            color: AppTheme.textTertiary.withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Konu',
              style: TextStyle(
                fontSize: isMobile ? 18.sp : 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: isMobile ? 12.h : 16),
            Text(
              movie.overview!,
              style: TextStyle(
                fontSize: isMobile ? 14.sp : 16,
                color: AppTheme.textSecondary,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, movie) {
    return FadeInUp(
      delay: const Duration(milliseconds: 300),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => controller.toggleLike(true),
              icon: const Icon(Icons.thumb_up),
              label: const Text('Beğen'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => controller.toggleLike(false),
              icon: const Icon(Icons.thumb_down),
              label: const Text('Beğenme'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    
    return CustomScrollView(
      slivers: [
        _buildAppBar(context),
        SliverToBoxAdapter(
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: ResponsiveHelper.getMaxWidth(context),
              ),
              padding: ResponsiveHelper.getHorizontalPadding(context),
              child: Column(
                children: [
                  SizedBox(height: isMobile ? 20.h : 40),
                  LoadingShimmer(
                    width: double.infinity,
                    height: isMobile ? 400.h : 500,
                    borderRadius: isMobile ? 24.r : 24,
                  ),
                  SizedBox(height: isMobile ? 24.h : 32),
                  LoadingShimmer(
                    width: double.infinity,
                    height: isMobile ? 200.h : 200,
                    borderRadius: isMobile ? 16.r : 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
