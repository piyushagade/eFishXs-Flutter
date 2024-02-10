import 'package:flutter/material.dart';

void main() {
    runApp(MaterialApp(
        home: HomePageWidget(),
        theme: ThemeData(
            primarySwatch: Colors.grey
        ),
    ));
}

class HomePageWidget extends StatelessWidget {
    const HomePageWidget({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("eFishXs"),                
            ),
            body: Container(
                child: Text("Hello, world!"))
        );
    }
}