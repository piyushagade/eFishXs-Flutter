import 'package:flutter/material.dart';

class HeadingWidget extends StatelessWidget {
  String heading = "";
  String subheading = "";
  double marginBottom = 0;

  HeadingWidget({super.key, required this.heading, required this.subheading, this.marginBottom = 12});

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
          Opacity(
            opacity: 0.8,
            child: Text(subheading,
                textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Divider(
              height: 8,
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),
          SizedBox(height: marginBottom,),
        ],
      ),
    );
  }
}
