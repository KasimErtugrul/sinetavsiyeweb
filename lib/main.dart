import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'core/network/supabase_client.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/logger.dart';
import 'presentation/controllers/home_controller.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Supabase
    await SupabaseService.initialize();
    AppLogger.info('App initialized successfully');
  } catch (e, stackTrace) {
    AppLogger.error('Failed to initialize app', e, stackTrace);
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1920, 1080), // Web design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'CineHub - Professional Movie Platform',
          debugShowCheckedModeBanner: false,
          
          // Theme
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          
          // Initial Binding
          initialBinding: BindingsBuilder(() {
            Get.put(ThemeController());
            Get.put(HomeController());
          }),
          
          // Routes
          initialRoute: '/',
          getPages: [
            GetPage(
              name: '/',
              page: () => const HomePage(),
              binding: BindingsBuilder(() {
                Get.put(HomeController());
              }),
            ),
          ],
          
          // Responsive breakpoints
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
              child: widget!,
            );
          },
        );
      },
    );
  }
}

// Responsive Helper
class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }
  
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 900;
  }
  
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }
  
  static double getResponsiveValue(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }
}