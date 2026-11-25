import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFF2563EB);
  static const ink = Color(0xFF101A30);
  static const muted = Color(0xFF687D9C);
  static const canvas = Color(0xFFF7F9FC);
}

abstract final class AppSpacing {
  static const page = 20.0;
  static const gap = 14.0;
  static const radius = 16.0;
}

abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);
  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: brightness,
        ).copyWith(
          primary: AppColors.primary,
          surface: dark ? const Color(0xFF192336) : Colors.white,
          onSurface: dark ? const Color(0xFFF4F7FF) : AppColors.ink,
        );
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      colorScheme: scheme,
      scaffoldBackgroundColor: dark
          ? const Color(0xFF101827)
          : AppColors.canvas,
      textTheme: ThemeData(brightness: brightness, fontFamily: 'Roboto')
          .textTheme
          .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }
}
