import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade200,
    tertiary: Colors.grey.shade100,
    inversePrimary: Colors.grey.shade900,
  ),
  scaffoldBackgroundColor: Colors.grey.shade300,
  // scaffoldBackgroundColor: Colors.red,
);
/*

 final tertiary = Theme.of(context).colorScheme.tertiary;
 final surface = Theme.of(context).colorScheme.surface;
 final primary = Theme.of(context).colorScheme.primary;
 final secondary = Theme.of(context).colorScheme.secondary;

 */
