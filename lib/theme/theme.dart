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
    inverseSurface: const Color.fromARGB(255, 205, 205, 205),
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
    background: const Color.fromARGB(255, 147, 147, 147),
    primary: const Color.fromARGB(255, 80, 80, 80),
    secondary: const Color.fromARGB(255, 194, 194, 194),
    inversePrimary: Colors.grey.shade300,
    surface: const Color.fromARGB(255, 112, 112, 112),
    inverseSurface: Color.fromARGB(255, 121, 121, 121),
  ),
);