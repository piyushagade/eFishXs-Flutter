import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  void Function()? onTap;
  String label = "Unlabled";
  IconData icon = Icons.refresh;
  ButtonWidget({super.key, required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap!();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surface, // Set background color to blue
          borderRadius: BorderRadius.circular(8), // Set rounded corners
        ),
        padding: const EdgeInsets.symmetric(
            vertical: 4, horizontal: 12), // Add padding for spacing
        child: Row(
          mainAxisSize:
              MainAxisSize.min, // Allow the row to occupy minimum space
          children: [
            Icon(icon,
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary), // Refresh icon
            const SizedBox(width: 8), // Add some space between icon and label
            Text(
              label,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 16), // Set label text style
            ),
          ],
        ),
      ),
    );
  }
}
