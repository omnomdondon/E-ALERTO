class Routes {
  Routes._();
  
  // Auth routes
  static const String loginPage = '/login';
  static const String registrationPage = '/registration';

  // Main app routes
  static const String homePage = '/home';
  static const String detailPage = 'detail'; // Changed to relative path
  static const String homeDetail = '/home/detail';

  static const String searchPage = '/search';
  static const String reportPage = '/report';
  static const String notificationPage = '/notification';

  static const String profilePage = '/profile';
  static const String ratingPage = 'rating'; // Changed to relative path
  static const String settingsPage = 'settings'; // Changed to relative path
  static const String profileRating = '/profile/rating';
  static const String profileSettings = '/profile/settings';
}