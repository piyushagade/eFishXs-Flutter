// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:efishxs/components/listitems/serialmonitordataitem.dart';
import 'package:efishxs/components/listitems/serialmonitortimeitem.dart';
import 'package:efishxs/pages/home.dart';
import 'package:efishxs/pages/serialmonitor.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BLEController extends GetxController {
  FlutterBlue ble = FlutterBlue.instance;
  late BluetoothDevice connecteddevice;
  late int devicesCount;
  RxBool connected = false.obs;
  late String disconnectionreason;

  late SerialMonitorPage serialMonitorPage;

  // Define a function type for the callback
  // late void Function() onDisconnect = () => {};
  late Timer reconnectiontimer;
  
  late SnackbarController activesnackbar;

  // Constructor to receive the callback function
  BLEController();

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
  RxString status = "busy".obs;

  RxBool isOn = true.obs;
  RxBool isAvailable = true.obs;
  RxBool showTimestamp = true.obs;
  
  SharedPreferences? _prefs;
  late Future<void> _prefsFuture;

  Future<List> readlog() async {
    List<dynamic> json = [];
    
    final directory = await getApplicationDocumentsDirectory();
    final String fileName = '${DateFormat("yy-MM-dd").format(DateTime.now())}.json';
    File file = File('${directory.path}/${connecteddevice.name}/$fileName');

    try {
      // Read the existing JSON data from the file if it exists
      if (file.existsSync()) {
        String fileContent = file.readAsStringSync();
        json = jsonDecode(fileContent);
      }
      print ("LOG: File read successfully");
      print ("LOG: ${jsonEncode(json)}");
    }
    catch (e) {
      print('LOG: Failed to write file: $e');
    }

    return json;
  }

  Future<String> getlocation() async {
    // print("LOG: Getting location data.");
    String locationdata = "";

    try {
      // print("LOG: Getting last known location.");
      Position? lastposition = await Geolocator.getLastKnownPosition();
      locationdata = '${lastposition?.latitude}, ${lastposition?.longitude}';

      // print("LOG: Getting current location.");
      // Position position = await Geolocator.getCurrentPosition();
      // locationdata = '${position?.latitude}, ${position?.longitude}';
      // print("LOG: All position information acquired.");

      return locationdata;
    } catch (e) {
      locationdata = 'Error getting location: $e';
    }

    // print("LOG: $locationdata");
    return locationdata;
  }

  Future<void> logtostorage(String content) async {
    
    if (_prefs?.getBool("settings/serialmonitor/logtofile") ?? true){
      final String fileName = '${DateFormat("yy-MM-dd").format(DateTime.now())}.json';

      try {
        // Get the directory where the file will be saved
        final directory = await getApplicationDocumentsDirectory();
        File file = File('${directory.path}/${connecteddevice.name}/$fileName');

        List<dynamic> json = [];
        Map<String, dynamic> line = {};
        line["content"] = content;
        line["timestamp"] = DateFormat("yy-MM-dd hh:mm:ss a").format(DateTime.now());
        line["location"] = _prefs?.getBool("settings/serialmonitor/gpslogging") ?? false  ? await getlocation() : "GPS logging disabled.";
        line["device"] = connecteddevice.name.trim();

        if (!file.existsSync()) {
          // If the file doesn't exist, create it and write the line
          file.createSync(recursive: true);
          file.writeAsStringSync('[]');
          // print('LOG: File created and line appended: $fileName');
        } 
        else {

          // Read file
          String fileContent = file.readAsStringSync();
          json = jsonDecode(fileContent);
        }

        // Add current line to the list
        json.add(line);

        // If the file exists, append the line
        file.writeAsStringSync(jsonEncode(json));
        // print('LOG: Line appended to existing file: ${file.path}');


        // print('LOG: Line added: ${jsonEncode(line)}');
        // print('LOG: Total lines: ${json.length}');

      } catch (e) {
        print('LOG: Failed to write file: $e');
      }
    }
  }

  Future<void> deletelogs() async {
  try {
    
    // Get the directory where the file will be saved
    Directory directory = await getApplicationDocumentsDirectory();
    if (directory.existsSync()) {
      List<FileSystemEntity> files = directory.listSync();

      // Delete each file
      for (var file in files) {
        if (file is File) {
          file.deleteSync();
          print('File deleted: ${file.path}');
        }
      }
    } else {
      print('Directory does not exist.');
    }
  } catch (e) {
    print('Failed to delete files: $e');
  }
}

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

          serialtimewidgetarray.add(const SerialMonitorTimeItem());
          serialdatawidgetarray.add(const SerialMonitorItem(
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
          
          serialtimewidgetarray.add(const SerialMonitorTimeItem());
          serialdatawidgetarray.add(const SerialMonitorItem(
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
    print("LOG: Bluetooth is ${isOn.value ? "ON" : "OFF"}");
    return isOn.value;
  }

  Future<bool> isBluetoothAvailable() async {
    isAvailable.value = await ble.isAvailable;
    print("LOG: Bluetooth ${isOn.value ? "is" : "is not"} available");
    return isAvailable.value;
  }

  /*
    Scan  for nearby devices
  */
  Future<void> scandevices() async {

    try { statusText.value = "Found $devicesCount device(s)."; } catch (e) {}
    WidgetsBinding.instance.addPostFrameCallback((_) {
        statusText.value = "Scanning for nearby devices";
        status.value = "busy";
    });

    if (!isScanning.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isScanning.value = true;
      });

      // Start scanning
      try {
        
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
        status.value = "ready";
        print("LOG: Scanning stopped.");
        isScanning.value = false;
        subscription.cancel();
      }
      catch (e) {}
    }

    else {
      print('Another scan is already in progress.');
    }
  }

  /*
    Connect to a device
  */
  void connectdevice(context, BluetoothDevice device) async {
    disconnectionreason = "";
    isConnecting.value = true;
    print('LOG: Connecting to device: ${device.name}');

    if (_prefs?.getBool("settings/general/inappnotifications") ?? true) {

      showSimpleNotification(
        const Text(
          "Please wait while we establish a connection.",
          style: TextStyle(color: Colors.white),
        ),
        background: const Color.fromARGB(255, 74, 74, 73),
        slideDismissDirection: DismissDirection.up,
      );
    }

    try {
      await connecteddevice.disconnect();
    } catch (e) {
      print(e);
    }

    try {
      final connecttimeouttimer = Timer(const Duration(seconds: 5), () async {
        isConnecting.value = false;

        if (_prefs?.getBool("settings/general/inappnotifications") ?? true) {
          showSimpleNotification(
            const Text(
              "We couldn't establish a connection. Likely, the device is not powered on or out of range.",
              style: TextStyle(color: Colors.white),
            ),
            background: const Color.fromARGB(255, 73, 29, 20),
            slideDismissDirection: DismissDirection.up,
          );
        }

        // Prevent autoconnection
        device.disconnect();
      });

      await device.connect();
      connecttimeouttimer.cancel();

      print("LOG: Device connected");

      Timer(
        const Duration(seconds: 1),
        () async {
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
                Get.off(() => const HomePageWidget());
                
                if (_prefs?.getBool("settings/general/inappnotifications") ?? true) {
                  showSimpleNotification(
                    const Text(
                      "The device is now connected.",
                      style: TextStyle(color: Colors.white),
                    ),
                    background: const Color.fromARGB(255, 30, 82, 40),
                    slideDismissDirection: DismissDirection.up,
                  );
                }
              });
            } else {
              print("LOG: Not a valid GatorByte device.");

              
              if (_prefs?.getBool("settings/general/inappnotifications") ?? true) {
                showSimpleNotification(
                  const Text(
                    "The device is now connected. However, this is not a valid device.",
                    style: TextStyle(color: Colors.white),
                  ),
                  background: const Color.fromARGB(255, 30, 82, 40),
                  slideDismissDirection: DismissDirection.up,
                );
              }
            }
            
            connecteddevice = device;
            connected.value = true;
            serialtimewidgetarray.add(const SerialMonitorTimeItem());
            serialdatawidgetarray.add(
              const SerialMonitorItem(
                data: "Device connected",
                type: "status",
              ),
            );

            // Read the value of the target characteristic
            if (targetcharacteristic != null) {
              listenfordata();
            }

            // Handle device events
            Future.delayed(
              const Duration(seconds: 1),
              () {
                statelistener = device.state.listen((event) async {
                  print("LOG: State: $event");

                  // Handle disconnections
                  if (event == BluetoothDeviceState.disconnected ||
                      event == BluetoothDeviceState.disconnecting) {
                    try {
                      if (disconnectionreason != "user") disconnectionreason = "device";
                      print('LOG: Disconnecting from device: ${connecteddevice.name.trim()} . Reason: $disconnectionreason.');
                      await connecteddevice.disconnect();
                      connected.value = false;

                      serialtimewidgetarray.add(const SerialMonitorTimeItem());
                      serialdatawidgetarray.add(
                        const SerialMonitorItem(
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
                      
                      if (_prefs?.getBool("settings/general/inappnotifications") ?? true) {

                        showSimpleNotification(
                          Text(
                            "The device has disconnected. ${reconnect && disconnectionreason == "device" ? " Waiting for the device for reconnection." : ""}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          background: const Color.fromARGB(255, 94, 80, 13),
                          slideDismissDirection: DismissDirection.up,
                        );
                      }

                      statelistener.cancel();
                      subscription.cancel();
                      datastreamlistener.cancel();
                      // onDisconnect();
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
                  }
                });
              },
            );
            
          }
          catch (e) {
            print ("LOGERR: $e");
          }
        },
      );
    } catch (e) {
      // Handle connection errors
      print('LOGERR: Error: $e');
    }
  }

  /*
    Listen for new data from the connected device
  */
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

          serialtimewidgetarray.add(const SerialMonitorTimeItem());
          serialdatawidgetarray.add(SerialMonitorItem(
              data: stringbuffer.trimRight(),
              type: "incoming",
            ),
          );

          // Log to file
          logtostorage(stringbuffer.trimRight());

          // Reset buffer
          stringbuffer = "";
        }
      });
    } catch (e) {
      // Handle errors
      print("LOGERR: $e");
    }
  }

  /*
    Disconnect the connected device
  */
  void disconnectdevice() async {
    try { reconnectiontimer.cancel(); } catch (e) {}

    try {
      disconnectionreason = "user";
      print('LOG: Disconnecting from device: ${connecteddevice.name}. Reason: $disconnectionreason');
      await connecteddevice.disconnect();
      connected.value = false;

    } catch (e) {
      print('LOG: Error disconnecting from device: $e');
    }
  }

  /*
    Check if a device is connected
  */
  bool isconnected () {
    return connected.value;
  }

  /*
    Disconnect from all connected devices
  */
  void disconnectalldevices() async {

    try { reconnectiontimer.cancel(); } catch (e) {}

    try {
      List<BluetoothDevice> connectedDevices = await ble.connectedDevices;
      
      // Disconnect from each connected device
      for (BluetoothDevice device in connectedDevices) {
        await device.disconnect();
      }
    }
    catch (e) {}
  }

  Stream<List<ScanResult>> get ScanResults => ble.scanResults;

  /*
    Get the count of nearby devices
  */
  Future<int> getFoundDevicesCount() async {
    int count =  0;
    await for (var result in ScanResults) {
      count += 1;
      statusText.value = "Found $count devices.";
      status.value = "ready";
    }
    
    return count;
  }

  // Write data to the characteristic
  Future<void> senddata(String data) async {
    try {
      await targetcharacteristic?.write(utf8.encode(data));
    }
    catch (e) {
      print("LOGERR: $e");
    }
    return;
  }
}
