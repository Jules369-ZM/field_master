import 'package:field_master/app/theme/constants.dart';
import 'package:field_master/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

export 'package:flutter_bloc/flutter_bloc.dart';

export 'color_schemes.g.dart';
export 'theme_cubit.dart';

/// {@template app_theme}
/// The Default App [ThemeData].
/// {@endtemplate}
class AppTheme {
  /// {@macro app_theme}
  const AppTheme();

  /// Default `ThemeData` for App UI.
  ThemeData get themeData {
    return ThemeData(
      textTheme: _textTheme,
      colorScheme: _colorScheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      filledButtonTheme: _filledButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      bottomSheetTheme: _bottomSheetTheme,
      appBarTheme: _appBarTheme, // Add AppBar theme
      scaffoldBackgroundColor: _colorScheme.surface, // Set background color
      floatingActionButtonTheme: _floatingActionButtonTheme, // Custom FAB theme
    );
  }

  TextTheme get _textTheme {
    return GoogleFonts.manropeTextTheme(
      ThemeData(brightness: Brightness.light).textTheme.apply(
            bodyColor: _colorScheme.onSurface,
            displayColor: _colorScheme.onSurface,
          ),
    );
  }

  ColorScheme get _colorScheme => lightColorScheme;

  FilledButtonThemeData get _filledButtonTheme {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kAppCornerRadius),
        ),
        backgroundColor: _colorScheme.primary, // Set primary color
        foregroundColor: Colors.white, // Set text color for better contrast
        elevation: 2, // Add subtle elevation
      ),
    );
  }

  OutlinedButtonThemeData get _outlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kAppCornerRadius),
        ),
        side:
            BorderSide(color: _colorScheme.primary, width: 2), // Custom border
      ),
    );
  }

  ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kAppCornerRadius),
        ),
        backgroundColor: _colorScheme.secondary, // Set secondary color
        foregroundColor: Colors.white, // Set text color
        elevation: 4, // Increase elevation for depth
      ),
    );
  }

  BottomSheetThemeData get _bottomSheetTheme {
    return BottomSheetThemeData(
      surfaceTintColor: lightColorScheme.surface,
      modalBackgroundColor: _colorScheme.onSurface
          .withOpacity(0.8), // Semi-transparent background
    );
  }

  AppBarTheme get _appBarTheme {
    return AppBarTheme(
      backgroundColor: _colorScheme.primary, // AppBar background color
      foregroundColor: Colors.white, // AppBar icon and text color
      elevation: 2, // AppBar elevation
      titleTextStyle: GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  FloatingActionButtonThemeData get _floatingActionButtonTheme {
    return FloatingActionButtonThemeData(
      backgroundColor: _colorScheme.secondary, // Custom FAB color
      foregroundColor: Colors.white, // FAB icon color
      elevation: 6, // FAB elevation
    );
  }
}

/// {@template app_dark_theme}
/// Dark Mode App [ThemeData].
/// {@endtemplate}
class AppDarkTheme extends AppTheme {
  /// {@macro app_dark_theme}
  const AppDarkTheme();

  @override
  ColorScheme get _colorScheme => darkColorScheme;

  @override
  TextTheme get _textTheme {
    return GoogleFonts.manropeTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme.apply(
            bodyColor: _colorScheme.onSurface,
            displayColor: _colorScheme.onSurface,
          ),
    );
  }

  @override
  BottomSheetThemeData get _bottomSheetTheme {
    return BottomSheetThemeData(surfaceTintColor: darkColorScheme.surface);
  }

  @override
  AppBarTheme get _appBarTheme {
    return AppBarTheme(
      backgroundColor: _colorScheme.primary,
      foregroundColor: Colors.white,
      elevation: 2,
      titleTextStyle: GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  FloatingActionButtonThemeData get _floatingActionButtonTheme {
    return FloatingActionButtonThemeData(
      backgroundColor: _colorScheme.secondary,
      foregroundColor: Colors.white,
      elevation: 6,
    );
  }
}
