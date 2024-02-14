import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SerialMonitorItem extends StatelessWidget {
  final String data;
  final String type;
  const SerialMonitorItem({super.key, required this.data, this.type = "incoming"});

  
  @override
  Widget build(BuildContext context) {
    Color color = type == "incoming" ? const Color.fromARGB(255, 23, 167, 28) : 
        type == "outgoing" ? const Color.fromARGB(255, 180, 45, 180) : Color.fromARGB(255, 194, 169, 7);

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 2.0, 0, 0),
              child: Text(
                DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()),
                style: const TextStyle(
                  color: Color.fromARGB(255, 203, 203, 203),
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              data.trimRight(),
              style: TextStyle(
                color: color,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
  }
}