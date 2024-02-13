import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ButtonWidget extends StatefulWidget {
  void Function()? onTap;
  String label = "Unlabled";
  IconData icon = Icons.refresh;
  ButtonWidget({super.key, required this.label, required this.icon, required this.onTap});

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  bool changebutton = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

        setState(() {
          changebutton = true;
        });
        widget.onTap!();
        HapticFeedback.mediumImpact();
      },
      child: Opacity(
        opacity: 1,
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surface, // Set background color to blue
            borderRadius: BorderRadius.circular(2), // Set rounded corners
          ),
          padding: const EdgeInsets.symmetric(
              vertical: 4, horizontal: 12), // Add padding for spacing
          child: Row(
            mainAxisSize:
                MainAxisSize.min, // Allow the row to occupy minimum space
            children: [
              Icon(widget.icon,
                  color: Theme.of(context)
                      .colorScheme
                      .inversePrimary), // Refresh icon
              const SizedBox(width: 8), // Add some space between icon and label
              Text(
                widget.label,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 16), // Set label text style
              ),
            ],
          ),
        ),
      ),
    );
  }
}
