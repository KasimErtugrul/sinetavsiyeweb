class AppConstants {
  // App Info
  static const String appName = 'CineHub';
  static const String appVersion = '1.0.0';
  
  // Supabase
  static const String supabaseUrl = 'https://ynllcfcernuvwtahezxp.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlubGxjZmNlcm51dnd0YWhlenhwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg1MDg1NTcsImV4cCI6MjA4NDA4NDU1N30.73GKJSXdjnc2DltLbDiy-lu9IVrXrw9u7luWUJo7xWQ';
  
  // TMDB
  static const String tmdbApiKey = '6446e03fe7945f3dcef085c50e4127b4';
  static const String tmdbImageBase = 'https://image.tmdb.org/t/p/';
  
  // Image Sizes
  static const String posterW185 = 'w185';
  static const String posterW342 = 'w342';
  static const String posterW500 = 'w500';
  static const String backdropW780 = 'w780';
  static const String backdropW1280 = 'w1280';
  static const String backdropOriginal = 'original';
  
  // Routes
  static const String homeRoute = '/';
  static const String movieDetailRoute = '/movie';
  static const String profileRoute = '/profile';
  static const String authRoute = '/auth';
  static const String categoriesRoute = '/categories';
  static const String listsRoute = '/lists';
  static const String watchlistRoute = '/watchlist';
  
  // Pagination
  static const int itemsPerPage = 20;
  static const int maxCommentLength = 2000;
  static const int maxBioLength = 500;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
  
  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
}

class CacheKeys {
  static const String userProfile = 'user_profile';
  static const String theme = 'app_theme';
  static const String language = 'app_language';
}

class ErrorMessages {
  static const String networkError = 'İnternet bağlantınızı kontrol edin';
  static const String serverError = 'Sunucu hatası oluştu';
  static const String unknownError = 'Beklenmeyen bir hata oluştu';
  static const String authError = 'Kimlik doğrulama hatası';
  static const String notFound = 'Kayıt bulunamadı';
  static const String banned = 'Hesabınız yasaklanmış';
  static const String muted = 'Yorumlarınız geçici olarak kısıtlanmış';
}