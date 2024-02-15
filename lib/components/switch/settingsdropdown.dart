import 'package:flutter/material.dart';

class SettingsDropdownWidget extends StatefulWidget {
  final label;
  final List<String> items;
  final ValueChanged<int> onChanged;
  final int defaultItemIndex;

  const SettingsDropdownWidget({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.defaultItemIndex = 0,
  });

  @override
  _SettingsDropdownWidgetState createState() => _SettingsDropdownWidgetState();
}

class _SettingsDropdownWidgetState extends State<SettingsDropdownWidget> {
  String? _selectedItem;
  int? _selectedItemIndex;

  @override
  void initState() {
    super.initState();

    // Initialize _selectedItem with the default value here
    _selectedItemIndex = widget.defaultItemIndex;
    _selectedItem = widget.items[widget.defaultItemIndex];
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
            scale:  0.9,
            child: DropdownButton<String>(
              hint: const Text('Please select'),
              value: _selectedItem,
              items: widget.items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                    child: Center(
                      child: Text(value),
                    ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedItem = newValue;
                  _selectedItemIndex = widget.items.indexOf(newValue!);
                  widget.onChanged(_selectedItemIndex!);
                });
              },
            )
          )
        ],
      ),
    );
  }
}
