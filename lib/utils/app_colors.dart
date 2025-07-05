import 'package:flutter/material.dart';
import 'package:smartbecho/services/theme_config.dart';
import 'package:smartbecho/utils/app_styles.dart';

class AppTheme {
  // Light Theme Colors
  static const Color primaryLight = Color(0xFF6C5CE7);
  static const Color primaryVariantLight = Color(0xFFA29BFE);
  static const Color secondaryLight = Color(0xFF00CEC9);
  static const Color secondaryVariantLight = Color(0xFF55EFC4);
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF8F9FA);
  static const Color cardLight = Color(0xFFF8F9FA);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color onBackgroundLight = Color(0xFF1A1A1A);
  static const Color onSurfaceLight = Color(0xFF2D3436);
  static const Color errorLight = Color(0xFFFF7675);
  static const Color successLight = Color(0xFF00B894);
  static const Color warningLight = Color(0xFFFFB347);
  static const Color infoLight = Color(0xFF74B9FF);

  // Dark Theme Colors
  static const Color primaryDark = Color(0xFF8B7CF6);
  static const Color primaryVariantDark = Color(0xFFB4A7F7);
  static const Color secondaryDark = Color(0xFF14B8A6);
  static const Color secondaryVariantDark = Color(0xFF5EEAD4);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color cardDark = Color(0xFF334155);
  static const Color onPrimaryDark = Color(0xFFFFFFFF);
  static const Color onSecondaryDark = Color(0xFFFFFFFF);
  static const Color onBackgroundDark = Color(0xFFF1F5F9);
  static const Color onSurfaceDark = Color(0xFFE2E8F0);
  static const Color errorDark = Color(0xFFEF4444);
  static const Color successDark = Color(0xFF10B981);
  static const Color warningDark = Color(0xFFF59E0B);
  static const Color infoDark = Color(0xFF3B82F6);

  // Gradient Colors
  static const List<Color> primaryGradientLight = [
    Color(0xFF6C5CE7),
    Color(0xFFA29BFE),
  ];
  static const List<Color> secondaryGradientLight = [
    Color(0xFF00CEC9),
    Color(0xFF55EFC4),
  ];
  static const List<Color> errorGradientLight = [
    Color(0xFFFF7675),
    Color(0xFFFF9F9F),
  ];
  static const List<Color> successGradientLight = [
    Color(0xFF00B894),
    Color(0xFF55EFC4),
  ];
  static const List<Color> infoGradientLight = [
    Color(0xFF74B9FF),
    Color(0xFF00B894),
  ];

  static const List<Color> primaryGradientDark = [
    Color(0xFF8B7CF6),
    Color(0xFFB4A7F7),
  ];
  static const List<Color> secondaryGradientDark = [
    Color(0xFF14B8A6),
    Color(0xFF5EEAD4),
  ];
  static const List<Color> errorGradientDark = [
    Color(0xFFEF4444),
    Color(0xFFF87171),
  ];
  static const List<Color> successGradientDark = [
    Color(0xFF10B981),
    Color(0xFF6EE7B7),
  ];
  static const List<Color> infoGradientDark = [
    Color(0xFF3B82F6),
    Color(0xFF60A5FA),
  ];

  // new add colors
  //    color: Colors.white70,
    static const Color white70 = Color(0xB3FFFFFF);

  static const Color black87 = Color(0xDD000000);
  //

  static const Color primarygrey = Color(0xFF9E9E9E);
