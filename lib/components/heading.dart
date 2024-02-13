import 'package:flutter/material.dart';

class HeadingWidget extends StatelessWidget {
  String heading = "";
  String subheading = "";

  HeadingWidget({super.key, required this.heading, required this.subheading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 20,
              )),
          Text(subheading,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(
            height: 6,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Divider(
              height: 8,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          SizedBox(height: 12,),
        ],
      ),
    );
  }
}
