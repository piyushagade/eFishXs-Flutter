import 'package:efishxs/components/button.dart';
import 'package:efishxs/components/heading.dart';
import 'package:efishxs/controllers/ble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SerialMonitorPage extends StatelessWidget {
  // final controller = Get.put(BLEController(
  //   onDisconnect: () {},
  // ));
  
  final controller = Get.find<BLEController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            HeadingWidget(heading: "Serial Monitor", subheading: "Logs every communication to and from your bluetooth device."),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(2),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Obx(
                  () => SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Text(
                        controller.serialdataarray.join(""),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 25, 204, 60)
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  const SizedBox(width: 16),
                  ButtonWidget(label: "Ping", icon: Icons.refresh, onTap: () {
                    controller.senddata("ping");

                    controller.serialdataarray.add("< ping\n");
                  }),
                  
                  const SizedBox(width: 16),
                  ButtonWidget(label: "Help", icon: Icons.refresh, onTap: () {
                    controller.senddata("help");
                    
                    controller.serialdataarray.add("< help\n");
                  }),
                  
                  const SizedBox(width: 16),
                  ButtonWidget(label: "Add", icon: Icons.add, onTap: () {
                                
                  }),
                  
                  const SizedBox(width: 16),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}