import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFaa0400), // Red (Primary)
  onPrimary: Color(0xFFFFFFFF), // White on red for good contrast
  primaryContainer:
      Color(0xFFFFDAD5), // Soft light red for container backgrounds
  onPrimaryContainer:
      Color(0xFF410000), // Dark red for text on container backgrounds
  secondary: Color(0xFF006874), // Teal for contrast with red
  onSecondary: Color(0xFFFFFFFF), // White on teal for clarity
  secondaryContainer: Color(0xFF97F0FF), // Light teal for containers
  onSecondaryContainer: Color(0xFF002022), // Dark teal for text on containers
  tertiary: Color(0xFF9C4145), // A muted red for subtle accents
  onTertiary: Color(0xFFFFFFFF), // White on muted red
  tertiaryContainer: Color(0xFFFFDAD9), // Soft muted red for containers
  onTertiaryContainer:
      Color(0xFF400009), // Dark muted red for text on containers
  error: Color(0xFFBA1A1A), // Standard red for errors
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  surface: Color(0xFFFAFDFC), // Light neutral background
  onSurface: Color(0xFF191C1C), // Dark text on light surface
  surfaceContainerHighest:
      Color(0xFFEDEEEF), // Soft neutral background for containers
  onSurfaceVariant:
      Color(0xFF3F4949), // Slightly muted gray for variant surface
  outline: Color(0xFF707F80), // Cool gray for outlines
  onInverseSurface: Color(0xFFEFF1F1),
  inverseSurface: Color(0xFF2D3131), // Inverse dark surface
  inversePrimary: Color(
    0xFFFFA726,
  ), // Warm orange as an inverse primary (complementary to red)
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFaa0400), // Red tint for surface elements
  outlineVariant: Color(0xFFBEC8C9),
  scrim: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFaa0400), // Red (Primary)
  onPrimary: Color(0xFFFFFFFF), // White text on red for contrast
  primaryContainer: Color(0xFF690001), // Darker red for containers
  onPrimaryContainer:
      Color(0xFFFFB4A5), // Lighter red for text on dark red containers
  secondary: Color(0xFF4FD8EB), // Teal accent to complement red
  onSecondary: Color(0xFF00363D), // Dark teal text on teal
  secondaryContainer: Color(0xFF004F58), // Dark teal for containers
  onSecondaryContainer:
      Color(0xFF97F0FF), // Lighter teal for text on containers
  tertiary: Color(0xFFEFB8BB), // Soft muted red for accents
  onTertiary: Color(0xFF5B1215), // Darker muted red text on lighter red
  tertiaryContainer: Color(0xFF772329), // Dark muted red container
  onTertiaryContainer:
      Color(0xFFFFDAD9), // Light muted red for text on container
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  surface: Color(0xFF191C1C), // Dark neutral background
  onSurface: Color(0xFFE0E3E3), // Light text on dark surface
  surfaceContainerHighest: Color(0xFF383E3E), // Darker surface container
  onSurfaceVariant: Color(0xFFBEC8C9),
  outline: Color(0xFF899393), // Muted gray for outlines
  onInverseSurface: Color(0xFF191C1C),
  inverseSurface: Color(0xFFE0E3E3), // Lighter inverse surface
  inversePrimary: Color(
    0xFFFFA726,
  ), // Warm orange as inverse primary (complementary to red)
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFaa0400), // Red tint for surface elements
  outlineVariant: Color(0xFF3F4949),
  scrim: Color(0xFF000000),
);

Color kPrimaryColor = const Color(0xFFaa0400);
Color kSecondaryColor = const Color(0xFF006874);
Color kWhiteOther = const Color(0xFFf5fafe);
