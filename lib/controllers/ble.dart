import 'dart:async';
import 'dart:developer';

import 'package:efishxs/pages/devices.dart';
import 'package:efishxs/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

class BLEController extends GetxController {
  FlutterBlue ble = FlutterBlue.instance;
  late BluetoothDevice connecteddevice;
  bool connected = false;
  
  BluetoothDevice? device;
  BluetoothCharacteristic? characteristic;
  List<String> characteristicInfo = [];
  List<int> buffer = [];
  late BluetoothService targetservice;
  
  late Timer timer;

  @override
  void dispose() {
    // Cancel timer when widget is disposed
    timer.cancel();
    super.dispose();
  }

  Future<void> scandevices() async {

    // Check Bluetooth permissions
    var blePermission = await Permission.bluetoothScan.status;
    if (blePermission.isDenied) {
      if (await Permission.bluetoothScan.request().isGranted &&
          await Permission.bluetoothConnect.request().isGranted) {
      }
    } else {
    }

    // Start scanning
    await ble.startScan(timeout: Duration(seconds: 4));

    // connecteddevice!.disconnect();
    // Listen to scan results
    var subscription = ble.scanResults.listen((results) {
      // Process scan results here
      print("Found ${results.length} devices");

      for (ScanResult result in results) {
        // Add the device name to the list
      }
    });

    // Stop scanning after 10 seconds
    await Future.delayed(Duration(seconds: 5));
    await ble.stopScan();
    subscription.cancel();
  }

  void connectdevice(context, BluetoothDevice device) async {
    print('Connecting to device: ' + device.name + ", ID: " + device.id.id);

    try {
      await device.connect();
      print("Device connected");
      connecteddevice = device;
      connected = true;

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePageWidget()),
        );
      });

      BluetoothDeviceType type = device.type;
      // Device connected successfully

      // Get services
      List<BluetoothService> services = await device.discoverServices();
        for (BluetoothService service in services) {
          for (BluetoothCharacteristic characteristic in service.characteristics) {
            if (characteristic.uuid.toString() == "0000ffe1-0000-1000-8000-00805f9b34fb") {
              targetservice = service;
            }
          }
        }

        // Read the value of the target characteristic
        if (targetservice != null) {

          readdata();
          // Start periodic timer
          timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
            readdata();
          });
        }


      // Handle disconnections
      Future.delayed(const Duration(seconds: 1), () {
        device.state.listen((event) {
          if (event == BluetoothDeviceState.disconnected) {
            print('Device disconnected. Showing the list.');

            if(connected) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DevicesPage()),
              );
            }
          }
        });
      });
    } catch (e) {
      // Handle connection errors
      print('Error: $e');
    }
  }

  Future<String> readdata () async {
    List<BluetoothCharacteristic> characteristics = targetservice.characteristics;
    for (BluetoothCharacteristic characteristic in characteristics) {
      if (characteristic.uuid.toString() == '0000ffe1-0000-1000-8000-00805f9b34fb') {
        
        List<int> value = await characteristic.read();
        // Convert the value to a string and update the UI
        var characteristicValue = String.fromCharCodes(value);
        print (characteristicValue);
        return characteristicValue;
      }
    }
    return "";
  }

  void disconnectdevice() async {
    // try {
    //   await connecteddevice.disconnect();
    //   connected = false;
    //   print('Disconnected from device: ${connecteddevice.name}, ID: ${connecteddevice.id}');
    // } catch (e) {
    //   print('Error disconnecting from device: $e');
    // }

    List<BluetoothDevice> connectedDevices = await ble.connectedDevices;
    // Disconnect from each connected device
    for (BluetoothDevice device in connectedDevices) {
      await device.disconnect();
    }
  }

  Stream<List<ScanResult>> get ScanResults => ble.scanResults;
}
