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
        
            HeadingWidget(heading: "Settings", subheading: "Customize your experience and app configurations.", marginBottom: 2,),
        
            // General settings
            Column(
              children: [

                SubheadingWidget(heading: "General settings", subheading: "Basic application behavior and appearance settings",),
                
                SettingsDropdownWidget(label: "Orientation",
                  items: const ["Auto-rotate", "Potrait", "Landscape"],
                  defaultItemIndex: _prefs?.getInt("settings/general/orientation") ?? 1,
                  onChanged: (int newvalue) async {
                    await _prefs?.setInt("settings/general/orientation", newvalue);
                  },
                ),

                SettingsSwitchItem(
                  label: "Dark Mode",
                  value: _prefs?.getBool("settings/general/darkmode") ?? true,
                  onChanged: (bool newvalue) async {
                    await _prefs?.setBool("settings/general/darkmode", newvalue);
                  },
                ),
                SettingsDropdownWidget(
                  label: "Open in page",
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
                  value: _prefs?.getBool("settings/serialmonitor/autoconnect") ?? true,
                  onChanged: (bool newvalue) async {
                    await _prefs?.setBool("settings/serialmonitor/autoconnect", newvalue);
                  },
                ),
        
                SettingsDropdownWidget(
                  label: "New line character",
                  items: const ["CRLF", "CR", "LF"],
                  defaultItemIndex: _prefs?.getInt("settings/serialmonitor/lineending") ?? 0,
                  onChanged: (int newvalue) async {
                    await _prefs?.setInt("settings/serialmonitor/lineending", newvalue);
                  },
                ),
        
                SettingsDropdownWidget(
                  label: "Time",
                  items: const ["yyyy-MM-dd hh:mm:ss", "yy-MM-dd hh:mm:ss", "MM-dd hh:mm:ss", "hh:mm:ss"],
                  defaultItemIndex: _prefs?.getInt("settings/serialmonitor/timestampformat") ?? 1,
                  onChanged: (int newvalue) async {
                    await _prefs?.setInt("settings/serialmonitor/timestampformat", newvalue);
                  },
                ),
        
                SettingsDropdownWidget(
                  label: "Font size",
                  items: const ["Atomic", "Microscopic", "Tiny", "Small", "Medium", "Large", "Huge", "Gigantic"],
                  defaultItemIndex: _prefs?.getInt("settings/serialmonitor/fontsize") ?? 4,
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