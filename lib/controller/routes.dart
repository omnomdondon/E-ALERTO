class Routes {
  Routes._();
  
  // Base paths
  static const String auth = '/auth';
  
  // Auth routes
  static const String loginPage = '$auth/login';
  static const String registrationPage = '$auth/registration';

  // Main app routes
  static const String homePage = '/home';
  static const String detailPage = 'detail';
  static const String homeDetail = '$homePage/detail';

  // Feature routes
  static const String searchPage = '/search';
  static const String reportPage = '/report';
  static const String notificationPage = '/notification';

  // Profile routes
  static const String profilePage = '/profile';
  static const String ratingPage = 'rating';
  static const String settingsPage = 'settings';
  static const String profileRating = '$profilePage/rating';
  static const String profileSettings = '$profilePage/settings';
}