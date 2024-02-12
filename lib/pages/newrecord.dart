import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewRecordPage extends StatelessWidget {
  const NewRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Add record",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  
                )
              ),
              Text(
                "Enter the field measurements to add a new data record.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600]
                )
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  color: Colors.grey[350],
                  height: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.number, // Only allow numeric input
                  inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly, // Enforce numeric input
                  ],
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.balance_outlined),
                    hintText: "Enter weight",
                    
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
                    ),
                    focusedBorder:OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
                    ),
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}