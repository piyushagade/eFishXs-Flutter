import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingsSwitchItem extends StatefulWidget {
  final String label;
  final bool value;

  const SettingsSwitchItem({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  _SettingsSwitchItemState createState() => _SettingsSwitchItemState();
}

class _SettingsSwitchItemState extends State<SettingsSwitchItem> {
  late bool _switchValue;

  @override
  void initState() {
    super.initState();
    _switchValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(5)
      ),
      margin: const EdgeInsets.only(left:  25, right:  25, top:  10),
      padding: const EdgeInsets.symmetric(vertical:  6, horizontal:  12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          Transform.scale(
            scale:  0.8,
            child: CupertinoSwitch(
              value: _switchValue,
              activeColor: Colors.green,
              trackColor: Colors.grey.shade700,
              onChanged: (value) {
                setState(() {
                  _switchValue = value;
                  print("LOG: Switch toggled: $_switchValue");
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
