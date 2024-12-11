import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.teal,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.teal,
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.teal,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white),
    ),
  );
}

class AnimatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const AnimatedButton({required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(label),
          ),
        );
      },
    );
  }
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;

  ResponsiveLayout({required this.mobile, required this.tablet});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return mobile;
        } else {
          return tablet;
        }
      },
    );
  }
}

class LayoutConfig {
  static late double scaleFactor;
  static late double padding;
  static late double spacing;
  static late double smallSpacing;
  static late double fontSize;
  static late double greatSpacing;
  static late double greatPadding;

  static void init(BuildContext context, {double baseWidth = 375.0}) {
    final screenWidth = MediaQuery.of(context).size.width;
    scaleFactor = screenWidth / baseWidth;

    padding = 30.0 * scaleFactor;
    greatPadding = 60.0 * scaleFactor;
    spacing = 30.0 * scaleFactor;
    smallSpacing = 15.0 * scaleFactor;
    greatSpacing = 60.0 * scaleFactor;
    fontSize = 14.0 * scaleFactor;
  }
}
