import 'package:efishxs/components/switch/settingsdropdown.dart';
import 'package:efishxs/components/switch/settingsswitch.dart';
import 'package:efishxs/components/ui/heading.dart';
import 'package:efishxs/components/ui/subheading.dart';
import 'package:efishxs/theme/themeprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
        
            HeadingWidget(heading: "Preferences", subheading: "Customize your experience and app configurations.", marginBottom: 2,),
        
            // General settings
            Column(
              children: [

                SubheadingWidget(heading: "General settings", subheading: "Basic application behavior and appearance settings",),
                
                const SettingsSwitchItem(label: "Orientation", value: true, ),
                SettingsDropdownWidget(label: "Open in page",
                  items: const ["Auto-rotate", "Potrait", "Landscape"],
                  defaultItem: 1,
                  onChanged: (String newvalue) {
                    print("LOG: New value: " + newvalue);
                  },
                ),

                const SettingsSwitchItem(label: "Dark Mode", value: true, ),
                SettingsDropdownWidget(label: "Open in page", items: const ["Dashboard", "Monitor", "Settings"], onChanged: (String newvalue) {
                  print ("LOG: New value: " + newvalue);
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
                
                const SettingsSwitchItem(label: "Auto connect", value: true, ),
        
                SettingsDropdownWidget(
                  label: "New line character",
                  items: const ["CRLF", "CR", "LF"],
                  onChanged: (String newvalue) {
                    print ("LOG: New value: " + newvalue);
                  },
                ),
        
                SettingsDropdownWidget(
                  label: "Time",
                  items: const ["yyyy-MM-dd hh:mm:ss", "yy-MM-dd hh:mm:ss", "MM-dd hh:mm:ss", "hh:mm:ss"],
                  defaultItem: 0,
                  onChanged: (String newvalue) {
                    print ("LOG: New value: " + newvalue);
                  },
                ),
        
                SettingsDropdownWidget(
                  label: "Font size",
                  items: const ["Atomic", "Microscopic", "Tiny", "Small", "Medium", "Large", "Huge", "Gigantic"],
                  defaultItem: 3,
                  onChanged: (String newvalue) {
                    print ("LOG: New value: " + newvalue);
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
  }
}