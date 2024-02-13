import 'package:efishxs/components/button.dart';
import 'package:efishxs/controllers/ble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SerialMonitorPage extends StatelessWidget {
  final controller = Get.find<BLEController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 233, 238, 233),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Obx(
                  () => SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                      child: Text(
                        controller.serialdataarray.join(""),
                        style: TextStyle(fontSize: 13),
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

                  ButtonWidget(label: "Ping", icon: Icons.refresh, onTap: () {
                    
                  }),
                  
                  const SizedBox(width: 16),
                  ButtonWidget(label: "Help", icon: Icons.refresh, onTap: () {
                                
                  }),
                  
                  const SizedBox(width: 16),
                  ButtonWidget(label: "Add", icon: Icons.add, onTap: () {
                                
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}