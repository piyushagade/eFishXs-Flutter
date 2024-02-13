import 'package:efishxs/components/homenavbar.dart';
import 'package:efishxs/controllers/ble.dart';
import 'package:efishxs/pages/dashboard.dart';
import 'package:efishxs/pages/devices.dart';
import 'package:efishxs/pages/newrecord.dart';
import 'package:efishxs/pages/serialmonitor.dart';
import 'package:efishxs/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BLEController(
      onDisconnect: () {},
    ));

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
          child: Image.asset("assets/images/cereal.png", height: 40),
        ),
        actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 8, 0),
              child: IconButton(
                icon: const Icon(Icons.bluetooth_disabled),
                onPressed: () {
                  controller.disconnectdevice();
                },
              ),
            ),
          ],
      ),
      body: _pages[_selectedtabindex],
    );
  }
}
