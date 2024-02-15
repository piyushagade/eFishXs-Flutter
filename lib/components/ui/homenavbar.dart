import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatefulWidget {
  void Function(int)? onTabChange;
  final int selectedIndex;

  BottomNavBar({super.key, required this.selectedIndex, required this.onTabChange});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final GlobalKey navKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: GNav(
        key: navKey,
        gap: 8,
        iconSize: 24,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        selectedIndex: widget.selectedIndex,
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
        ],
        onTabChange: (value) => widget.onTabChange!(value),
      ),
    );
  }
}