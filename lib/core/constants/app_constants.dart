/// App-wide constants
class AppConstants {
  // url
  static const String supportUrl = 'https://api.github.com';
  static const String ratingUrl = 'https://github.com';
  static const String developerPortfolioUrl =
      'https://salahuddinjony.github.io/';
  // about app
  static const String aboutText =
      'Repo Finder - A beautiful Flutter app to explore GitHub profiles, repositories, and contributions.';

  static final int currentYear = DateTime.now().year;
  static String get copyrightText =>
      '© $currentYear Salah. All rights reserved.';

  // App Info
  static const String appName = 'Repo Finder';
  static const String appVersion = '1.0.0';

  // Storage Keys
  static const String themeKey = 'app_theme';
  static const String lastUsernameKey = 'last_username';

  // Padding & Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;

  // Icon Sizes
  static const double iconSizeSmall = 20.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;

  // Avatar Sizes
  static const double avatarSizeSmall = 40.0;
  static const double avatarSizeMedium = 60.0;
  static const double avatarSizeLarge = 100.0;

  // Animation Durations
  static const Duration animationDurationShort = Duration(milliseconds: 200);
  static const Duration animationDurationMedium = Duration(milliseconds: 300);
  static const Duration animationDurationLong = Duration(milliseconds: 500);
}
