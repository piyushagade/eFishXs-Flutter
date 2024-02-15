import 'package:efishxs/controllers/ble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SerialMonitorTimeItem extends StatefulWidget {

  SerialMonitorTimeItem({super.key});

  @override
  State<SerialMonitorTimeItem> createState() => _SerialMonitorTimeItemState();
}

class _SerialMonitorTimeItemState extends State<SerialMonitorTimeItem> {
  final controller = Get.find<BLEController>();
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

    List<String> formats = const ["yyyy-MM-dd hh:mm:ss", "yy-MM-dd hh:mm:ss", "MM-dd hh:mm:ss", "hh:mm:ss"];
    List<double> fontsizes = const [7, 8, 9, 10, 12, 14, 16, 20];

    Widget body = SizedBox(
      height: 17.0 + (_prefs?.getInt("settings/serialmonitor/fontsize") ?? 3 / 1.8) * 1.8,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 2.0, 0, 0),
            child: Text(
              DateFormat(formats[_prefs?.getInt("settings/serialmonitor/timestampformat") ?? 1]).format(DateTime.now()),
              style: TextStyle(
                color: const Color.fromARGB(255, 203, 203, 203),
                fontSize: fontsizes[_prefs?.getInt("settings/serialmonitor/fontsize") ?? 4],
              ),
            ),
          ),
      
          const SizedBox(width: 8),
        ],
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