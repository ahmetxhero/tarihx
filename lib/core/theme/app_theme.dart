import 'package:flutter/material.dart';

class AppTheme {
  static const fontFamily = 'Inter';

  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF0F172A), // Jet Slate Black
    onPrimary: Colors.white,
    secondary: Color(0xFF475569), // Slate Gray
    onSecondary: Colors.white,
    error: Color(0xFFDC2626),
    onError: Colors.white,
    surface: Color(0xFFFFFFFF), // Crisp White Surface
    onSurface: Color(0xFF0F172A),
    onSurfaceVariant: Color(0xFF64748B),
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFF8FAFC), // Pure Bright White
    onPrimary: Color(0xFF090A0E), // OLED Black
    secondary: Color(0xFF94A3B8), // Steel Gray
    onSecondary: Color(0xFF090A0E),
    error: Color(0xFFF87171),
    onError: Color(0xFF450A0A),
    surface: Color(0xFF14161F), // Dark Charcoal Card
    onSurface: Color(0xFFF8FAFC),
    onSurfaceVariant: Color(0xFF94A3B8),
  );

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: lightColorScheme,
      scaffoldBackgroundColor: const Color(0xFFF1F5F9),
      useMaterial3: true,
      fontFamily: fontFamily,
      textTheme: ThemeData.light().textTheme.apply(
            fontFamily: fontFamily,
            bodyColor: const Color(0xFF0F172A),
            displayColor: const Color(0xFF0F172A),
          ),
      cardTheme: CardThemeData(
        color: lightColorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFFFFF),
        foregroundColor: Color(0xFF0F172A),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFFFFFFFF),
        indicatorColor: const Color(0xFF0F172A).withValues(alpha: 0.1),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Color(0xFF0F172A));
          }
          return const IconThemeData(color: Color(0xFF64748B));
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w700, fontSize: 13);
          }
          return const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500, fontSize: 13);
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return const Color(0xFF64748B);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF0F172A);
          }
          return const Color(0xFFE2E8F0);
        }),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xFF0F172A);
            }
            return const Color(0xFFF1F5F9);
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white;
            }
            return const Color(0xFF475569);
          }),
          side: WidgetStateProperty.all(const BorderSide(color: Color(0xFFE2E8F0))),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: darkColorScheme,
      scaffoldBackgroundColor: const Color(0xFF090A0E),
      useMaterial3: true,
      fontFamily: fontFamily,
      textTheme: ThemeData.dark().textTheme.apply(
            fontFamily: fontFamily,
            bodyColor: const Color(0xFFF8FAFC),
            displayColor: const Color(0xFFF8FAFC),
          ),
      cardTheme: CardThemeData(
        color: darkColorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF222533), width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF090A0E),
        foregroundColor: Color(0xFFF8FAFC),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFFF8FAFC),
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF0F1118),
        indicatorColor: const Color(0xFFF8FAFC).withValues(alpha: 0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Color(0xFFF8FAFC));
          }
          return const IconThemeData(color: Color(0xFF94A3B8));
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: Color(0xFFF8FAFC), fontWeight: FontWeight.w700, fontSize: 13);
          }
          return const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w500, fontSize: 13);
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF090A0E);
          }
          return const Color(0xFF94A3B8);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFFF8FAFC);
          }
          return const Color(0xFF222533);
        }),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xFFF8FAFC);
            }
            return const Color(0xFF14161F);
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xFF090A0E);
            }
            return const Color(0xFF94A3B8);
          }),
          side: WidgetStateProperty.all(const BorderSide(color: Color(0xFF222533))),
        ),
      ),
    );
  }
}
