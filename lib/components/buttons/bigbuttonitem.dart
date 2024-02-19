import 'package:flutter/material.dart';

class BigButtonItem extends StatelessWidget {
  final String label;
  final IconData icon;
  const BigButtonItem(
      {super.key, required this.label, this.icon = Icons.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      constraints: const BoxConstraints(maxWidth: 5, maxHeight: 5),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(2)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
