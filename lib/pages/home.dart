import 'dart:async';

import 'package:efishxs/components/ui/homenavbar.dart';
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
  bool _bl_connection_status = true;

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
  void dispose() {
    super.dispose();
  }
  

  // Timer.periodic(const Duration(seconds:  2), (Timer t) {
  //   setState(() {
  //     _bl_connection_status = controller.isconnected();
  //   });
  //   print("LOG: Checking connection status: " + _bl_connection_status.toString());
  // });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BLEController(
      onDisconnect: () {},
    ));

    return Scaffold(

      // Bottom navigation bar
      bottomNavigationBar: IgnorePointer(
        ignoring: !controller.connected.value,
        child: Obx(() => Opacity(
            opacity: controller.connected.value ? 1 : 0.2,
            child: BottomNavBar(
              onTabChange: (index) {
                navigatebottombar(index);
              }
            ),
          ),
        ),
      ),

      backgroundColor: Theme.of(context).colorScheme.background,
      
      // Appbar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leadingWidth:
            MediaQuery.of(context).size.width, // Set leadingWidth to full width
        leading: Center(
          child: Image.asset("assets/images/cereal.png", height: 40),
        ),
        actions: [
          Obx(() => Padding(
                padding: const EdgeInsets.fromLTRB(2, 0, 8, 0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 6,
                      backgroundColor: controller.connected.value
                          ? const Color.fromARGB(255, 40, 119, 255)
                          : Colors.amber,
                    ),
                    IconButton(
                      icon: controller.connected.value
                          ? const Icon(Icons.bluetooth_disabled)
                          : const Icon(Icons.bluetooth),
                      onPressed: () {
                        if (controller.connected.value) {
                          print("LOG: Request to disconnect device");
                          controller.disconnectdevice();
                        } else {
                          print("LOG: Request to connect device");
                          controller.connectdevice(
                              context, controller.connecteddevice);
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.devices_rounded),
                      onPressed: () {
                        controller.disconnectdevice();
                        Get.off(() => DevicesPage());
                      },
                    ),
                  ],
                ),
              )),
        ],
      ),

      
      // Body
      body: Obx(() => IgnorePointer(
        ignoring: !controller.connected.value,
          child: Opacity(
            opacity: controller.connected.value ? 1 : 0.2,
            child: _pages[_selectedtabindex],
          ),
        ),
      ),
    );
  }
}
