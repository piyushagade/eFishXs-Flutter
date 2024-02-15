import 'package:efishxs/components/buttons/button.dart';
import 'package:efishxs/components/ui/heading.dart';
import 'package:efishxs/components/listitems/serialmonitoritem.dart';
import 'package:efishxs/components/listitems/serialmonitortimeitem.dart';
import 'package:efishxs/controllers/ble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SerialMonitorPage extends StatelessWidget {

  final controller = Get.find<BLEController>();
  bool showtimestamp = true;

  void sendcommand(String command) {
    controller.senddata(command);

    controller.serialtimewidgetarray.add(SerialMonitorTimeItem());
    controller.serialdatawidgetarray.add(SerialMonitorItem(
      data: command,
      type: "outgoing",
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HeadingWidget(
                heading: "Serial Monitor",
                subheading:
                  "Logs every communication to and from your bluetooth device.",
                  marginBottom: 0,
            ),

            // Action buttons
            Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
              
                  ButtonWidget(
                      label: "",
                      icon: Icons.share_rounded,
                          backgroundColor: const Color.fromARGB(255, 200, 200, 200),
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                          scale: 0.8,
                      onTap: () {
                    },
                  ),
                  
                  const Spacer(),
              
                  const SizedBox(width: 8,),
                  
                  Obx(() => Opacity(
                    opacity: controller.showTimestamp.value ? 1 : 0.2,
                      child: ButtonWidget(
                          label: "",
                          icon: Icons.timer_rounded, 
                          backgroundColor: const Color.fromARGB(255, 200, 200, 200),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          scale: 0.8,
                          onTap: () {
                            controller.showTimestamp.value =
                                !controller.showTimestamp.value;
                          }),
                    ),
                  ),
              
                  const SizedBox(width: 8,),
              
                  ButtonWidget(
                      label: "",
                      icon: Icons.delete_sweep_outlined,
                          backgroundColor: const Color.fromARGB(255, 164, 142, 142),
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                          scale: 0.8,
                      onTap: () {
                        controller.serialtimewidgetarray.value = [];
                        controller.serialdatawidgetarray.value = [];
                        controller.serialtimewidgetarray.add(SerialMonitorTimeItem());
                        controller.serialdatawidgetarray.add(SerialMonitorItem(
                            data: "Monitor cleared", type: "status"));
                      }),
              
                ],
              ),
            ),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 20, 20, 20),
                  borderRadius: BorderRadius.circular(2),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Obx(
                  () => SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    reverse: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Row(
                        children: [
                          Visibility(
                            visible: controller.showTimestamp.value,
                            child: Container(
                              child: Column(
                                children: controller.serialtimewidgetarray.value,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: controller.serialdatawidgetarray.value,
                          ),
                        ],
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
                  ButtonWidget(
                      label: "Ping",
                      icon: Icons.refresh,
                      onTap: () {
                        String command = "ping";
                        sendcommand(command);

                      }),
                  const SizedBox(width: 16),
                  ButtonWidget(
                      label: "Help",
                      icon: Icons.refresh,
                      onTap: () {
                        String command = "help";
                        sendcommand(command);
                      }),
                  const SizedBox(width: 16),
                  ButtonWidget(label: "Add", icon: Icons.add, onTap: () {}),
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
