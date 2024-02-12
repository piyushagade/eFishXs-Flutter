import 'package:efishxs/theme/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:efishxs/pages/intro.dart';

void main() {
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
    Widget build(BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            showPerformanceOverlay: false,                        
            home: const IntroPage(),
            theme: Provider.of<ThemeProvider>(context).themeData
        );
    }
}