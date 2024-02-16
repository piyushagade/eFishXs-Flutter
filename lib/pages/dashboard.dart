import 'package:efishxs/components/buttons/bigbuttonitem.dart';
import 'package:efishxs/components/ui/heading.dart';
import 'package:efishxs/controllers/ble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_responsive_flex_grid/flutter_responsive_flex_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  SharedPreferences? _prefs;
  late Future<void> _prefsFuture;

  @override
  void initState() {
    super.initState();
    _prefsFuture = SharedPreferences.getInstance().then((value) {
      setState(() {
        _prefs = value; 
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Showing dashboard");
    // final controller = Get.put(BLEController(
    //   onDisconnect: () {},
    // ));

    final controller = Get.find<BLEController>();

    Widget body = Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Visibility(
              visible: _prefs?.getBool("settings/general/showheading") ?? true,
              child: HeadingWidget(
                heading: "Dashboard",
                subheading: "Read your device's sensors and add new data record.",
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(2),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Update available.",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 48, 48, 48),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: const ResponsiveGrid(
                children: [
                  
                  ResponsiveGridItem(
                    xs: 32,
                    sm: 60,
                    md: 70,
                    child: SizedBox(
                      height: 110,
                      width: 30,
                      child: BigButtonItem(
                        label: "Add record",
                        icon: Icons.add,
                      ),
                    ),
                  ),
                  
                  ResponsiveGridItem(
                    xs: 32,
                    sm: 60,
                    md: 70,
                    child: SizedBox(
                      height: 110,
                      width: 30,
                      child: BigButtonItem(
                        label: "Sensors",
                        icon: Icons.device_thermostat_sharp,
                      ),
                    ),
                  ),
                  
                  ResponsiveGridItem(
                    xs: 32,
                    sm: 60,
                    md: 70,
                    child: SizedBox(
                      height: 110,
                      width: 30,
                      child: BigButtonItem(
                        label: "Data",
                        icon: Icons.bar_chart,
                      ),
                    ),
                  ),
                  
                  ResponsiveGridItem(
                    xs: 32,
                    sm: 60,
                    md: 70,
                    child: SizedBox(
                      height: 110,
                      width: 30,
                      child: BigButtonItem(
                        label: "Diagnose",
                        icon: Icons.troubleshoot,
                      ),
                    ),
                  ),
                  
                  ResponsiveGridItem(
                    xs: 32,
                    sm: 60,
                    md: 70,
                    child: SizedBox(
                      height: 110,
                      width: 30,
                      child: BigButtonItem(
                        label: "Calibrate",
                        icon: Icons.local_convenience_store_outlined,
                      ),
                    ),
                  ),
                  
                  
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
    

    return FutureBuilder<void>(
      future: _prefsFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading indicator while waiting for _prefs to be initialized
        } else if (snapshot.hasError) {
          return const Text('Error initializing preferences'); // Show error message if initialization fails
        } else {
          // Once _prefs is initialized, build the actual UI
          return body;
        }
      }
    );    
  }
}
