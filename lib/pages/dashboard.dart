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
  late BLEController controller;

  @override
  void initState() {
    super.initState();
    controller = BLEController();

    // Start scanning for devices
    controller.scandevices();

  }

  @override
  Widget build(BuildContext context) {
    print("Showing dashboard");

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body:  GetBuilder<BLEController>(
        init: controller,
        builder: (BLEController controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              GestureDetector(
                onTap: () {
                  // Handle button tap
                  controller.disconnectdevice();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const DevicesPage()),
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surface, // Set background color to blue
                      borderRadius:
                          BorderRadius.circular(8), // Set rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: 12), // Add padding for spacing
                    child: Row(
                      mainAxisSize: MainAxisSize
                          .min, // Allow the row to occupy minimum space
                      children: [
                        Icon(Icons.bluetooth_disabled,
                            color: Theme.of(context)
                                .colorScheme
                                .inversePrimary), // Refresh icon
                        const SizedBox(
                            width: 8), // Add some space between icon and label
                        Text(
                          "Disconnect",
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontSize: 16), // Set label text style
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ]
          );
        }
      )
    );
  }
}
