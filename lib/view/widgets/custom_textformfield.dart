// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '/constants.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField(
    {
      super.key,
      this.label = "label name",
      this.icon,
      this.validator,
      this.controller,
      this.inputFormat,
      this.inputType,
      this.trailing,
      this.isVisible = false,
      this.hintText = ''
    }
  );

  final String label;
  final IconData? icon;

  // Controller | to take the value from user in text field
  final TextEditingController? controller;

  //Validator | Check the value whether it's validated or not
  final FormFieldValidator? validator;

  // Text Input Formatter | Allows or denies specific data format
  final List<TextInputFormatter>? inputFormat;

  //Text Input Type | Used to show specific keyboard layout to users
  final TextInputType? inputType;
  final Widget? trailing;
  final bool isVisible;
  final hintText;

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isVisible;
  }

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: widget.validator,
        controller: widget.controller,
        inputFormatters: widget.inputFormat,
        keyboardType: widget.inputType,
        style: const TextStyle(color: Colors.black87, fontSize: 14),
        //Automatically validates without pressing the button
        autovalidateMode: AutovalidateMode.onUserInteraction,

        // ObscureText | Shows or hides text field's value to users
        obscureText: _isObscured,

        decoration: InputDecoration(

          //label: Text(widget.label),
          hintText: widget.hintText,
          //prefixIcon: Icon(widget.icon),
          //suffixIcon: widget.trailing,

          

          //enabledBorder | Default Text field decoration
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 1
            ),
          ),

          // FocusedBorder | OnClick decoration
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
                color: COLOR_PRIMARY,
                width: 1.5
            ),
          ),

          //errorBorder | Default error decoration border
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
                color: Colors.red.shade900,
                width: 1
            ),
          ),

          //focusedErrorBorder | onClick decoration border
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
                color: Colors.red.shade900,
                width: 2
            ),
          ),

          suffixIcon: widget.isVisible
            ? IconButton(
                icon: Icon(_isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: _toggleVisibility,
              )
            : null,
        ),
    );
  }
  
}