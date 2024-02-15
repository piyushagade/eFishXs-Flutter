import "package:flutter/material.dart";

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
            children: <Widget>[
                DrawerHeader(
                    decoration: BoxDecoration(
                        color: Colors.blueGrey.shade100
                    ),
                    child: const Text("eFish-Xs new application"),
                ),
                const ListTile(
                    leading: Icon(Icons.email),
                    title: Text("Email"),
                    subtitle: Text("piyushagade@gmail.com"),
                )
            ],
        ),
    );
  }
}