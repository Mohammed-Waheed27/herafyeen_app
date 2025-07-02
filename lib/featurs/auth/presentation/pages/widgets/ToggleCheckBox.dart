import 'package:flutter/material.dart';

class ToggleCheckBox extends StatefulWidget {
  const ToggleCheckBox({Key? key}) : super(key: key);

  @override
  State<ToggleCheckBox> createState() => _ToggleCheckBoxState();
}

class _ToggleCheckBoxState extends State<ToggleCheckBox> {
  bool _isChecked = false; // initial state

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Toggle the check state on press
        setState(() {
          _isChecked = !_isChecked;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: _isChecked,
            onChanged: (bool? newValue) {
              // You can also toggle inside onChanged
              setState(() {
                _isChecked = newValue ?? false;
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
