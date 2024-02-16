import 'package:efishxs/globals/strings.dart';
import 'package:efishxs/pages/devices.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DevicesPage()),
      );
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("assets/images/cereal.png", height: 150),
              ),

              const SizedBox(height: 40),

              Text("Initializing application",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.inversePrimary
                )
              ),

              const SizedBox(height: 2),

              Text("Loading configuration",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.primary
                )
              )
          ],
        ),
      )
    );
  }
}