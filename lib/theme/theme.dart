import 'package:flutter/material.dart';

// Light mode
ThemeData lightmode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.grey.shade300,
    primary: Colors.grey.shade200,
    secondary: Colors.grey.shade400,
    inversePrimary: Colors.grey.shade800,
    surface: Colors.grey.shade200,
    inverseSurface: Colors.grey.shade100,
  ),
);

// Dark mode
ThemeData darkgreymode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade900,
    primary: Colors.grey.shade800,
    secondary: Colors.grey.shade700,
    inversePrimary: Colors.grey.shade300,
    surface: Colors.grey.shade800,
    inverseSurface: Colors.black,
  ),
);

// Black mode
ThemeData darkmode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    primary: Colors.grey.shade800,
    secondary: Colors.grey.shade700,
    inversePrimary: Colors.grey.shade300,
    surface: Colors.grey.shade800,
    inverseSurface: const Color.fromARGB(255, 18, 18, 18),
  ),
);


// Light grey mode
ThemeData lightgreymode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Color.fromARGB(255, 68, 68, 68),
    primary: Color.fromARGB(255, 218, 218, 218),
    secondary: const Color.fromARGB(255, 194, 194, 194),
    inversePrimary: Colors.grey.shade300,
    surface: const Color.fromARGB(255, 85, 85, 85),
    inverseSurface: Color.fromARGB(255, 50, 50, 50),
  ),
);