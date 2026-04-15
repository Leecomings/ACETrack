import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4A5FE8);
  static const Color primaryLight = Color(0xFF6B7BF0);
  static const Color primaryDark = Color(0xFF3A4BC8);
  static const Color primaryBg = Color(0x144A5FE8);

  static const Color accent = Color(0xFFE94B3C);
  static const Color accentLight = Color(0xFFF06B5E);

  static const Color success = Color(0xFF52C41A);
  static const Color warning = Color(0xFFFAAD14);
  static const Color error = Color(0xFFF5222D);
  static const Color info = Color(0xFF4A5FE8);

  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textPlaceholder = Color(0xFF999999);
  static const Color border = Color(0xFFE5E5E5);
  static const Color divider = Color(0xFFF0F0F0);
  static const Color bgPrimary = Colors.white;
  static const Color bgSecondary = Color(0xFFFAFAFA);
  static const Color bgGrey = Color(0xFFF5F5F5);

  // 球场颜色
  static const Color courtGreen = Color(0xFF1B5E20);
  static const Color courtLine = Colors.white;
  static const Color courtNet = Color(0xFFCCCCCC);

  // 击球类型颜色
  static const Color forehand = Color(0xFF4A5FE8);
  static const Color backhand = Color(0xFF60A5FA);
  static const Color serve = Color(0xFF52C41A);
  static const Color volley = Color(0xFFFAAD14);
  static const Color smash = Color(0xFFF5222D);
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppRadius {
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 16;
  static const double xl = 24;
}

class ShotTypeConfig {
  static const Map<String, Map<String, dynamic>> config = {
    'forehand': {'label': '正手', 'initial': '正', 'color': AppColors.forehand},
    'backhand': {'label': '反手', 'initial': '反', 'color': AppColors.backhand},
    'serve': {'label': '发球', 'initial': '发', 'color': AppColors.serve},
    'volley': {'label': '截击', 'initial': '截', 'color': AppColors.volley},
    'smash': {'label': '高压', 'initial': '高', 'color': AppColors.smash},
  };
}
