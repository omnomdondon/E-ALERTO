import 'package:e_alerto/constants.dart';
import 'package:flutter/material.dart';

class CustomRadiobutton extends StatefulWidget {
  final Function(int) onChanged; // Callback function

  const CustomRadiobutton({super.key, required this.onChanged});

  @override
  _CustomRadioButtonState createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadiobutton> {
  int? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(7, (index) {
            return Column(
              children: [
                Radio<int>(
                  value: index + 1,
                  groupValue: selectedValue,
                  onChanged: (int? value) {
                    setState(() {
                      selectedValue = value;
                    });
                    widget.onChanged(value!); // Pass selected value to parent
                  },
                  activeColor: COLOR_PRIMARY, // Change as needed
                ),
                Text(
                  '${index + 1}', // Numbers below each radio button
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
