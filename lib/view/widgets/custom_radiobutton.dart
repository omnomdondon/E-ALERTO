import 'package:e_alerto/constants.dart';
import 'package:flutter/material.dart';

class CustomRadiobutton extends StatefulWidget {
  final Function(int) onChanged;

  const CustomRadiobutton({super.key, required this.onChanged});

  @override
  _CustomRadioButtonState createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadiobutton> {
  int? selectedValue;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          child: Wrap(
            spacing: 0, // No horizontal spacing between items
            runSpacing: 8.0, // Vertical spacing between rows
            alignment: WrapAlignment.spaceBetween, // Distribute space evenly
            children: List.generate(7, (index) {
              return SizedBox(
                width: constraints.maxWidth / 7, // Equal width for each item
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<int>(
                      value: index + 1,
                      groupValue: selectedValue,
                      onChanged: (int? value) {
                        setState(() {
                          selectedValue = value;
                        });
                        widget.onChanged(value!);
                      },
                      activeColor: COLOR_PRIMARY,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
