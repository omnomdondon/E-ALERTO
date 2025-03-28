import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final String hint;
  final ValueChanged<String>? onChanged;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.hint,
    this.onChanged,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedItem,
          hint: Text(widget.hint, style: const TextStyle(color: Colors.black87, fontSize: 14)),
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade400,),
          isExpanded: true, // Makes the dropdown fill the width
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
          dropdownColor: Colors.white, // Background color of dropdown items
          borderRadius: BorderRadius.circular(10),
          items: widget.items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedItem = newValue;
            });
            if (widget.onChanged != null) {
              widget.onChanged!(newValue!);
            }
          },
        ),
      ),
    );
  }
}
