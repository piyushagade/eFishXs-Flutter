import 'package:flutter/material.dart';

class SettingsDropdownWidget extends StatefulWidget {
  final String label, description;
  final List<String> items;
  final ValueChanged<int> onChanged;
  final int defaultItemIndex;

  const SettingsDropdownWidget({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.description = "",
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
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(5)
      ),
      margin: const EdgeInsets.only(left:  25, right:  25, top:  10),
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
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
                scale:  0.9,
                child: DropdownButton<String>(
                  hint: const Text('Please select'),
                  value: _selectedItem,
                  items: widget.items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                        child: Text(
                          value,
                          textAlign: TextAlign.center,
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
