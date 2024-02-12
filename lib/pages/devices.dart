import 'package:efishxs/controllers/ble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({Key? key}) : super(key: key);

  @override
  State<DevicesPage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicesPage> {
  late BLEController controller;

  @override
  void initState() {
    super.initState();
    controller = BLEController();

    // Start scanning for devices
    controller.scandevices();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leadingWidth: MediaQuery.of(context).size.width, // Set leadingWidth to full width
        leading: Center(
          child: Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/a/ab/Apple-logo.png', // Replace with your image URL
            width: 40, // Adjust the width as needed
            height: 40, // Adjust the height as needed
            fit: BoxFit.cover, // Adjust the fit as needed
          ),
        ),
      ),
      body: GetBuilder<BLEController>(
        init: controller,
        builder: (BLEController controller) {
          int devicecount = 0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Bluetooth devices",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        
                      )
                    ),
                    Text(
                      "Please connect to you eFish-Xs device in the list below.",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600]
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(
                        color: Colors.grey[350],
                        height: 2,
                      ),
                    ),
                  ],
                ),
              ),

              GestureDetector(
                onTap: () {
                  // Handle button tap
                  controller.scandevices();
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surface, // Set background color to blue
                      borderRadius:
                          BorderRadius.circular(8), // Set rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: 12), // Add padding for spacing
                    child: Row(
                      mainAxisSize: MainAxisSize
                          .min, // Allow the row to occupy minimum space
                      children: [
                        Icon(Icons.refresh,
                            color: Theme.of(context)
                                .colorScheme
                                .inversePrimary), // Refresh icon
                        const SizedBox(
                            width: 8), // Add some space between icon and label
                        Text(
                          "Refresh",
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontSize: 16), // Set label text style
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              GestureDetector(
                onTap: () {
                  // Handle button tap
                  controller.disconnectdevice();
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surface, // Set background color to blue
                      borderRadius:
                          BorderRadius.circular(8), // Set rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: 12), // Add padding for spacing
                    child: Row(
                      mainAxisSize: MainAxisSize
                          .min, // Allow the row to occupy minimum space
                      children: [
                        Icon(Icons.bluetooth_disabled,
                            color: Theme.of(context)
                                .colorScheme
                                .inversePrimary), // Refresh icon
                        const SizedBox(
                            width: 8), // Add some space between icon and label
                        Text(
                          "Disconnect",
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontSize: 16), // Set label text style
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              Expanded(
                child: Center(
                  child: StreamBuilder<List<ScanResult>>(
                    stream: controller.ScanResults,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        devicecount = snapshot.data!.length;
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final data = snapshot.data![index];
                            String deviceName = data.device.name.isNotEmpty
                                ? data.device.name
                                : 'Unknown Device'; // Handle null device name

                            if (data.device.name != 'Unknown Device') {
                              String deviceId = data.device.id.id;
                              BluetoothDeviceType deviceTypeEnum = data.device.type;
                              String deviceType = "unknown";
                              if (deviceTypeEnum == BluetoothDeviceType.unknown) {
                                deviceType = "unknown";
                              }
                              else if (deviceTypeEnum == BluetoothDeviceType.classic) {
                                deviceType = "classic";
                              }
                              else if (deviceTypeEnum == BluetoothDeviceType.le) {
                                deviceType = "le";
                              }
                              else if (deviceTypeEnum == BluetoothDeviceType.dual) {
                                deviceType = "dual";
                              }

                              return GestureDetector(
                              onTap: () {

                                showModalBottomSheet(
                                  elevation: 10,
                                  backgroundColor: Theme.of(context).colorScheme.surface,
                                  shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10), // Set the top border radius
                                  ),
                                ),
                                  context: context,
                                  builder: (context) => Container(
                                    height: 210,
                                    color: Colors.transparent,
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                      
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Confirm connection",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 20,
                                              
                                            )
                                          ),
                                          Text(
                                            "Are you certain you wish to connect to the following device?",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]
                                            )
                                          ),
                                          const SizedBox(height: 6,),
                                          Text(
                                            deviceName,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[800]
                                            )
                                          ),
                                          Text(
                                            deviceId,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600]
                                            )
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Divider(
                                              color: Colors.grey[350],
                                              height: 2,
                                            ),
                                          ),
                                      
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                                (Set<MaterialState> states) {
                                                  if (states.contains(MaterialState.pressed)) {
                                                    // Return the color when the button is pressed
                                                    return Theme.of(context).colorScheme.inversePrimary;
                                                  }
                                                  // Return the default color
                                                  return Theme.of(context).colorScheme.inversePrimary;
                                                },
                                              ),
                                            ),
                                            child: Text(
                                              'Connect',
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.primary
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                // Connect to the device
                                                controller.connectdevice(context, data.device);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                );
                              },
                              child: Card(
                                elevation: 0,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.bluetooth),
                                      title: Text(deviceName),
                                      subtitle: Text("$deviceType/$deviceId",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              fontSize: 14)),
                                    ),
                                  ],
                                ),
                              ),
                            );
                            }
                          },
                        );
                      } else {
                        return const Center(child: Text("No devices nearby."));
                      }
                    },
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
