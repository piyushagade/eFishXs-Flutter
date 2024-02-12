import 'package:efishxs/pages/devices.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DevicesPage()),
      );
    });

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset("assets/images/logo.png", height: 150),
              ),

              const SizedBox(height: 40),

              const Text("Initializing application",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black
                )
              ),

              const SizedBox(height: 2),

              const Text("Loading devices",
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 13,
                  color: Colors.grey
                )
              )
          ],
        ),
      )
    );
  }
}