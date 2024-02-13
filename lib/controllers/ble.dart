import 'dart:async';
import 'dart:developer';
import 'dart:ffi';

import 'package:efishxs/pages/devices.dart';
import 'package:efishxs/pages/home.dart';
import 'package:efishxs/pages/serialmonitor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

class BLEController extends GetxController {
  FlutterBlue ble = FlutterBlue.instance;
  late BluetoothDevice connecteddevice;
  bool connected = false;

  late SerialMonitorPage serialMonitorPage;

  // Define a function type for the callback
  late void Function() onDisconnect;

  // Constructor to receive the callback function
  BLEController({required this.onDisconnect});

  BluetoothDevice? device;
  List<String> characteristicInfo = [];
  List<int> buffer = [];
  late BluetoothCharacteristic? targetcharacteristic;
  late BluetoothService targetservice;
  
  late Timer timer;
  late StreamSubscription<List<ScanResult>> subscription;

  List<String> serialdataarray = ["test", "xcv"].obs;
  var lastserialline = "".obs;

  bool isScanning = false;

  @override
  void dispose() {
    // Cancel timer when widget is disposed
    timer.cancel();
    super.dispose();
  }

  Future<void> scandevices() async {
    
    if (!isScanning) {
      isScanning = true;

      // Check Bluetooth permissions
      var blePermission = await Permission.bluetoothScan.status;
      if (blePermission.isDenied) {
        if (await Permission.bluetoothScan.request().isGranted &&
            await Permission.bluetoothConnect.request().isGranted) {
        }
      } else {
      }

      // Start scanning
      await ble.startScan(timeout: Duration(seconds: 10));

      isScanning = false;

      // connecteddevice!.disconnect();
      // Listen to scan results
      subscription = ble.scanResults.listen((results) {
        // Process scan results here
        // print("Found ${results.length} devices");

        for (ScanResult result in results) {
          // Add the device name to the list
        }
      });

      // Stop scanning after 10 seconds
      await Future.delayed(const Duration(seconds: 5));
      await ble.stopScan();
      subscription.cancel();
    }

    else {
      print('Another scan is already in progress.');
    }
  }

  void connectdevice(context, BluetoothDevice device) async {
    print('LOG: Connecting to device: ${device.name}');

    try {
      await device.connect();
      print("LOG: Device connected");
      connecteddevice = device;
      connected = true;

      Future.delayed(const Duration(milliseconds: 100), () {
        Get.to(const HomePageWidget());
      });

      // Get services
      List<BluetoothService> services = await device.discoverServices();
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == "0000ffe1-0000-1000-8000-00805f9b34fb") {
            targetservice = service;
            targetcharacteristic = characteristic;
          }
        }
      }

      // Read the value of the target characteristic
      if (targetservice != null && targetcharacteristic != null) {
        listenfordata();

        // readdata();
        // // Start periodic timer
        // timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
        //   readdata();
        // });
      }

      subscription.cancel();

      // Handle disconnections
      Future.delayed(const Duration(seconds: 1), () {
        device.state.listen((event) {
          if (event == BluetoothDeviceState.disconnected) {
            try {
              subscription.cancel();
              onDisconnect();
            }
            catch (e) {
              print ("LOG: Error");
              print (e);
            }

            print("LOG: Device disconnected.");
            Get.to(const DevicesPage());
          }
        });
      });
    } catch (e) {
      // Handle connection errors
      print('Error: $e');
    }
  }

  Future<void> listenfordata() async {
    try {

      // Enable notifications for this characteristic
      await targetcharacteristic!.setNotifyValue(true);

      // Listen for notifications
      targetcharacteristic!.value.listen((value) {
        var data = String.fromCharCodes(value);
        serialdataarray.add(data);
      });
    } catch (e) {
      // Handle errors
      print("LOGERR: " + e.toString());
    }
  }

  void disconnectdevice() async {
    try {
      print('LOG: Disconnecting from device: ${connecteddevice.name}');
      await connecteddevice.disconnect();
      connected = false;
    } catch (e) {
      print('LOG: Error disconnecting from device: $e');
    }
  }

  bool isconnected () {
    return connected;
  }

  void disconnectalldevices() async {

    List<BluetoothDevice> connectedDevices = await ble.connectedDevices;
    // Disconnect from each connected device
    for (BluetoothDevice device in connectedDevices) {
      await device.disconnect();
    }
  }

  Stream<List<ScanResult>> get ScanResults => ble.scanResults;
}
