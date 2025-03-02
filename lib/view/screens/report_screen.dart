import 'package:e_alerto/constants.dart';
import 'package:e_alerto/view/widgets/custom_dropdownmenu.dart';
import 'package:e_alerto/view/widgets/custom_filledbutton.dart';
import 'package:e_alerto/view/widgets/custom_image.dart';
import 'package:e_alerto/view/widgets/custom_radiobutton.dart';
import 'package:e_alerto/view/widgets/custom_textarea.dart';
import 'package:e_alerto/view/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportScreen extends StatefulWidget {
  ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  // TODO: move to appropriate class
  final category = ['Road', 'Foot Bridge', 'Sidewalk', 'Lamp Post'];
  int selectedRadioValue = 1;
  String severityDescription = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua soupei latina';
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Report'), backgroundColor: Colors.white,),
    backgroundColor: Colors.white,
    body: Center(
      child: ListView(
        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
        children: [
          Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // ✅ Center items
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                const Text(
                  "Classification", 
                  style: TextStyle(color: Colors.black54)
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
                  style: TextStyle(color: Colors.black54)
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                CustomTextFormField(
                  label: 'Location',
                  hintText: 'Enter location',
                ),
                SizedBox(height: ScreenUtil().setHeight(15)),

                const Text(
                  "Distance", 
                  style: TextStyle(color: Colors.black54)
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                CustomTextFormField(
                  label: 'Distance',
                  hintText: 'Enter distance from location',
                ),
                SizedBox(height: ScreenUtil().setHeight(15)),

                const Text(
                  "Severity", 
                  style: TextStyle(color: Colors.black54)
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomRadiobutton(
                      onChanged: (value) {
                        setState(() {
                          selectedRadioValue = value;
                        });
                      },
                    )
                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(15)),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.5, style: BorderStyle.solid, color: Colors.grey.shade400, ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  padding: EdgeInsets.all(14),
                  child: 
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Severity Level $selectedRadioValue',
                          style: const TextStyle(
                            color: COLOR_PRIMARY,
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(5)),
                        Text(
                          severityDescription
                        ),
                      ],
                    ),
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),

                const Text(
                  "Description", 
                  style: TextStyle(color: Colors.black54)
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
                  style: TextStyle(color: Colors.black54)
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20), // ✅ Rounded corners
                  child: Image.asset(
                    'assets/placeholder.png',
                    width: MediaQuery.of(context).size.width, // ✅ Full screen width
                    height: MediaQuery.of(context).size.height * 0.4, // ✅ 40% of screen height
                    fit: BoxFit.cover, // ✅ Ensures the image fills the space
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),

                CustomFilledButton(
                  text: 'Submit', 
                  onPressed: () => {}, //GoRouter.of(context).go('/home'),
                  fullWidth: true,
                ),
                SizedBox(height: 30),
              ]
            ),
          ),
        ],
      ),
    ),
  );
}