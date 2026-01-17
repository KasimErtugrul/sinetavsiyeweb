import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'core/network/supabase_client.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/logger.dart';
import 'presentation/controllers/home_controller.dart';
import 'presentation/controllers/movie_detail_controller.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/movie_detail_page.dart';

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
            GetPage(
              name: '/movie/:id',
              page: () {
                final id = int.parse(Get.parameters['id'] ?? '0');
                return MovieDetailPage(movieId: id);
              },
              binding: BindingsBuilder(() {
                final controller = Get.put(MovieDetailController());
                final id = int.parse(Get.parameters['id'] ?? '0');
                controller.loadMovieDetail(id);
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