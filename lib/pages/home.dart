import 'package:efishxs/components/homenavbar.dart';
import 'package:efishxs/pages/dashboard.dart';
import 'package:efishxs/pages/devices.dart';
import 'package:efishxs/pages/newrecord.dart';
import 'package:efishxs/pages/serialmonitor.dart';
import 'package:efishxs/pages/settings.dart';
import 'package:flutter/material.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {

  int _selectedtabindex = 0;

  void navigatebottombar (int index) {
    setState(() {
      _selectedtabindex = index;
    });
  }

  final List<Widget> _pages = [const DashboardWidget(), SerialMonitorPage(), const SettingsPage(), const NewRecordPage()];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        onTabChange: (index) {
          navigatebottombar(index);
        },
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leadingWidth: MediaQuery.of(context).size.width, // Set leadingWidth to full width
        leading: Center(
          child: Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/a/ab/Apple-logo.png', // Replace with your image URL
            width: 40, // Adjust the width as needed
            height: 40, // Adjust the height as needed
            fit: BoxFit.cover, // Adjust the fit as needed
          ),
        ),
      ),
      body: _pages[_selectedtabindex],
    );
  }
}
