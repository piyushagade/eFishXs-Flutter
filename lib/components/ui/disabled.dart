import 'package:flutter/material.dart';

class DisabledWidget extends StatelessWidget {
  final Widget child;
  final bool disabled;
  const DisabledWidget({Key? key, required this.child, required this.disabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
  double opacity = disabled ? 0.4 : 1;
  bool ignore = disabled;

    return IgnorePointer(
      ignoring: ignore,
      child: Opacity(
        opacity: opacity,
        child: child,
      ),
    );
  }
}