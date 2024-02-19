// ignore_for_file: avoid_print, dead_code

import 'package:efishxs/pages/devices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  Future<bool?> requestMultiplePermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.camera,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.storage,
      Permission.accessMediaLocation
    ].request();

    return statuses[Permission.bluetoothScan]?.isGranted;
  }

  @override
  Widget build(BuildContext context) {

    // requestMultiplePermissions().then((bool? permissiongranted) {

      // print ("LOG: BL permission granted: $permissiongranted");

      Future.delayed(const Duration(seconds: 2), () {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const DevicesPage()),
        // );

        Get.to(() => const DevicesPage());
      });
    // });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("assets/images/cereal.png", height: 150),
              ),

              const SizedBox(height: 40),

              Text("Initializing application",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.inversePrimary
                )
              ),

              const SizedBox(height: 2),

              Opacity(
                opacity: 0.4,
                child: Text("Loading configuration",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.inversePrimary
                  )
                ),
              )
          ],
        ),
      )
    );
  }
}