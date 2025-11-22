import 'package:flutter/material.dart';

// Material 3 Expressive Color Scheme for Dark Theme
// Using a vibrant teal/cyan as primary with expressive accent colors
const Color _primarySeed = Color(0xFF00BFA5); // Teal accent
const Color _secondarySeed = Color(0xFF7C4DFF); // Deep purple accent
const Color _tertiarySeed = Color(0xFFFF6E40); // Deep orange accent

// Custom dark color scheme with M3 expressive design
final ColorScheme darkColorScheme = ColorScheme.fromSeed(
  seedColor: _primarySeed,
  brightness: Brightness.dark,
  primary: const Color(0xFF4FD8C4),
  onPrimary: const Color(0xFF003731),
  primaryContainer: const Color(0xFF005048),
  onPrimaryContainer: const Color(0xFF70F5DF),
  secondary: const Color(0xFFB3C5FF),
  onSecondary: const Color(0xFF1E2E60),
  secondaryContainer: const Color(0xFF354578),
  onSecondaryContainer: const Color(0xFFDAE2FF),
  tertiary: const Color(0xFFFFB599),
  onTertiary: const Color(0xFF5C1900),
  tertiaryContainer: const Color(0xFF7E2E0E),
  onTertiaryContainer: const Color(0xFFFFDBCE),
  error: const Color(0xFFFFB4AB),
  onError: const Color(0xFF690005),
  errorContainer: const Color(0xFF93000A),
  onErrorContainer: const Color(0xFFFFDAD6),
  surface: const Color(0xFF121212),
  onSurface: const Color(0xFFE6E1E5),
  surfaceContainerHighest: const Color(0xFF2D2D2D),
  onSurfaceVariant: const Color(0xFFCAC4D0),
  outline: const Color(0xFF938F99),
  outlineVariant: const Color(0xFF49454F),
  inverseSurface: const Color(0xFFE6E1E5),
  onInverseSurface: const Color(0xFF313033),
  inversePrimary: const Color(0xFF006B5F),
  shadow: const Color(0xFF000000),
  scrim: const Color(0xFF000000),
  surfaceTint: const Color(0xFF4FD8C4),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: darkColorScheme,

  // Surface and background colors
  scaffoldBackgroundColor: darkColorScheme.surface,
  canvasColor: darkColorScheme.surface,

  // AppBar Theme with M3 expressive styling
  appBarTheme: AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 3,
    backgroundColor: darkColorScheme.surface,
    foregroundColor: darkColorScheme.onSurface,
    surfaceTintColor: darkColorScheme.surfaceTint,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: darkColorScheme.onSurface,
      fontSize: 22,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
    ),
    iconTheme: IconThemeData(
      color: darkColorScheme.onSurface,
      size: 24,
    ),
  ),

  // Card Theme with M3 filled styling
  cardTheme: CardTheme(
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    color: darkColorScheme.surfaceContainerHighest,
    surfaceTintColor: darkColorScheme.surfaceTint,
    clipBehavior: Clip.antiAlias,
  ),

  // Elevated Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 1,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: darkColorScheme.primaryContainer,
      foregroundColor: darkColorScheme.onPrimaryContainer,
    ),
  ),

  // Filled Button Theme (M3 expressive)
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  ),

  // Outlined Button Theme
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      side: BorderSide(color: darkColorScheme.outline),
    ),
  ),

  // Text Button Theme
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  ),

  // Floating Action Button Theme
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    elevation: 3,
    highlightElevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    backgroundColor: darkColorScheme.primaryContainer,
    foregroundColor: darkColorScheme.onPrimaryContainer,
  ),

  // Navigation Bar Theme (M3 expressive)
  navigationBarTheme: NavigationBarThemeData(
    elevation: 3,
    backgroundColor: darkColorScheme.surface,
    surfaceTintColor: darkColorScheme.surfaceTint,
    indicatorColor: darkColorScheme.primaryContainer,
    iconTheme: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return IconThemeData(
          color: darkColorScheme.onPrimaryContainer,
          size: 24,
        );
      }
      return IconThemeData(
        color: darkColorScheme.onSurfaceVariant,
        size: 24,
      );
    }),
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return TextStyle(
          color: darkColorScheme.onSurface,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        );
      }
      return TextStyle(
        color: darkColorScheme.onSurfaceVariant,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );
    }),
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    height: 80,
  ),

  // Input Decoration Theme with M3 styling
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: darkColorScheme.surfaceContainerHighest,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: BorderSide(color: darkColorScheme.outline.withOpacity(0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: BorderSide(color: darkColorScheme.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: BorderSide(color: darkColorScheme.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: BorderSide(color: darkColorScheme.error, width: 2),
    ),
    hintStyle: TextStyle(color: darkColorScheme.onSurfaceVariant),
    prefixIconColor: darkColorScheme.onSurfaceVariant,
    suffixIconColor: darkColorScheme.onSurfaceVariant,
  ),

  // Chip Theme
  chipTheme: ChipThemeData(
    backgroundColor: darkColorScheme.surfaceContainerHighest,
    selectedColor: darkColorScheme.primaryContainer,
    secondarySelectedColor: darkColorScheme.secondaryContainer,
    labelStyle: TextStyle(color: darkColorScheme.onSurface),
    secondaryLabelStyle: TextStyle(color: darkColorScheme.onSecondaryContainer),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    side: BorderSide(color: darkColorScheme.outline),
  ),

  // Dialog Theme
  dialogTheme: DialogTheme(
    backgroundColor: darkColorScheme.surface,
    surfaceTintColor: darkColorScheme.surfaceTint,
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28),
    ),
    titleTextStyle: TextStyle(
      color: darkColorScheme.onSurface,
      fontSize: 24,
      fontWeight: FontWeight.w500,
    ),
    contentTextStyle: TextStyle(
      color: darkColorScheme.onSurfaceVariant,
      fontSize: 14,
    ),
  ),

  // Snackbar Theme
  snackBarTheme: SnackBarThemeData(
    backgroundColor: darkColorScheme.inverseSurface,
    contentTextStyle: TextStyle(color: darkColorScheme.onInverseSurface),
    actionTextColor: darkColorScheme.inversePrimary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    behavior: SnackBarBehavior.floating,
    elevation: 6,
  ),

  // Bottom Sheet Theme
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: darkColorScheme.surface,
    surfaceTintColor: darkColorScheme.surfaceTint,
    elevation: 1,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    dragHandleColor: darkColorScheme.onSurfaceVariant.withOpacity(0.4),
    dragHandleSize: const Size(32, 4),
  ),

  // List Tile Theme
  listTileTheme: ListTileThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    iconColor: darkColorScheme.onSurfaceVariant,
    textColor: darkColorScheme.onSurface,
  ),

  // Icon Theme
  iconTheme: IconThemeData(
    color: darkColorScheme.onSurface,
    size: 24,
  ),

  // Primary Icon Theme
  primaryIconTheme: IconThemeData(
    color: darkColorScheme.onPrimary,
    size: 24,
  ),

  // Divider Theme
  dividerTheme: DividerThemeData(
    color: darkColorScheme.outlineVariant,
    thickness: 1,
    space: 1,
  ),

  // Text Theme with M3 typography
  textTheme: TextTheme(
    displayLarge: TextStyle(
      color: darkColorScheme.onSurface,
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
    ),
    displayMedium: TextStyle(
      color: darkColorScheme.onSurface,
      fontSize: 45,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: TextStyle(
      color: darkColorScheme.onSurface,
      fontSize: 36,
      fontWeight: FontWeight.w400,
    ),
    headlineLarge: TextStyle(
      color: darkColorScheme.onSurface,
      fontSize: 32,
      fontWeight: FontWeight.w500,
    ),
    headlineMedium: TextStyle(
      color: darkColorScheme.onSurface,
      fontSize: 28,
      fontWeight: FontWeight.w500,
    ),
    headlineSmall: TextStyle(
      color: darkColorScheme.onSurface,
      fontSize: 24,
      fontWeight: FontWeight.w500,
    ),
    titleLarge: TextStyle(
      color: darkColorScheme.onSurface,
      fontSize: 22,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: TextStyle(
      color: darkColorScheme.onSurface,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    titleSmall: TextStyle(
      color: darkColorScheme.onSurface,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      color: darkColorScheme.onSurface,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    ),
    bodyMedium: TextStyle(
      color: darkColorScheme.onSurface,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      color: darkColorScheme.onSurfaceVariant,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),
    labelLarge: TextStyle(
      color: darkColorScheme.onSurface,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    labelMedium: TextStyle(
      color: darkColorScheme.onSurface,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      color: darkColorScheme.onSurfaceVariant,
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
  ),

  // Progress Indicator Theme
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: darkColorScheme.primary,
    circularTrackColor: darkColorScheme.surfaceContainerHighest,
    linearTrackColor: darkColorScheme.surfaceContainerHighest,
  ),

  // Slider Theme
  sliderTheme: SliderThemeData(
    activeTrackColor: darkColorScheme.primary,
    inactiveTrackColor: darkColorScheme.surfaceContainerHighest,
    thumbColor: darkColorScheme.primary,
    overlayColor: darkColorScheme.primary.withOpacity(0.12),
  ),

  // Switch Theme
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return darkColorScheme.onPrimaryContainer;
      }
      return darkColorScheme.outline;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return darkColorScheme.primaryContainer;
      }
      return darkColorScheme.surfaceContainerHighest;
    }),
  ),

  // Checkbox Theme
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return darkColorScheme.primary;
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(darkColorScheme.onPrimary),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4),
    ),
    side: BorderSide(color: darkColorScheme.outline, width: 2),
  ),

  // Radio Theme
  radioTheme: RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return darkColorScheme.primary;
      }
      return darkColorScheme.outline;
    }),
  ),

  // Tab Bar Theme
  tabBarTheme: TabBarTheme(
    labelColor: darkColorScheme.primary,
    unselectedLabelColor: darkColorScheme.onSurfaceVariant,
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: darkColorScheme.primary, width: 3),
    ),
    indicatorSize: TabBarIndicatorSize.label,
  ),

  // Tooltip Theme
  tooltipTheme: TooltipThemeData(
    decoration: BoxDecoration(
      color: darkColorScheme.inverseSurface,
      borderRadius: BorderRadius.circular(4),
    ),
    textStyle: TextStyle(
      color: darkColorScheme.onInverseSurface,
      fontSize: 12,
    ),
  ),
);
