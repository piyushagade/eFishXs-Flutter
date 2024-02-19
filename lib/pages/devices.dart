import 'package:efishxs/components/buttons/button.dart';
import 'package:efishxs/components/ui/disabled.dart';
import 'package:efishxs/components/ui/heading.dart';
import 'package:efishxs/controllers/ble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> with SingleTickerProviderStateMixin {
  int devicecount = 0;

  late AnimationController _controller;
  late BLEController controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    print("LOG: Instantiating BLEController.");
    
    final controller = Get.put(BLEController(
      onDisconnect: () {},
    ));

    // Disconnect from any previosuly connected devices
    controller.disconnectalldevices();

    // Start scanning for devices
    controller.scandevices();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leadingWidth:
            MediaQuery.of(context).size.width, // Set leadingWidth to full width
        leading: Center(
          child: Image.asset("assets/images/cereal.png", height: 40),
        ),
      ),
      body: GetBuilder<BLEController>(
        init: controller,
        builder: (BLEController controller) {

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingWidget(heading: "Bluetooth devices", subheading: "Please connect to you eFish-Xs device in the list below."),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 16),
                  Obx(() => DisabledWidget(
                      disabled: controller.isScanning.value,
                      child: ButtonWidget(
                          label: "Refresh",
                          icon: Icons.refresh,
                          onTap: () {
                            // Handle button tap
                            controller.scandevices();
                          }),
                    ),
                  ),
                  const SizedBox(
                      width: 16), // Add horizontal spacing between buttons
                  Obx(() => DisabledWidget(
                      disabled: controller.isScanning.value,
                      child: ButtonWidget(
                          label: "Disconnect all",
                          icon: Icons.bluetooth_disabled,
                          onTap: () {
                            // Handle button tap
                            controller.disconnectalldevices();
                          }),
                    ),
                  ),

                  const SizedBox(width: 16),
                ],
              ),
              const SizedBox(height: 8),

              // Status
              Obx(
                () => Wrap(
                  direction: Axis.vertical,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(2)
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      margin:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Visibility(
                                visible: controller.status.value == "busy"
                                    ? true
                                    : false,
                                child: Transform.scale(
                                  scale: 0.8,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: RotationTransition(
                                      turns: _controller,
                                      child: const Icon(Icons.workspaces_filled),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: controller.status.value == "ready"
                                    ? true
                                    : false,
                                child: Transform.scale(
                                  scale: 0.8,
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(Icons.devices),
                                  ),
                                ),
                              ),
                              Text(controller.statusText.value),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Obx(() => Visibility(
                  visible: !controller.isAvailable.value,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 73, 29, 20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: const Column (
                      children: [
                        Text("The device does not support Bluetooth."),
                      ],
                    ),
                  ),
                ),
              ),

              Obx(() => Visibility(
                  visible: controller.isAvailable.value && !controller.isOn.value,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 122, 42, 26),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: const Column (
                      children: [
                        Text("Bluetooth is turned off"),
                      ],
                    ),
                  ),
                ),
              ),

              // Device list
              Obx(() => Visibility(
                  visible: controller.isAvailable.value && controller.isOn.value,
                  child: Expanded(
                    child: DisabledWidget(
                      disabled: controller.isConnecting.value,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.inverseSurface,
                            borderRadius: BorderRadius.circular(2)
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          child: StreamBuilder<List<ScanResult>>(
                            stream: controller.ScanResults,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                devicecount = snapshot.data!.length;
                                return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    final data = snapshot.data![index];
                                    String deviceName = data.device.name != ""
                                        ? data.device.name
                                        : 'Unknown Device'; // Handle null device name
                                    String deviceRssi = data.rssi.toString();

                                    if (data.device.name != "") {
                                      String deviceId = data.device.id.id;
                                      BluetoothDeviceType deviceTypeEnum =
                                          data.device.type;
                                      String deviceType = "unknown";
                                      if (deviceTypeEnum ==
                                          BluetoothDeviceType.unknown) {
                                        deviceType = "Unknown";
                                      } else if (deviceTypeEnum ==
                                          BluetoothDeviceType.classic) {
                                        deviceType = "Classic";
                                      } else if (deviceTypeEnum ==
                                          BluetoothDeviceType.le) {
                                        deviceType = "LE";
                                      } else if (deviceTypeEnum ==
                                          BluetoothDeviceType.dual) {
                                        deviceType = "Dual";
                                      }
                                        
                                      return GestureDetector(
                                        onTap: () {
                                          try {
                                            controller.activesnackbar.close();
                                          } catch (e) {}

                                          showModalBottomSheet(
                                              elevation: 0,
                                              backgroundColor:
                                                  Colors.transparent,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(
                                                      2), // Set the top border radius
                                                ),
                                              ),
                                              context: context,
                                              builder: (context) => Container(
                                                    height: 185,
                                                    margin:
                                                        const EdgeInsets.all(
                                                            10),
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              195,
                                                              195,
                                                              195),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Opacity(
                                                            opacity: 1,
                                                            child: Text(
                                                              "Are you certain you wish to connect to this device?",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            deviceName,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary,
                                                            ),
                                                          ),
                                                          Opacity(
                                                            opacity: 0.4,
                                                            child: Text(
                                                              deviceId,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 6,
                                                          ),
                                                          ElevatedButton(
                                                            style: ButtonStyle(
                                                              shape: MaterialStateProperty
                                                                  .all<
                                                                      RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              2.0), // Set the border radius here
                                                                ),
                                                              ),
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .resolveWith<
                                                                          Color>(
                                                                (Set<MaterialState>
                                                                    states) {
                                                                  if (states.contains(
                                                                      MaterialState
                                                                          .pressed)) {
                                                                    // Return the color when the button is pressed
                                                                    return Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary;
                                                                  }
                                                                  // Return the default color
                                                                  return Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary;
                                                                },
                                                              ),
                                                            ),
                                                            child: Text(
                                                              "Connect",
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .inversePrimary),
                                                            ),
                                                            onPressed: () {
                                                              // Hide bottom sheet
                                                              Navigator.pop(
                                                                  context);

                                                              // Connect to the device
                                                              controller
                                                                  .connectdevice(
                                                                      context,
                                                                      data.device);
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(2.0), // Set the border radius here
                                          ),
                                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                leading: const Icon(Icons.bluetooth),
                                                title: Text(deviceName),
                                                subtitle: Row(
                                                  children: [
                                                    Opacity(
                                                      opacity: 0.4,
                                                      child: Text(deviceId,
                                                          style: TextStyle(
                                                              color: Theme.of(context)
                                                                  .colorScheme
                                                                  .inversePrimary,
                                                              fontSize: 14)),
                                                    ),
                                                    const Spacer(),
                                                    Opacity(
                                                      opacity: 0.8,
                                                      child: Text("$deviceRssi dB",
                                                        style: const TextStyle(
                                                          color: Color.fromARGB(255, 63, 255, 185),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Opacity(
                                                      opacity: 0.8,
                                                      child: Text(deviceType,
                                                        style: const TextStyle(
                                                          color: Color.fromARGB(255, 82, 175, 251),
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                );
                              } else {
                                return const Center(child: Text("No devices nearby."));
                              }
                            },
                          ),
                        ),
                      ),
                    ),
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
