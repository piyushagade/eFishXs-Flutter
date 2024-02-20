
import 'package:efishxs/components/ui/homenavbar.dart';
import 'package:efishxs/controllers/ble.dart';
import 'package:efishxs/pages/dashboard.dart';
import 'package:efishxs/pages/devices.dart';
import 'package:efishxs/pages/newrecord.dart';
import 'package:efishxs/pages/serialmonitor.dart';
import 'package:efishxs/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';


class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  SharedPreferences? _prefs;
  final GlobalKey bottomNavBarKey = GlobalKey();
  final controller = Get.find<BLEController>();

  int? _selectedtabindex = 0;

  void navigatebottombar (int index) {
    setState(() {
      _selectedtabindex = index;
    });
  }

  final List<Widget> _pages = [const DashboardWidget(), const SerialMonitorPage(), const SettingsPage(), const NewRecordPage()];

  @override
  void initState() {
    super.initState();
    print("LOG: Loading home page scaffold.");

    SharedPreferences.getInstance().then((value) {
      _prefs = value; 
      navigatebottombar(_prefs?.getInt("settings/general/openinpage") ?? 0);

      if (_prefs?.getBool("settings/general/stayawake") ?? true) {
        WidgetsFlutterBinding.ensureInitialized();
        Wakelock.enable();
      }
    });
  }  

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      // Bottom navigation bar
      bottomNavigationBar: IgnorePointer(
        ignoring: !controller.connected.value,
        child: Obx(() => Opacity(
            opacity: controller.connected.value ? 1 : 0.2,
            child: BottomNavBar(
              key: bottomNavBarKey,
              selectedIndex: _selectedtabindex ?? 0,
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
                        Get.off(() => const DevicesPage());
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
            child: _pages[_selectedtabindex ?? 0],
          ),
        ),
      ),
    );
  }
}
