import 'package:efishxs/components/heading.dart';
import 'package:efishxs/theme/themeprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    print("Showing settings");

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          
          HeadingWidget(heading: "Preferences", subheading: "Customize your experience and app configurations."),

          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(5)
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  
                Text(
                  "Dark mode",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context, listen: false).isdarkmode, 
                  onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggletheme(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}