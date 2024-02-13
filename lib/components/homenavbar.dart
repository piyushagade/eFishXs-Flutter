import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  BottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: GNav(
        gap: 8,
        iconSize: 24,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        
        color: Theme.of(context).colorScheme.surface,
        activeColor: Theme.of(context).colorScheme.inversePrimary,
        tabBorder: Border.all(color: Colors.transparent),
        tabActiveBorder: Border.all(color: Colors.transparent),
        tabBackgroundColor: Theme.of(context).colorScheme.surface,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        tabBorderRadius: 2,
        tabs: const [
          GButton(icon: Icons.area_chart, text: "Dashboard",),
          GButton(icon: Icons.code, text: "Monitor",),
          GButton(icon: Icons.settings, text: "Settings",),
          GButton(icon: Icons.add_circle_sharp, text: "Record",),
        ],
        onTabChange: (value) => onTabChange!(value),
      ),
    );
  }
}