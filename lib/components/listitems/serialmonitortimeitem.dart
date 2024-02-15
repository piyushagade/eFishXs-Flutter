import 'package:efishxs/controllers/ble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SerialMonitorTimeItem extends StatelessWidget {
  final controller = Get.find<BLEController>();

  SerialMonitorTimeItem({super.key});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 2.0, 0, 0),
            child: Text(
              DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()),
              style: const TextStyle(
                color: Color.fromARGB(255, 203, 203, 203),
                fontSize: 10,
              ),
            ),
          ),
      
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}