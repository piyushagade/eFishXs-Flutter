import 'package:efishxs/components/bigbuttonitem.dart';
import 'package:efishxs/components/heading.dart';
import 'package:efishxs/controllers/ble.dart';
import 'package:efishxs/pages/devices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Showing dashboard");
    // final controller = Get.put(BLEController(
    //   onDisconnect: () {},
    // ));

    final controller = Get.find<BLEController>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          HeadingWidget(
            heading: "Dashboard",
            subheading: "Read your device's sensors and add new data record.",
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
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              shrinkWrap: true, // Use shrinkWrap to adapt to the children size
              physics:
                  const NeverScrollableScrollPhysics(), // Disable scrolling of the grid
              children: const <Widget>[
                BigButtonItem(
                  label: "Add record",
                  icon: Icons.add,
                ),
                BigButtonItem(
                  label: "Read sensors",
                  icon: Icons.device_thermostat_sharp,
                ),
                BigButtonItem(
                  label: "Data",
                  icon: Icons.bar_chart,
                ),
                BigButtonItem(
                  label: "Diagnose",
                  icon: Icons.troubleshoot,
                ),
                BigButtonItem(
                  label: "Calibrate",
                  icon: Icons.local_convenience_store_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
