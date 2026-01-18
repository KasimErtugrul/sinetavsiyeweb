import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';

// Movie Card Widget
class MovieCard extends StatelessWidget {
  final String posterPath;
  final String title;
  final String? year;
  final double? rating;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final String? badge;

  const MovieCard({
    super.key,
    required this.posterPath,
    required this.title,
    this.year,
    this.rating,
    this.onTap,
    this.width,
    this.height,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final cardWidth = width ?? ResponsiveHelper.getMovieCardWidth(context);
    final cardHeight = height ?? ResponsiveHelper.getMovieCardHeight(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            // Poster
            ClipRRect(
              borderRadius: BorderRadius.circular(
                ResponsiveHelper.getBorderRadius(context),
              ),
              child: Container(
                width: cardWidth,
                height: cardHeight,
                color: AppTheme.darkCard,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: posterPath,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: AppTheme.darkCard,
                        highlightColor: AppTheme.darkSurface,
                        child: Container(color: AppTheme.darkCard),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppTheme.darkCard,
                        child: Icon(
                          Icons.movie_outlined,
                          size: ResponsiveHelper.getIconSize(context, baseSize: 48),
                          color: AppTheme.textTertiary,
                        ),
                      ),
                    ),
                    // Gradient overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: ResponsiveHelper.getValue(
                          context,
                          mobile: 50,
                          tablet: 60,
                          desktop: 70,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Rating badge
                    if (rating != null)
                      Positioned(
                        top: ResponsiveHelper.getValue(
                          context,
                          mobile: 8,
                          tablet: 10,
                          desktop: 12,
                        ),
                        right: ResponsiveHelper.getValue(
                          context,
                          mobile: 8,
                          tablet: 10,
                          desktop: 12,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.getValue(
                              context,
                              mobile: 8,
                              tablet: 9,
                              desktop: 10,
                            ),
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.getBorderRadius(context, baseRadius: 6),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                size: ResponsiveHelper.getValue(
                                  context,
                                  mobile: 12,
                                  tablet: 13,
                                  desktop: 14,
                                ),
                                color: AppTheme.secondaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                rating!.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.getValue(
                                    context,
                                    mobile: 11,
                                    tablet: 12,
                                    desktop: 13,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    // Custom badge (bottom)
                    if (badge != null)
                      Positioned(
                        bottom: ResponsiveHelper.getValue(
                          context,
                          mobile: 8,
                          tablet: 10,
                          desktop: 12,
                        ),
                        left: ResponsiveHelper.getValue(
                          context,
                          mobile: 8,
                          tablet: 10,
                          desktop: 12,
                        ),
                        right: ResponsiveHelper.getValue(
                          context,
                          mobile: 8,
                          tablet: 10,
                          desktop: 12,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveHelper.getValue(
                              context,
                              mobile: 8,
                              tablet: 9,
                              desktop: 10,
                            ),
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(
                              ResponsiveHelper.getBorderRadius(context, baseRadius: 6),
                            ),
                          ),
                          child: Text(
                            badge!,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.getValue(
                                context,
                                mobile: 10,
                                tablet: 11,
                                desktop: 12,
                              ),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: ResponsiveHelper.getValue(
                context,
                mobile: 8,
                tablet: 10,
                desktop: 12,
              ),
            ),
            // Title
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ResponsiveHelper.getValue(
                  context,
                  mobile: 13,
                  tablet: 14,
                  desktop: 15,
                ),
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
                height: 1.3,
              ),
            ),
            if (year != null) ...[
              const SizedBox(height: 4),
              Text(
                year!,
                style: TextStyle(
                  fontSize: ResponsiveHelper.getValue(
                    context,
                    mobile: 11,
                    tablet: 12,
                    desktop: 13,
                  ),
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Section Header
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onViewAll;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveHelper.getValue(
          context,
          mobile: 12,
          tablet: 14,
          desktop: 16,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                if (icon != null) ...[
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
                        ResponsiveHelper.getBorderRadius(context, baseRadius: 10),
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: ResponsiveHelper.getValue(
                        context,
                        mobile: 18,
                        tablet: 20,
                        desktop: 22,
                      ),
                      color: Colors.white,
                    ),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getSectionTitleSize(context),
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.getValue(
                              context,
                              mobile: 13,
                              tablet: 14,
                              desktop: 15,
                            ),
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Tümünü Gör',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.getValue(
                        context,
                        mobile: 13,
                        tablet: 14,
                        desktop: 15,
                      ),
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveHelper.getValue(
                      context,
                      mobile: 4,
                      tablet: 5,
                      desktop: 6,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: ResponsiveHelper.getValue(
                      context,
                      mobile: 12,
                      tablet: 13,
                      desktop: 14,
                    ),
                    color: AppTheme.primaryColor,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// Loading Shimmer
class LoadingShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double? borderRadius;

  const LoadingShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.darkCard,
      highlightColor: AppTheme.darkSurface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppTheme.darkCard,
          borderRadius: BorderRadius.circular(
            borderRadius ?? ResponsiveHelper.getBorderRadius(context),
          ),
        ),
      ),
    );
  }
}

// Empty State
class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          ResponsiveHelper.getValue(
            context,
            mobile: 32,
            tablet: 48,
            desktop: 64,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: ResponsiveHelper.getValue(
                context,
                mobile: 72,
                tablet: 84,
                desktop: 96,
              ),
              color: AppTheme.textTertiary,
            ),
            SizedBox(
              height: ResponsiveHelper.getValue(
                context,
                mobile: 20,
                tablet: 24,
                desktop: 28,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveHelper.getValue(
                  context,
                  mobile: 18,
                  tablet: 20,
                  desktop: 22,
                ),
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: ResponsiveHelper.getValue(
                context,
                mobile: 10,
                tablet: 12,
                desktop: 14,
              ),
            ),
            Text(
              message,
              style: TextStyle(
                fontSize: ResponsiveHelper.getBodyTextSize(context),
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null) ...[
              SizedBox(
                height: ResponsiveHelper.getValue(
                  context,
                  mobile: 28,
                  tablet: 32,
                  desktop: 36,
                ),
              ),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel ?? 'Yeniden Dene'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Error State
class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: 'Bir Hata Oluştu',
      message: message,
      icon: Icons.error_outline,
      onAction: onRetry,
      actionLabel: 'Yeniden Dene',
    );
  }
}

// Category Chip
class CategoryChip extends StatelessWidget {
  final String label;
  final Color? color;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.label,
    this.color,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getValue(
            context,
            mobile: 14,
            tablet: 16,
            desktop: 18,
          ),
          vertical: ResponsiveHelper.getValue(
            context,
            mobile: 8,
            tablet: 9,
            desktop: 10,
          ),
        ),
        margin: EdgeInsets.only(
          right: ResponsiveHelper.getValue(
            context,
            mobile: 8,
            tablet: 10,
            desktop: 12,
          ),
        ),
        decoration: BoxDecoration(
          color: isSelected ? color ?? AppTheme.primaryColor : AppTheme.darkCard,
          borderRadius: BorderRadius.circular(
            ResponsiveHelper.getBorderRadius(context, baseRadius: 20),
          ),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : AppTheme.textTertiary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveHelper.getValue(
              context,
              mobile: 13,
              tablet: 14,
              desktop: 15,
            ),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }
}

// Stat Badge
class StatBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color? color;

  const StatBadge({
    super.key,
    required this.icon,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: ResponsiveHelper.getValue(
            context,
            mobile: 14,
            tablet: 15,
            desktop: 16,
          ),
          color: color ?? AppTheme.textSecondary,
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveHelper.getValue(
              context,
              mobile: 12,
              tablet: 13,
              desktop: 14,
            ),
            color: color ?? AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}