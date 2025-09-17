import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors for Medical App
  static const Color primaryColor = Color(0xFF1E2432);
  static const Color primaryLight = Color(0xFF3A4A5C);
  static const Color primaryDark = Color(0xFF0F1419);
  
  // Accent Colors
  static const Color accentBlue = Color(0xFF4A90E2);
  static const Color accentGreen = Color(0xFF51CF66);
  static const Color accentRed = Color(0xFFFF6B6B);
  static const Color accentOrange = Color(0xFFFF9F43);
  static const Color accentPurple = Color(0xFF7B68EE);
  
  // Background Colors
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1E2432);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textLight = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Colors.white;
  
  // Status Colors
  static const Color successColor = Color(0xFF51CF66);
  static const Color warningColor = Color(0xFFFF9F43);
  static const Color errorColor = Color(0xFFFF6B6B);
  static const Color infoColor = Color(0xFF4A90E2);
  
  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentBlue, accentPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  
  // Elevation
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
  
  // Typography
  static const TextStyle headingLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );
  
  static const TextStyle headingMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.3,
  );
  
  static const TextStyle headingSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.4,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.4,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: textLight,
    height: 1.3,
  );
  
  // Button Styles
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: textOnPrimary,
    padding: const EdgeInsets.symmetric(horizontal: spacingL, vertical: spacingM),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusM),
    ),
    elevation: elevationS,
  );
  
  static ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: surfaceColor,
    foregroundColor: primaryColor,
    padding: const EdgeInsets.symmetric(horizontal: spacingL, vertical: spacingM),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusM),
      side: const BorderSide(color: primaryColor),
    ),
    elevation: 0,
  );
  
  static ButtonStyle accentButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: accentBlue,
    foregroundColor: textOnPrimary,
    padding: const EdgeInsets.symmetric(horizontal: spacingL, vertical: spacingM),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusM),
    ),
    elevation: elevationS,
  );
  
  // Card Styles
  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(radiusM),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
  
  static BoxDecoration elevatedCardDecoration = BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(radiusL),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
  );
  
  // Input Decoration
  static InputDecoration inputDecoration({
    String? hintText,
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: backgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: const BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: spacingM,
        vertical: spacingM,
      ),
    );
  }
  
  // Cursor Color Constant
  static const Color cursorColor = Colors.black;
  
  // App Bar Theme
  static AppBarTheme appBarTheme = const AppBarTheme(
    backgroundColor: primaryColor,
    foregroundColor: textOnPrimary,
    elevation: elevationS,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: textOnPrimary,
    ),
  );
  
  // Bottom Navigation Bar Theme
  static BottomNavigationBarThemeData bottomNavTheme = const BottomNavigationBarThemeData(
    backgroundColor: surfaceColor,
    selectedItemColor: primaryColor,
    unselectedItemColor: textLight,
    type: BottomNavigationBarType.fixed,
    elevation: elevationM,
  );
  
  // Chip Theme
  static ChipThemeData chipTheme = ChipThemeData(
    backgroundColor: backgroundColor,
    selectedColor: primaryColor,
    labelStyle: bodyMedium,
    secondaryLabelStyle: bodyMedium.copyWith(color: textOnPrimary),
    padding: const EdgeInsets.symmetric(horizontal: spacingM, vertical: spacingS),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusL),
    ),
  );
  
  // Severity Colors for Medical Context
  static Color getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'mild':
      case 'low':
        return successColor;
      case 'moderate':
      case 'medium':
        return warningColor;
      case 'severe':
      case 'high':
        return errorColor;
      default:
        return textSecondary;
    }
  }
  
  // Priority Colors
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return successColor;
      case 'medium':
        return warningColor;
      case 'high':
        return errorColor;
      case 'urgent':
        return const Color(0xFFDC2626);
      default:
        return textSecondary;
    }
  }
  
  // Category Colors for Medical Documents
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'prescription':
        return accentBlue;
      case 'lab_report':
        return accentGreen;
      case 'imaging':
        return accentPurple;
      case 'consultation':
        return accentOrange;
      case 'insurance':
        return const Color(0xFF8B5CF6);
      case 'vaccination':
        return const Color(0xFF10B981);
      default:
        return textSecondary;
    }
  }
  
  // Status Colors
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'completed':
      case 'success':
        return successColor;
      case 'pending':
      case 'in_progress':
        return warningColor;
      case 'cancelled':
      case 'failed':
      case 'error':
        return errorColor;
      case 'scheduled':
        return infoColor;
      default:
        return textSecondary;
    }
  }
  
  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: accentBlue,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
      ),
      appBarTheme: appBarTheme,
      bottomNavigationBarTheme: bottomNavTheme,
      chipTheme: chipTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButtonStyle),
      textTheme: const TextTheme(
        headlineLarge: headingLarge,
        headlineMedium: headingMedium,
        headlineSmall: headingSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelSmall: caption,
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: elevationS,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusM),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusM),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
      // Set cursor color to black throughout the app
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.black,
        selectionColor: Colors.black26,
        selectionHandleColor: Colors.black,
      ),
    );
  }
}
