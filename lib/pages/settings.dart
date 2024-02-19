// ignore_for_file: avoid_print

import 'package:efishxs/theme/themeprovider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import '../components/switch/settingsdropdown.dart';
import '../components/switch/settingsswitch.dart';
import '../components/ui/heading.dart';
import '../components/ui/subheading.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SharedPreferences? _prefs;
  late Future<void> _prefsFuture;

  Future<bool?> requestMultiplePermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.locationAlways,
    ].request();

    return statuses[Permission.locationAlways]?.isGranted;
  }

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

    Widget body = Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
        
            Visibility(
              visible: _prefs?.getBool("settings/general/showheading") ?? true,
              child: HeadingWidget(
                heading: "Settings",
                subheading: "Customize your experience and app configurations.",
                marginBottom: 2,
              ),
            ),
        
            // General settings
            Column(
              children: [

                SubheadingWidget(heading: "General settings", subheading: "Basic application behavior and appearance settings",),

                SettingsSwitchItem(
                  label: "Page headings",
                  description: "Disabling this will free up some space.",
                  value: _prefs?.getBool("settings/general/showheading") ?? true,
                  onChanged: (bool newvalue) async {
                    await _prefs?.setBool("settings/general/showheading", newvalue);
                    setState(() {});
                  },
                ),

                SettingsSwitchItem(
                  label: "Stay awake",
                  description: "Keep your screen on while using this app.",
                  value: _prefs?.getBool("settings/general/stayawake") ?? true,
                  onChanged: (bool newvalue) async {
                    await _prefs?.setBool("settings/general/stayawake", newvalue);
                    setState(() {});

                    WidgetsFlutterBinding.ensureInitialized();
                    if (newvalue) {
                      Wakelock.enable();
                    } else {
                      Wakelock.disable();
                    }
                  },
                ),

                SettingsDropdownWidget(
                  label: "Orientation",
                  description: "Set your phone or tablet's orientation.",
                  items: const ["Auto-rotate", "Potrait", "Landscape"],
                  defaultItemIndex: _prefs?.getInt("settings/general/orientation") ?? 1,
                  onChanged: (int newvalue) async {
                    await _prefs?.setInt("settings/general/orientation", newvalue);
                    setState(() {});
                  },
                ),

                SettingsDropdownWidget(
                  label: "Theme",
                  description: "Select an app-wide theme.",
                  items: const ["Dark", "Dark Grey", "Light Grey", "Light"],
                  defaultItemIndex: _prefs?.getInt("settings/general/theme") ?? 0,
                  onChanged: (int newvalue) async {
                    await _prefs?.setInt("settings/general/theme", newvalue);
                    
                    setState(() {
                      Provider.of<ThemeProvider>(context, listen: false).settheme(["Dark", "Dark Grey", "Light Grey", "Light"][newvalue]);
                    });
                  },
                ),

                Visibility(
                  visible: false,
                  child: SettingsSwitchItem(
                    label: "Dark Mode",
                    value: _prefs?.getBool("settings/general/darkmode") ?? true,
                    onChanged: (bool newvalue) async {
                      await _prefs?.setBool("settings/general/darkmode", newvalue);
                    },
                  ),
                ),

                SettingsSwitchItem(
                  label: "In-app notifications",
                  description: "These are shown when a device connects or disconnects.",
                  value: _prefs?.getBool("settings/general/inappnotifications") ?? true,
                  onChanged: (bool newvalue) async {
                    await _prefs?.setBool("settings/general/inappnotifications", newvalue);
                  },
                ),

                SettingsDropdownWidget(
                  label: "Open in page",
                  description: "Select which page to open when this application opens.",
                  items: const ["Dashboard", "Monitor", "Settings"],
                  defaultItemIndex: _prefs?.getInt("settings/general/openinpage") ?? 0,
                  onChanged: (int newvalue) async {
                    await _prefs?.setInt("settings/general/openinpage", newvalue);
                  },
                ),
                
                const SizedBox(
                  height: 8,
                ),

              ],
            ),
        
            
            // Serial monitor settings
            Column(
              children: [

                SubheadingWidget(heading: "Serial monitor configuration", subheading: "Set the behavior of the Serial Monitor",),
                
                SettingsSwitchItem(
                  label: "Auto connect",
                  description: "This attempts a reconnection when a device disconnects abruptly.",
                  value: _prefs?.getBool("settings/serialmonitor/autoconnect") ?? true,
                  onChanged: (bool newvalue) async {
                    await _prefs?.setBool("settings/serialmonitor/autoconnect", newvalue);
                  },
                ),
                
                SettingsSwitchItem(
                  label: "Auto scroll",
                  description: "Enable auto-scroll in serial monitor for hands-off monitoring.",
                  value: _prefs?.getBool("settings/serialmonitor/autoscroll") ?? true,
                  onChanged: (bool newvalue) async {
                    await _prefs?.setBool("settings/serialmonitor/autoscroll", newvalue);
                  },
                ),
                
                SettingsSwitchItem(
                  label: "Log to file",
                  description: "Enable automatic saving every serial monitor log to a local file.",
                  value: _prefs?.getBool("settings/serialmonitor/logtofile") ?? true,
                  onChanged: (bool newvalue) async {
                    await _prefs?.setBool("settings/serialmonitor/logtofile", newvalue);
                  },
                ),

                SettingsSwitchItem(
                  label: "Enable GPS logging",
                  description: "Tag each serial monitor log with a GPS location",
                  value: _prefs?.getBool("settings/serialmonitor/gpslogging") ?? false,
                  onChanged: (bool newvalue) async {

                    LocationPermission permission = await Geolocator.checkPermission();
                    if (permission == LocationPermission.denied) {
                      permission = await Geolocator.requestPermission();
                      if (permission == LocationPermission.denied) {
                        // Permissions are denied, next time you could try
                        // requesting permissions again (this is also where
                        // Android's shouldShowRequestPermissionRationale 
                        // returned true. According to Android guidelines
                        // your App should show an explanatory UI now.
                        return Future.error('Location permissions are denied');
                      }
                    }

                    if (newvalue) {
                      requestMultiplePermissions().then((permissiongranted) {
                        try {
                          _prefs?.setBool("settings/serialmonitor/gpslogging", newvalue);
                        }
                        catch (e) {}
                      });
                    }
                    
                    else {
                      try {
                        _prefs?.setBool("settings/serialmonitor/gpslogging", newvalue);
                      }
                      catch (e) {}
                    }
                  },
                ),
        
                SettingsDropdownWidget(
                  label: "New line character",
                  description: "Select the end-of-line (EOL) character.",
                  items: const ["CRLF", "CR", "LF"],
                  defaultItemIndex: _prefs?.getInt("settings/serialmonitor/lineending") ?? 0,
                  onChanged: (int newvalue) async {
                    await _prefs?.setInt("settings/serialmonitor/lineending", newvalue);
                  },
                ),
        
                SettingsDropdownWidget(
                  label: "Timestamp",
                  description: "Select the format of the timestamp in the serial monitor.",
                  items: const ["yyyy-MM-dd hh:mm:ss", "yy-MM-dd hh:mm:ss", "MM-dd hh:mm:ss", "hh:mm:ss"],
                  defaultItemIndex: _prefs?.getInt("settings/serialmonitor/timestampformat") ?? 1,
                  onChanged: (int newvalue) async {
                    await _prefs?.setInt("settings/serialmonitor/timestampformat", newvalue);
                  },
                ),
        
                SettingsDropdownWidget(
                  label: "Font size",
                  description: "Select the font size of the text in the serial monitor.",
                  items: const ["Atomic", "Microscopic", "Tiny", "Small", "Medium", "Large", "Huge", "Gigantic"],
                  defaultItemIndex: _prefs?.getInt("settings/serialmonitor/fontsize") ?? 3,
                  onChanged: (int newvalue) async {
                    await _prefs?.setInt("settings/serialmonitor/fontsize", newvalue);
                  },
                ),
                
                const SizedBox(
                  height: 8,
                ),
                
              ],
            ),
          ],
        ),
      ),
    );

    return FutureBuilder<void>(
      future: _prefsFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading indicator while waiting for _prefs to be initialized
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