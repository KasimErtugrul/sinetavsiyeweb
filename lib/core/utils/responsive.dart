import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet, desktop }

class ResponsiveHelper {
  // Breakpoints
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1200;
  static const double desktopMaxWidth = 1920;

  // Get device type
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileMaxWidth) {
      return DeviceType.mobile;
    } else if (width < tabletMaxWidth) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  // Device type checks
  static bool isMobile(BuildContext context) =>
      getDeviceType(context) == DeviceType.mobile;

  static bool isTablet(BuildContext context) =>
      getDeviceType(context) == DeviceType.tablet;

  static bool isDesktop(BuildContext context) =>
      getDeviceType(context) == DeviceType.desktop;

  // Responsive values
  static T getValue<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  // Max content width
  static double getMaxContentWidth(BuildContext context) {
    return getValue(
      context,
      mobile: double.infinity,
      tablet: 900,
      desktop: 1400,
    );
  }

  // Horizontal padding
  static EdgeInsets getHorizontalPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: getValue(
        context,
        mobile: 16,
        tablet: 40,
        desktop: 64,
      ),
    );
  }

  // Vertical spacing
  static double getVerticalSpacing(BuildContext context) {
    return getValue(
      context,
      mobile: 32.0,
      tablet: 48.0,
      desktop: 64.0,
    );
  }

  // Grid cross axis count
  static int getGridCrossAxisCount(BuildContext context) {
    return getValue(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
    );
  }

  // Movie card dimensions
  static double getMovieCardWidth(BuildContext context) {
    return getValue(
      context,
      mobile: 140.0,
      tablet: 160.0,
      desktop: 180.0,
    );
  }

  static double getMovieCardHeight(BuildContext context) {
    return getValue(
      context,
      mobile: 210.0,
      tablet: 240.0,
      desktop: 270.0,
    );
  }

  // Hero section height
  static double getHeroHeight(BuildContext context) {
    return getValue(
      context,
      mobile: 400.0,
      tablet: 500.0,
      desktop: 600.0,
    );
  }

  // Carousel viewport fraction
  static double getCarouselViewportFraction(BuildContext context) {
    return getValue(
      context,
      mobile: 0.9,
      tablet: 0.85,
      desktop: 0.75,
    );
  }

  // Font sizes
  static double getHeroTitleSize(BuildContext context) {
    return getValue(
      context,
      mobile: 24.0,
      tablet: 32.0,
      desktop: 40.0,
    );
  }

  static double getSectionTitleSize(BuildContext context) {
    return getValue(
      context,
      mobile: 20.0,
      tablet: 24.0,
      desktop: 28.0,
    );
  }

  static double getBodyTextSize(BuildContext context) {
    return getValue(
      context,
      mobile: 14.0,
      tablet: 15.0,
      desktop: 16.0,
    );
  }

  // Horizontal list item count (visible items)
  static int getVisibleItemCount(BuildContext context) {
    return getValue(
      context,
      mobile: 2,
      tablet: 4,
      desktop: 6,
    );
  }

  // Icon sizes
  static double getIconSize(BuildContext context, {double baseSize = 24}) {
    final multiplier = getValue(
      context,
      mobile: 1.0,
      tablet: 1.1,
      desktop: 1.2,
    );
    return baseSize * multiplier;
  }

  // Border radius
  static double getBorderRadius(BuildContext context, {double baseRadius = 12}) {
    final multiplier = getValue(
      context,
      mobile: 1.0,
      tablet: 1.1,
      desktop: 1.2,
    );
    return baseRadius * multiplier;
  }
}

// Responsive Layout Widget
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveHelper.getDeviceType(context);

    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
}

// Centered content wrapper for larger screens
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? ResponsiveHelper.getMaxContentWidth(context),
        ),
        child: child,
      ),
    );
  }
}

// Responsive padding wrapper
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final bool horizontal;
  final bool vertical;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.horizontal = true,
    this.vertical = false,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = EdgeInsets.zero;

    if (horizontal) {
      padding = padding.copyWith(
        left: ResponsiveHelper.getValue(
          context,
          mobile: 16,
          tablet: 40,
          desktop: 64,
        ),
        right: ResponsiveHelper.getValue(
          context,
          mobile: 16,
          tablet: 40,
          desktop: 64,
        ),
      );
    }

    if (vertical) {
      padding = padding.copyWith(
        top: ResponsiveHelper.getValue(
          context,
          mobile: 16,
          tablet: 24,
          desktop: 32,
        ),
        bottom: ResponsiveHelper.getValue(
          context,
          mobile: 16,
          tablet: 24,
          desktop: 32,
        ),
      );
    }

    return Padding(
      padding: padding,
      child: child,
    );
  }
}