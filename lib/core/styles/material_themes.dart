import 'package:flutter/material.dart';

import '../strings/app_constraints.dart';
import 'app_styles.dart';

class MaterialThemes {
  ThemeData get lightTheme => _buildTheme(Brightness.light);

  ThemeData get darkTheme => _buildTheme(Brightness.dark);

  ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      brightness: brightness,
      seedColor: Colors.indigo,
    );
    return ThemeData(
      fontFamily: AppConstraints.fontSFProRegular,
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(centerTitle: true),
      bottomSheetTheme: const BottomSheetThemeData(showDragHandle: true),
      cardTheme: const CardThemeData(margin: EdgeInsets.zero),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: AppStyles.mainBorderMini,
          border: Border.all(width: 1.0, color: colorScheme.primary),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}