//Colors.grey[25]

  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // color: AppTheme.greyOpacity05,
  static const Color greyOpacity01 = Color(0x1A9E9E9E);
  static const Color greyOpacity02 = Color(0x339E9E9E);
  static const Color greyOpacity03 = Color(0x4D9E9E9E);
  static const Color greyOpacity04 = Color(0x669E9E9E);
  static const Color greyOpacity05 = Color(0x0D9E9E9E);
  static const Color greyOpacity06 = Color(0x0F9E9E9E);
  static const Color greyOpacity07 = Color(0x129E9E9E);
  static const Color greyOpacity08 = Color(0x149E9E9E);
  static const Color greyOpacity09 = Color(0xE69E9E9E);

  ///color: AppTheme.primaryRed,
  static const Color primaryRed = Colors.red;

  //AppTheme.red600
  static const Color red600 = Color(0xFFE53935);
  // const Color(0xFFEF4444),
  static const Color red500 = Color(0xFFEF4444);

  // color: Colors.red.shade300,||  color: Colors.red[300],
  static const Color red300 = Color(0xFFE57373);

  //Colors.red[400]||color: Colors.red[400],
  static const Color red400 = Color(0xFFEF5350);

  ////Colors.red[200]||color: Colors.red[200]
  static const Color red200 = Color(0xFFEF9A9A);

  ////Colors.red[700]||color: Colors.red[700]
  static const Color red700 = Color(0xFFD32F2F);
  // color: Colors.red[800],
  static const Color red800 = Color(0xFFC62828);

  ////color: Colors.red[50],
  static const Color red50 = Color(0xFFFFEBEE);

  //Color(0xFFEF4444).withOpacity(0.1),
  static const Color redOpacity01 = Color(0x1AEF4444);
  static const Color redOpacity02 = Color(0x33EF4444);
  static const Color redOpacity03 = Color(0x4DEF4444);
  static const Color redOpacity04 = Color(0x66EF4444);
  static const Color redOpacity05 = Color(0x80EF4444);
  static const Color redOpacity06 = Color(0x99EF4444);
  static const Color redOpacity07 = Color(0xB3EF4444);
  static const Color redOpacity08 = Color(0xCCEF4444);
  static const Color redOpacity09 = Color(0xE6EF4444);

  // color: const Color(0xFF4CAF50) == color: AppTheme.primaryGreen[500],

  //transparent colors
  static const Color transparent = Color(0x00000000);

  ///color: Colors.amber,
  static const Color primaryAmber = Colors.amber;
  static const Color primaryGreen = Colors.green;
  //AppTheme.primaryGreen.shade300,
  static const Color green300 = Color(0xFF81C784);
  // color: const Color(0xFF4CAF50) == color: AppTheme.primaryGreen[500],
  static const Color green500 = Color(0xFF4CAF50);
  //color: Colors.green[200],
  static const Color green200 = Color(0xFFA5D6A7);
  //  color: Colors.green[600],
  static const Color green600 = Color(0xFF43A047);

  //color: Colors.green[700],
  static const Color green700 = Color(0xFF388E3C);
  //color: Colors.green[50],
  static const Color green50 = Color(0xFFE8F5E9);

  static const Color primaryBlue = Colors.blue;
  //color:AppTheme.primaryBlue.shade300,
  static const Color blue300 = Color(0xFF64B5F6);
  // color: Colors.blue.shade400,|| color: Colors.blue[400],
  static const Color blue400 = Color(0xFF42A5F5);

  // Blue shade50 with opacity variants
  static const Color blue50Opacity10 = Color(0x1AE3F2FD); // 10%
  static const Color blue50Opacity20 = Color(0x33E3F2FD); // 20%
  static const Color blue50Opacity30 = Color(0x4DE3F2FD); // 30%
  static const Color blue50Opacity40 = Color(0x66E3F2FD); // 40%
  static const Color blue50Opacity50 = Color(0x80E3F2FD); // 50%
  static const Color blue50Opacity60 = Color(0x99E3F2FD); // 60%
  static const Color blue50Opacity70 = Color(0xB3E3F2FD); // 70%
  static const Color blue50Opacity80 = Color(0xCCE3F2FD); // 80%
  static const Color blue50Opacity90 = Color(0xE6E3F2FD); // 90%

  // Blue shade50 with opacity variants
  static const Color blue100Opacity10 = Color(0x1ABBDEFB); // 10%
  static const Color blue100Opacity20 = Color(0x33BBDEFB); // 20%
  static const Color blue100Opacity30 = Color(0x4DBBDEFB); // 30%
  static const Color blue100Opacity40 = Color(0x66BBDEFB); // 40%
  static const Color blue100Opacity50 = Color(0x80BBDEFB); // 50%
  static const Color blue100Opacity60 = Color(0x99BBDEFB); // 60%
  static const Color blue100Opacity70 = Color(0xB3BBDEFB); // 70%
  static const Color blue100Opacity80 = Color(0xCCBBDEFB); // 80%
  static const Color blue100Opacity90 = Color(0xE6BBDEFB); // 90%

  // color: Colors.blue[600],
  static const Color blue600 = Color(0xFF1E88E5);

  static const Color primaryOrange = Colors.orange;
  static const Color primaryPurple = Colors.purple;
  //color: Colors.purple[400],||color: Colors.purple.shade400,
  static const Color purple400 = Color(0xFFAB47BC);

  // Border Colors
  static Color borderLight = const Color(0xFFE0E0E0);
  static Color borderDark = const Color(0xFF475569);

  // Text Colors
  static Color textPrimaryLight = const Color(0xDD000000);
  static Color textSecondaryLight = const Color(0xFF757575);
  static Color textHintLight = const Color(0xFF9E9E9E);

  static Color textPrimaryDark = const Color(0xFFF1F5F9);
  static Color textSecondaryDark = const Color(0xFFCBD5E1);
  static Color textHintDark = const Color(0xFF94A3B8);

  // Shadow Colors
  static Color shadowLight = const Color(0xFF000000).withOpacity(0.05);
  static Color shadowDark = const Color(0xFF000000).withOpacity(0.3);

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryLight,
    scaffoldBackgroundColor: backgroundLight,

    colorScheme: const ColorScheme.light(
      primary: primaryLight,
      secondary: secondaryLight,
      surface: surfaceLight,
      background: backgroundLight,
      error: errorLight,
      onPrimary: onPrimaryLight,
      onSecondary: onSecondaryLight,
      onSurface: onSurfaceLight,
      onBackground: onBackgroundLight,
      onError: AppTheme.backgroundLight,
    ),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceLight,
      foregroundColor: onSurfaceLight,
      elevation: 0,
      shadowColor: shadowLight,
      titleTextStyle: AppStyles.custom(
        color: textPrimaryLight,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: textPrimaryLight),
    ),

    // Card Theme
    // cardTheme: CardTheme(
    //   color: cardLight,
    //   elevation: 2,
    //   shadowColor: shadowLight,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(14),
    //     side: BorderSide(
    //       color: borderLight,
    //       width: 1,
    //     ),
    //   ),
    // ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primaryLight, width: 2),
      ),
      hintStyle: AppStyles.custom(
        color: textHintLight,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryLight,
        foregroundColor: onPrimaryLight,
        elevation: 2,
        shadowColor: shadowLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryLight,
      foregroundColor: onPrimaryLight,
      elevation: 4,
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backgroundLight,
      selectedItemColor: primaryLight,
      unselectedItemColor: textSecondaryLight,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: AppStyles.custom(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      unselectedLabelStyle: AppStyles.custom(fontSize: 11),
    ),

    // Text Theme
    textTheme: TextTheme(
      displayLarge: AppStyles.custom(
        color: textPrimaryLight,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: AppStyles.custom(
        color: textPrimaryLight,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: AppStyles.custom(
        color: textPrimaryLight,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: AppStyles.custom(
        color: textPrimaryLight,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: AppStyles.custom(
        color: textPrimaryLight,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: AppStyles.custom(
        color: textPrimaryLight,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: AppStyles.custom(
        color: textPrimaryLight,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: AppStyles.custom(
        color: textPrimaryLight,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: AppStyles.custom(
        color: textPrimaryLight,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: AppStyles.custom(
        color: textPrimaryLight,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: AppStyles.custom(
        color: textPrimaryLight,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: AppStyles.custom(
        color: textSecondaryLight,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: AppStyles.custom(
        color: textPrimaryLight,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: AppStyles.custom(
        color: textSecondaryLight,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: AppStyles.custom(
        color: textHintLight,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    ),

    // Icon Theme
    iconTheme: IconThemeData(color: textPrimaryLight, size: 24),

    // Divider Theme
    dividerTheme: DividerThemeData(color: borderLight, thickness: 1, space: 1),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryDark,
    scaffoldBackgroundColor: backgroundDark,

    colorScheme: const ColorScheme.dark(
      primary: primaryDark,
      secondary: secondaryDark,
      surface: surfaceDark,
      background: backgroundDark,
      error: errorDark,
      onPrimary: onPrimaryDark,
      onSecondary: onSecondaryDark,
      onSurface: onSurfaceDark,
      onBackground: onBackgroundDark,
      onError: AppTheme.backgroundLight,
    ),

    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceDark,
      foregroundColor: onSurfaceDark,
      elevation: 0,
      shadowColor: shadowDark,
      titleTextStyle: AppStyles.custom(
        color: textPrimaryDark,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: textPrimaryDark),
    ),

    // Card Theme
    // cardTheme: CardTheme(
    //   color: cardDark,
    //   elevation: 4,
    //   shadowColor: shadowDark,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(14),
    //     side: BorderSide(
    //       color: borderDark,
    //       width: 1,
    //     ),
    //   ),
    // ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primaryDark, width: 2),
      ),
      hintStyle: AppStyles.custom(
        color: textHintDark,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        foregroundColor: onPrimaryDark,
        elevation: 4,
        shadowColor: shadowDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryDark,
      foregroundColor: onPrimaryDark,
      elevation: 6,
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: primaryDark,
      unselectedItemColor: textSecondaryDark,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: AppStyles.custom(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      unselectedLabelStyle: AppStyles.custom(fontSize: 11),
    ),

    // Text Theme
    textTheme: TextTheme(
      displayLarge: AppStyles.custom(
        color: textPrimaryDark,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: AppStyles.custom(
        color: textPrimaryDark,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: AppStyles.custom(
        color: textPrimaryDark,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: AppStyles.custom(
        color: textPrimaryDark,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: AppStyles.custom(
        color: textPrimaryDark,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: AppStyles.custom(
        color: textPrimaryDark,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: AppStyles.custom(
        color: textPrimaryDark,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: AppStyles.custom(
        color: textPrimaryDark,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: AppStyles.custom(
        color: textPrimaryDark,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: AppStyles.custom(
        color: textPrimaryDark,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: AppStyles.custom(
        color: textPrimaryDark,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: AppStyles.custom(
        color: textSecondaryDark,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      labelLarge: AppStyles.custom(
        color: textPrimaryDark,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: AppStyles.custom(
        color: textSecondaryDark,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: AppStyles.custom(
        color: textHintDark,
        fontSize: 10,
        fontWeight: FontWeight.w500,
      ),
    ),

    // Icon Theme
    iconTheme: IconThemeData(color: textPrimaryDark, size: 24),

    // Divider Theme
    dividerTheme: DividerThemeData(color: borderDark, thickness: 1, space: 1),
  );

  // Utility methods for gradients
  static LinearGradient getPrimaryGradient(bool isDark) {
    return LinearGradient(
      colors: isDark ? primaryGradientDark : primaryGradientLight,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient getSecondaryGradient(bool isDark) {
    return LinearGradient(
      colors: isDark ? secondaryGradientDark : secondaryGradientLight,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient getErrorGradient(bool isDark) {
    return LinearGradient(
      colors: isDark ? errorGradientDark : errorGradientLight,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient getSuccessGradient(bool isDark) {
    return LinearGradient(
      colors: isDark ? successGradientDark : successGradientLight,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient getInfoGradient(bool isDark) {
    return LinearGradient(
      colors: isDark ? infoGradientDark : infoGradientLight,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // Custom BoxShadow
  static List<BoxShadow> getCardShadow(bool isDark) {
    return [
      BoxShadow(
        color: isDark ? shadowDark : shadowLight,
        spreadRadius: 0,
        blurRadius: isDark ? 8 : 10,
        offset: Offset(0, isDark ? 4 : 2),
      ),
    ];
  }

  static List<BoxShadow> getElevatedShadow(bool isDark) {
    return [
      BoxShadow(
        color: isDark ? shadowDark : shadowLight,
        spreadRadius: 0,
        blurRadius: isDark ? 12 : 15,
        offset: Offset(0, isDark ? 6 : 4),
      ),
    ];
  }

  // Helper method to get current theme colors
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color getTextPrimary(BuildContext context) {
    return isDarkMode(context) ? textPrimaryDark : textPrimaryLight;
  }

  static Color getTextSecondary(BuildContext context) {
    return isDarkMode(context) ? textSecondaryDark : textSecondaryLight;
  }

  static Color getTextHint(BuildContext context) {
    return isDarkMode(context) ? textHintDark : textHintLight;
  }

  static Color getBorderColor(BuildContext context) {
    return isDarkMode(context) ? borderDark : borderLight;
  }

  static Color getShadowColor(BuildContext context) {
    return isDarkMode(context) ? shadowDark : shadowLight;
  }

  static Color backgroundColor(BuildContext context) =>
      ThemeController().isDarkMode
          ? AppTheme.grey900
          : AppTheme.backgroundLight;

  static Color cardBackground(BuildContext context) =>
      ThemeController().isDarkMode ? Colors.grey[850]! : Colors.grey[50]!;

  static Color textPrimary(BuildContext context) =>
      ThemeController().isDarkMode
          ? AppTheme.backgroundLight
          : AppTheme.black87;

  static Color textSecondary(BuildContext context) =>
      ThemeController().isDarkMode ? AppTheme.grey400 : AppTheme.grey600;

  static Color borderColor(BuildContext context) =>
      ThemeController().isDarkMode ? AppTheme.grey700 : AppTheme.grey300;

  static Color shadowColor(BuildContext context) =>
      ThemeController().isDarkMode
          ? AppTheme.backgroundDark.withOpacity(0.3)
          : AppTheme.backgroundDark.withOpacity(0.05);

  static Color accentColor(BuildContext context) =>
      ThemeController().isDarkMode ? Color(0xFFA29BFE) : Color(0xFF6C5CE7);

  // Gradient colors for cards and buttons
  static List<Color> statCardGradient(
    BuildContext context,
    List<Color> lightColors,
  ) {
    if (ThemeController().isDarkMode) {
      return lightColors
          .map((color) => Color.lerp(color, AppTheme.backgroundDark, 0.3)!)
          .toList();
    }
    return lightColors;
  }

  static List<Color> actionButtonGradient(
    BuildContext context,
    List<Color> lightColors,
  ) {
    if (ThemeController().isDarkMode) {
      return lightColors
          .map((color) => Color.lerp(color, AppTheme.backgroundDark, 0.2)!)
          .toList();
    }
    return lightColors;
  }
}
