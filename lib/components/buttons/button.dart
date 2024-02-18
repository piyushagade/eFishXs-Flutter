import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  void Function()? onTap;
  String label = "Unlabled";
  IconData icon = Icons.refresh;
  Color backgroundColor;
  Color color;
  EdgeInsets padding;
  double scale;
  
  ButtonWidget(
    {super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.backgroundColor = const Color.fromARGB(255, 241, 241, 241),
    this.color = const Color.fromARGB(255, 62, 62, 62),
    this.padding = const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
    this.scale = 1,
  });

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
      },
      child: Opacity(
        opacity: 1,
        child: Transform.scale(
          scale: widget.scale,
          child: AnimatedContainer(
            duration: const Duration(seconds: 1),
            decoration: BoxDecoration(
              color: widget.backgroundColor, // Set background color to blue
              borderRadius: BorderRadius.circular(2), // Set rounded corners
            ),
            padding: widget.padding, // Add padding for spacing
            child: Row(
              mainAxisSize: MainAxisSize.min, // Allow the row to occupy minimum space
              children: [
                Icon(widget.icon,
                  color: widget.color,
                ), // Refresh icon
                SizedBox(width: widget.label.isNotEmpty ? 4 : 0), // Add some space between icon and label
                Text(
                  widget.label,
                  style: TextStyle(
                      color: widget.color,
                      fontSize: 16,
                    ), // Set label text style
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
