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
    );
  }

  TextTheme get _textTheme {
    return GoogleFonts.manropeTextTheme(
      ThemeData(brightness: Brightness.light).textTheme,
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
      ),
    );
  }

  BottomSheetThemeData get _bottomSheetTheme {
    return BottomSheetThemeData(surfaceTintColor: lightColorScheme.surface);
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
      ThemeData(brightness: Brightness.dark).textTheme,
    );
  }

  @override
  BottomSheetThemeData get _bottomSheetTheme {
    return BottomSheetThemeData(surfaceTintColor: darkColorScheme.surface);
  }
}
