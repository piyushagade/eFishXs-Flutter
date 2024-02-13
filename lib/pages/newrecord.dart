import 'package:efishxs/components/heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewRecordPage extends StatelessWidget {
  const NewRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeadingWidget(heading: "Add record", subheading: "Enter the field measurements to add a new data record."),
            
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(5)
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
              
              child: TextField(
                keyboardType: TextInputType.number, // Only allow numeric input
                inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Enforce numeric input
                ],
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.balance_outlined),
                  hintText: "Enter weight",
                  
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent, width: 0.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}