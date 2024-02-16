import 'dart:async';
import 'dart:convert';

import 'package:efishxs/components/listitems/serialmonitoritem.dart';
import 'package:efishxs/components/listitems/serialmonitortimeitem.dart';
import 'package:efishxs/pages/devices.dart';
import 'package:efishxs/pages/home.dart';
import 'package:efishxs/pages/serialmonitor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BLEController extends GetxController {
  FlutterBlue ble = FlutterBlue.instance;
  late BluetoothDevice connecteddevice;
  late int devicesCount;
  RxBool connected = false.obs;
  late String disconnectionreason;

  late SerialMonitorPage serialMonitorPage;

  // Define a function type for the callback
  late void Function() onDisconnect;
  late Timer reconnectiontimer;

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
  RxList<Widget> serialtimewidgetarray = <Widget>[].obs;
  RxList<Widget> serialdatawidgetarray = <Widget>[].obs;
  var lastserialline = "".obs;
  RxBool isScanning = false.obs;
  RxBool isConnecting = false.obs;
  RxString statusText = "".obs;

  RxBool isOn = true.obs;
  RxBool isAvailable = true.obs;
  RxBool showTimestamp = true.obs;
  
  SharedPreferences? _prefs;
  late Future<void> _prefsFuture;

  @override
  void onInit() {
    print('LOG: BLEController onInit');
    isBluetoothAvailable();
    super.onInit();
    
    _prefsFuture = SharedPreferences.getInstance().then((value) {
      _prefs = value; 
    });

    // Handle bluetooth events
    Future.delayed(const Duration(seconds: 1), () {
      ble.state.listen((event) async {

        if (event == BluetoothState.turningOn) {
          print('LOG: Bluetooth turned ON');
          isBluetoothOn();
          
          // Update the devices list
          await Future.delayed(const Duration(seconds: 2), () {
            scandevices();
          });

          serialtimewidgetarray.add(SerialMonitorTimeItem());
          serialdatawidgetarray.add(SerialMonitorItem(
              data: "Bluetooth turned ON",
              type: "status",
            ),
          );

        } else if (event == BluetoothState.turningOff) {
          print('LOG: Bluetooth turned OFF');
          isBluetoothOn();
          
          await Future.delayed(const Duration(seconds: 2), () {
            scandevices();
          });
          
          serialtimewidgetarray.add(SerialMonitorTimeItem());
          serialdatawidgetarray.add(SerialMonitorItem(
              data: "Bluetooth turned OFF",
              type: "status",
            ),
          );
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
    try { statusText.value = "Found $devicesCount device(s)."; } catch (e) {}
    WidgetsBinding.instance!.addPostFrameCallback((_) {
        statusText.value = "Scanning for nearby devices";
    });

    if (!isScanning.value) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        isScanning.value = true;
      });

      // Check Bluetooth permissions
      var blePermission = await Permission.bluetoothScan.status;
      if (blePermission.isDenied) {
        if (await Permission.bluetoothScan.request().isGranted &&
            await Permission.bluetoothConnect.request().isGranted) {
        }
      } else {}

      // Start scanning
      await ble.startScan(timeout: const Duration(seconds: 5));

      // Listen to scan results
      subscription = ble.scanResults.listen((results) {
        devicesCount = 0;
        for (ScanResult result in results) {
          if (result.device.name.isNotEmpty) {
            devicesCount++;
          }
        }
      });

      // Stop scanning after 5 seconds
      await ble.stopScan();
      statusText.value = "Found $devicesCount device(s).";
      print("LOG: Scanning stopped.");
      isScanning.value = false;
      subscription.cancel();
    }

    else {
      print('Another scan is already in progress.');
    }
  }

  void connectdevice(context, BluetoothDevice device) async {
    disconnectionreason = "";
    isConnecting.value = true;
    print('LOG: Connecting to device: ${device.name}');

    var connectingsnackbar = Get.snackbar(
      "Connecting to your device",
      "Please wait while we establish a connection.",
      animationDuration: const Duration(milliseconds: 200),
      borderRadius: 2,
      icon: const Icon(Icons.bluetooth_disabled),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(20),
      backgroundColor: const Color.fromARGB(255, 74, 74, 73),
    );

    try {
      await connecteddevice!.disconnect();
    } catch (e) {
      print(e);
    }

    try {
      final connecttimeouttimer = Timer(const Duration(seconds: 5), () async {
      try { connectingsnackbar.close(); } catch (e) {}
      isConnecting.value = false;

      var connectionerrorsnackbar = Get.snackbar(
          "Bluetooth error",
          "We couldn't establish a connection. Likely, the device is not powered on or out of range.",
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

      await device.connect();
      connecttimeouttimer.cancel();

      print("LOG: Device connected");

      final connectionuitimeouttimer = Timer(
        const Duration(seconds: 1),
        () async {
          try { connectingsnackbar.close(); } catch (e) {}
          isConnecting.value = false;
          try { reconnectiontimer.cancel(); } catch (e) {}

          // Get services
          try {
            List<BluetoothService> services = await device.discoverServices();
            for (BluetoothService service in services) {
              for (BluetoothCharacteristic characteristic
                  in service.characteristics) {
                if (characteristic.uuid.toString() ==
                    "0000ffe1-0000-1000-8000-00805f9b34fb") {
                  targetservice = service;
                  targetcharacteristic = characteristic;
                }
              }
            }

            if (targetcharacteristic != null) {
              print("LOG: Valid GatorByte device detected.");
              Future.delayed(const Duration(milliseconds: 100), () {
                Get.to(() => const HomePageWidget());
                
                var connectedsnackbar = Get.snackbar(
                  "Connected",
                  "The device is now connected.",
                  animationDuration: const Duration(milliseconds: 200),
                  borderRadius: 2,
                  icon: const Icon(Icons.bluetooth),
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                  margin: const EdgeInsets.all(20),
                  backgroundColor: const Color.fromARGB(255, 30, 82, 40),
                );
                
              });
            } else {
              print("LOG: Not a valid GatorByte device.");

              var connectedsnackbar = Get.snackbar(
                  "Connected",
                  "The device is now connected. However, this is not a valid device.",
                  animationDuration: const Duration(milliseconds: 200),
                  borderRadius: 2,
                  icon: const Icon(Icons.bluetooth),
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                  margin: const EdgeInsets.all(20),
                  backgroundColor: const Color.fromARGB(255, 30, 82, 40),
                );
            }
            

            connecteddevice = device;
            connected.value = true;
            serialtimewidgetarray.add(SerialMonitorTimeItem());
            serialdatawidgetarray.add(
              SerialMonitorItem(
                data: "Device connected",
                type: "status",
              ),
            );

            // Read the value of the target characteristic
            if (targetservice != null && targetcharacteristic != null) {
              listenfordata();
            }

            // Handle device events
            Future.delayed(
              const Duration(seconds: 1),
              () {
                statelistener = device.state.listen((event) async {
                  print("LOG: State: " + event.toString());

                  // Handle disconnections
                  if (event == BluetoothDeviceState.disconnected ||
                      event == BluetoothDeviceState.disconnecting) {
                    try {
                      if (disconnectionreason != "user") disconnectionreason = "device";
                      print('LOG: Disconnecting from device: ${connecteddevice.name.trim()}' + ". Reason: " + disconnectionreason + ".");
                      await connecteddevice.disconnect();
                      connected.value = false;


                      serialtimewidgetarray.add(SerialMonitorTimeItem());
                      serialdatawidgetarray.add(
                        SerialMonitorItem(
                          data: "Device disconnected",
                          type: "status",
                        ),
                      );
                    } catch (e) {
                      print('LOG: Error disconnecting from device: $e');
                    }
                    
                    bool reconnect = _prefs?.getBool("settings/serialmonitor/autoconnect") ?? true;
                    Future.delayed(const Duration(milliseconds: 200));

                    try {
                      Get.snackbar(
                        "Notification",
                        "The device has disconnected.${reconnect && disconnectionreason == "device" ? " Waiting for the device for reconnection." : ""}",
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

                      if (reconnect && disconnectionreason == "device") {
                        reconnectiontimer = Timer.periodic(const Duration (seconds: 5), (timer) {
                          print ("LOG: Attempting reconnection");
                          connectdevice(context, connecteddevice);
                        });
                      }
                    } catch (e) {
                      print("LOGERR: Error while cleanup after disconnecting.");
                      print(e);
                    }

                    // // Show devices page
                    // Get.offAll(DevicesPage());
                  }
                });
              },
            );
            
          }
          catch (e) {
            print ("LOGERR: " + e.toString());
          }
        },
      );
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
      String stringbuffer = "";
      datastreamlistener = targetcharacteristic!.value.listen((value) {
        var data = String.fromCharCodes(value);
        var lineendingchar = ["\r\n", "\r", "\n"][_prefs?.getInt("settings/serialmonitor/lineending") ?? 0];

        // Wait for EOL character
        stringbuffer += data;
        if (data.endsWith(lineendingchar)) {
          serialdataarray.add(stringbuffer);

          serialtimewidgetarray.add(SerialMonitorTimeItem());
          serialdatawidgetarray.add(SerialMonitorItem(
              data: stringbuffer.trimRight(),
              type: "incoming",
            ),
          );

          // Reset buffer
          stringbuffer = "";
        }
      });
    } catch (e) {
      // Handle errors
      print("LOGERR: " + e.toString());
    }
  }

  void disconnectdevice() async {
    try { reconnectiontimer.cancel(); } catch (e) {}

    try {
      print('LOG: Disconnecting from device: ${connecteddevice.name}');
      await connecteddevice.disconnect();
      connected.value = false;
      disconnectionreason = "user";

    } catch (e) {
      print('LOG: Error disconnecting from device: $e');
    }
  }

  bool isconnected () {
    return connected.value;
  }

  void disconnectalldevices() async {
    try { reconnectiontimer.cancel(); } catch (e) {}

    List<BluetoothDevice> connectedDevices = await ble.connectedDevices;
    // Disconnect from each connected device
    for (BluetoothDevice device in connectedDevices) {
      await device.disconnect();
    }
  }

  Stream<List<ScanResult>> get ScanResults => ble.scanResults;

  Future<int> getFoundDevicesCount() async {
    int count =  0;
    await for (var result in ScanResults) {
      count += 1;
      statusText.value = "Found $count devices.";
    }
    
    return count;
  }

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
