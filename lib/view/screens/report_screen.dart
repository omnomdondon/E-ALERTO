import 'package:e_alerto/view/widgets/custom_dropdownmenu.dart';
import 'package:e_alerto/view/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportScreen extends StatelessWidget {
  ReportScreen({super.key});

  // TODO: move to appropriate class
  final catergory = ['Road', 'Foot Bridge', 'Sidewalk', 'Lamp Post'];


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
                  items: catergory, 
                  onChanged: (value) {}, 
                  hint: 'Select a category',
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),

                const Text(
                  "Location", 
                  style: TextStyle(color: Colors.black54)
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                CustomTextFormField(
                  label: 'Location',
                  hintText: 'Enter location',
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),

                const Text(
                  "Distance", 
                  style: TextStyle(color: Colors.black54)
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                CustomTextFormField(
                  label: 'Distance',
                  hintText: 'Enter distance from location',
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
              ]
            ),
          ),
        ],
      ),
    ),
  );
  
  DropdownMenuItem<String> buildMenuItem(String catergory) => DropdownMenuItem(
    value: catergory,
    child: 
      Text(
        catergory,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(10)
        ),
      )
  );
}