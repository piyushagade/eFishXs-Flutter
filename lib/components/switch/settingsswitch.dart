import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingsSwitchItem extends StatefulWidget {
  final String label, description;
  final bool value;
  final onChanged;

  const SettingsSwitchItem({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.description = "",
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
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                      widget.onChanged(value);
                    });
                  },
                ),
              )
            ],
          ),

          // Description
          Visibility(
            visible: widget.description.isNotEmpty,
            child: Opacity(
              opacity: 0.6,
              child: Container(
                child: Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.inversePrimary
                  )
                )
              ),
            ),
          )
        ],
      ),
    );
  }
}
