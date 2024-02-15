import 'package:efishxs/controllers/ble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SerialMonitorItem extends StatelessWidget {
  final String data;
  final String type;
  SerialMonitorItem({super.key, required this.data, this.type = "incoming"});
  final controller = Get.find<BLEController>();

  @override
  Widget build(BuildContext context) {
    Color color = type == "incoming" ? Color.fromARGB(255, 31, 212, 37) : 
        type == "outgoing" ? Color.fromARGB(255, 194, 30, 139) : Color.fromARGB(255, 223, 195, 13);

    return SizedBox(
      height: 20,
      child: Text(
        data.trimRight(),
        textAlign: TextAlign.left,
        style: TextStyle(
          color: color,
          fontSize: 13,
        ),
      ),
    );
  }
}