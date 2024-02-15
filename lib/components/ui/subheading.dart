import 'package:flutter/material.dart';

class SubheadingWidget extends StatelessWidget {
  String heading = "";
  String subheading = "";
  double marginBottom = 0;

  SubheadingWidget({super.key, required this.heading, this.subheading = "", this.marginBottom = 12});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(heading,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 14,
                )),
            Visibility(
              visible: subheading.isNotEmpty,
              child: Text(subheading,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            ),
            const SizedBox(
              height: 2,
            ),
      
            SizedBox(height: marginBottom,),
          ],
        ),
      ),
    );
  }
}
