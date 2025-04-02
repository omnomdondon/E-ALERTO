import 'package:e_alerto/constants.dart';
import 'package:e_alerto/view/widgets/custom_dropdownmenu.dart';
import 'package:e_alerto/view/widgets/custom_filledbutton.dart';
import 'package:e_alerto/view/widgets/custom_radiobutton.dart';
import 'package:e_alerto/view/widgets/custom_textarea.dart';
import 'package:e_alerto/view/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final category = ['Road', 'Foot Bridge', 'Sidewalk', 'Lamp Post'];
  int selectedRadioValue = 1;
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Classification",
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              CustomDropdown(
                items: category,
                onChanged: (value) {},
                hint: 'Select a category',
              ),
              SizedBox(height: ScreenUtil().setHeight(15)),
              const Text(
                "Location",
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              const CustomTextFormField(
                label: 'Location',
                hintText: 'Enter location',
              ),
              SizedBox(height: ScreenUtil().setHeight(15)),
              const Text(
                "Distance",
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              const CustomTextFormField(
                label: 'Distance',
                hintText: 'Enter distance from location',
              ),
              SizedBox(height: ScreenUtil().setHeight(15)),
              const Text(
                "Severity",
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              CustomRadiobutton(
                onChanged: (value) {
                  setState(() {
                    selectedRadioValue = value;
                  });
                },
              ),
              SizedBox(height: ScreenUtil().setHeight(15)),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.5,
                    style: BorderStyle.solid,
                    color: Colors.grey.shade400,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Severity Level $selectedRadioValue',
                      style: const TextStyle(
                        color: COLOR_PRIMARY,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(5)),
                    Text(
                      _getSeverityDescription(selectedRadioValue),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              const Text(
                "Description",
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              CustomTextArea(
                controller: descriptionController,
                hintText: "Write your description about the issue here...",
                maxLines: 4,
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              const Text(
                "Image",
                style: TextStyle(color: Colors.black54),
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/placeholder.png',
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              CustomFilledButton(
                text: 'Submit',
                onPressed: () {},
                fullWidth: true,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  String _getSeverityDescription(int value) {
    switch (value) {
      case 1:
        return "Minimal impact, barely noticeable.";
      case 2:
        return "Minor issue, no major consequences.";
      case 3:
        return "Moderate severity, some disruptions.";
      case 4:
        return "Significant issue, requires attention.";
      case 5:
        return "High severity, potential risk involved.";
      case 6:
        return "Critical condition, urgent action needed.";
      case 7:
        return "Severe emergency, immediate response required!";
      default:
        return "Select a severity level.";
    }
  }
}
