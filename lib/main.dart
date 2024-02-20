// ignore_for_file: avoid_print

import 'package:efishxs/controllers/ble.dart';
import 'package:efishxs/theme/themeprovider.dart';
import 'package:efishxs/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:efishxs/pages/intro.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider())
      ],
      child: const App()
  ));
}

class App extends StatefulWidget {
    const App({super.key});

    @override
    State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  @override
  void initState() {
    super.initState();
    print("LOG: Loading MaterialApp app.");
    
    // Initialize BLE controller
    Get.put(BLEController());
  }

  @override
  Widget build(BuildContext context) {
    print("LOG: Rebuilding MaterialApp widget.");

    return OverlaySupport.global(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: IntroPage(),
        theme: Provider.of<ThemeProvider>(context, listen: true).themeData,
      ),
    );
  }
}
