import 'dart:async';
import 'dart:convert';

import 'package:efishxs/pages/devices.dart';
import 'package:efishxs/pages/home.dart';
import 'package:efishxs/pages/serialmonitor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class BLEController extends GetxController {
  FlutterBlue ble = FlutterBlue.instance;
  late BluetoothDevice connecteddevice;
  RxBool connected = false.obs;

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
  late StreamSubscription<List<ScanResult>> subscription;
  late StreamSubscription<BluetoothDeviceState> statelistener;
  late StreamSubscription<List<int>> datastreamlistener;

  RxList<String> serialdataarray = <String>[].obs;
  RxList<Widget> serialdatawidgetarray = <Widget>[].obs;
  var lastserialline = "".obs;
  bool isScanning = false;

  
  RxBool isOn = true.obs;
  RxBool isAvailable = true.obs;

  @override
  void onInit() {
    print('LOG: BLEController onInit');
    isBluetoothAvailable();
    super.onInit();

    // Handle bluetooth events
    Future.delayed(const Duration(seconds: 1), () {
      ble.state.listen((event) async {
        print ("LOG: State: " + event.toString());

        if (event == BluetoothState.on) {
          print('LOG: Bluetooth turned ON');
          isBluetoothOn();
          
          // Update the devices list
          await Future.delayed(const Duration(seconds: 2), () {
            scandevices();
          });

        } else if (event == BluetoothState.off) {
          print('LOG: Bluetooth turned OFF');
          isBluetoothOn();
          
          await Future.delayed(const Duration(seconds: 2), () {
            scandevices();
          });
        }
      });
    });
  }

  @override
  void onReady() {
    print('LOG: BLEController onReady');
    super.onReady();
  }

  Future<bool> isBluetoothOn() async {
    isOn.value = await ble.isOn;
    print("LOG: Bluetooth is " + (isOn.value ? "ON" : "OFF"));
    return isOn.value;
  }

  Future<bool> isBluetoothAvailable() async {
    isAvailable.value = await ble.isAvailable;
    print("LOG: Bluetooth " + (isOn.value ? "is" : "is not") + " available");
    return isAvailable.value;
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

      // Listen to scan results
      subscription = ble.scanResults.listen((results) {
        // print("Found ${results.length} devices");
        // for (ScanResult result in results) {}
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
      await connecteddevice!.disconnect();
    }
    catch (e) {
      print(e);
    }

    try {
      final connecttimeouttimer = Timer(const Duration(seconds: 5), () async {
        Get.snackbar(
          "Bluetooth error",
          "We couldn't establish a connection. Likely, the device is not powered on.",
          animationDuration: const Duration(milliseconds: 200),
          borderRadius: 2,
          icon: const Icon(Icons.bluetooth_disabled),
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
          margin: const EdgeInsets.all(20),
          backgroundColor: const Color.fromARGB(255, 73, 29, 20),
        );

        // Prevent autoconnection
        device.disconnect();
      });

      Get.snackbar(
        "Connecting to your device",
        "Please wait while we establish a connection.",
        animationDuration: const Duration(milliseconds: 200),
        borderRadius: 2,
        icon: const Icon(Icons.bluetooth_disabled),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        backgroundColor: const Color.fromARGB(255, 39, 73, 20),
      );
      
      await device.connect();
      connecttimeouttimer.cancel();

      print("LOG: Device connected");

      final connectionuitimeouttimer = Timer(const Duration(seconds: 3), () async {
        
      connecteddevice = device;
      connected.value = true;

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

        if (targetcharacteristic != null) {
          print("LOG: Valid GatorByte device detected.");
          Future.delayed(const Duration(milliseconds: 100), () {
            Get.to(() => const HomePageWidget());
          });
        }
        else {
          print("LOG: Not a valid GatorByte device.");
        }

        // Read the value of the target characteristic
        if (targetservice != null && targetcharacteristic != null) {
          listenfordata();
        }

        // Handle device events
        Future.delayed(const Duration(seconds: 1), () {
          statelistener = device.state.listen((event) async {
            print ("LOG: State: " + event.toString());

            // Handle disconnections
            if (event == BluetoothDeviceState.disconnected || event == BluetoothDeviceState.disconnecting) {
              try {
                print('LOG: Disconnecting from device: ${connecteddevice.name}');
                await connecteddevice.disconnect();
                connected.value = false;

              } catch (e) {
                print('LOG: Error disconnecting from device: $e');
              }
              
              try {
                
                Get.snackbar(
                  "Notification",
                  "The device has disconnected.",
                  animationDuration: const Duration(milliseconds: 200),
                  borderRadius: 2,
                  icon: const Icon(Icons.bluetooth_disabled),
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 3),
                  margin: const EdgeInsets.all(20),
                  backgroundColor: const Color.fromARGB(255, 94, 80, 13),
                );

                statelistener!.cancel();
                subscription!.cancel();
                datastreamlistener!.cancel();
                onDisconnect();
                connected.value = false;
                print("LOG: Device disconnected.");

              }
              catch (e) {
                print ("LOGERR: Error while cleanup after disconnecting.");
                print (e);
              }

              // // Show devices page
              // Get.offAll(DevicesPage());
            }
          });
        });
      });
    } catch (e) {
      // Handle connection errors
      print('LOGERR: Error: $e');
    }
  }

  Future<void> listenfordata() async {
    try {

      print("LOG: Enabling data stream listener");

      // Enable notifications for this characteristic
      await targetcharacteristic!.setNotifyValue(true);

      // Listen for notifications
      datastreamlistener = targetcharacteristic!.value.listen((value) {
        var data = String.fromCharCodes(value);
        print("LOG: New data: " + data);
        serialdataarray.add(data);

        serialdatawidgetarray.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
                Text(
                  data.trimRight(),
                  style: const TextStyle(
                    color: Color.fromARGB(255, 23, 167, 28),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );
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
      connected.value = false;

    } catch (e) {
      print('LOG: Error disconnecting from device: $e');
    }
  }

  bool isconnected () {
    return connected.value;
  }

  void disconnectalldevices() async {

    List<BluetoothDevice> connectedDevices = await ble.connectedDevices;
    // Disconnect from each connected device
    for (BluetoothDevice device in connectedDevices) {
      await device.disconnect();
    }
  }

  Stream<List<ScanResult>> get ScanResults => ble.scanResults;

  // Write data to the characteristic
  Future<void> senddata(String data) async {
    try {
      await targetcharacteristic?.write(utf8.encode(data));
    }
    catch (e) {
      print("LOGERR: " + e.toString());
    }
    return;
  }
}
