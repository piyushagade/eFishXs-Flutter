import 'dart:ffi';

import 'package:efishxs/controllers/ble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SerialMonitorItem extends StatefulWidget {
  final String data;
  final String type;
  SerialMonitorItem({super.key, required this.data, this.type = "incoming"});

  @override
  State<SerialMonitorItem> createState() => _SerialMonitorItemState();
}

class _SerialMonitorItemState extends State<SerialMonitorItem> {
  final controller = Get.find<BLEController>();
  List<double> fontsizes = const [7, 8, 9, 10, 12, 14, 16, 20];
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
    Color color = widget.type == "incoming" ? const Color.fromARGB(255, 31, 212, 37) : 
        widget.type == "outgoing" ? const Color.fromARGB(255, 194, 30, 139) : const Color.fromARGB(255, 223, 195, 13);

    double mediawidth = MediaQuery.of(context).size.width;
    print(MediaQuery.of(context).size.width);

    double width = mediawidth - 160;

    if (mediawidth >= 600) {
      width = mediawidth - 170;
    } else if (mediawidth >= 400) {
      width = mediawidth - 160;
    }
    else if (mediawidth < 400) {
      width = mediawidth - 150;
    }

    Widget body = SizedBox(
      // height: 17.0 + (_prefs?.getInt("settings/serialmonitor/fontsize") ?? 3 / 1.8) * 1.8,

      width: width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          widget.data.trimRight(),
          textAlign: TextAlign.left,
          overflow: TextOverflow.clip,
          maxLines:
              null, // Set to null to allow text wrapping to multiple lines
          style: TextStyle(
            color: color,
            fontSize: fontsizes[
                    _prefs?.getInt("settings/serialmonitor/fontsize") ??
                        3] +
                3,
          ),
        ),
      ),
    );

    return FutureBuilder<void>(
      future: _prefsFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text(''); // Show loading indicator while waiting for _prefs to be initialized
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