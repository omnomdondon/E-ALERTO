import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/constants.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.label = "label name",
    this.icon,
    this.validator,
    this.controller,
    this.inputFormat,
    this.inputType,
    this.suffixIcon,
    this.obscureText = false,
    this.hintText = '',
    this.focusNode,
  });

  final String label;
  final IconData? icon;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final List<TextInputFormatter>? inputFormat;
  final TextInputType? inputType;
  final Widget? suffixIcon;
  final bool obscureText;
  final String hintText;
  final FocusNode? focusNode;

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      validator: widget.validator,
      controller: widget.controller,
      inputFormatters: widget.inputFormat,
      keyboardType: widget.inputType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(fontSize: ScreenUtil().setSp(14)),
        suffixIcon: widget.suffixIcon,
        contentPadding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(12),
          horizontal: ScreenUtil().setWidth(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
          borderSide: BorderSide(
              color: Colors.grey.withOpacity(.3),
              width: ScreenUtil().setSp(1.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
          borderSide:
              BorderSide(color: COLOR_PRIMARY, width: ScreenUtil().setSp(1.5)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
          borderSide: BorderSide(
              color: Colors.red.shade900, width: ScreenUtil().setSp(1)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(ScreenUtil().radius(8)),
          borderSide: BorderSide(
              color: Colors.red.shade900, width: ScreenUtil().setSp(2)),
        ),
      ),
    );
  }
}



// import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';
// import '/constants.dart';

// class CustomTextFormField extends StatefulWidget {
//   const CustomTextFormField({
//     super.key,
//     this.label = "label name",
//     this.icon,
//     this.validator,
//     this.controller,
//     this.inputFormat,
//     this.inputType,
//     this.suffixIcon,
//     this.obscureText = false,
//     this.hintText = '',
//   });

//   final String label;
//   final IconData? icon;
//   final TextEditingController? controller;
//   final FormFieldValidator? validator;
//   final List<TextInputFormatter>? inputFormat;
//   final TextInputType? inputType;
//   final Widget? suffixIcon;
//   final bool obscureText;
//   final String hintText;

//   @override
//   _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
// }

// class _CustomTextFormFieldState extends State<CustomTextFormField> {
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       validator: widget.validator,
//       controller: widget.controller,
//       inputFormatters: widget.inputFormat,
//       keyboardType: widget.inputType,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       obscureText: widget.obscureText,
//       decoration: InputDecoration(
//         hintText: widget.hintText,
//         suffixIcon: widget.suffixIcon,
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide:
//               BorderSide(color: Colors.grey.withOpacity(.3), width: 1.5),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: COLOR_PRIMARY, width: 1.5),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: Colors.red.shade900, width: 1),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(color: Colors.red.shade900, width: 2),
//         ),
//       ),
//     );
//   }
// }
