import 'package:e_alerto/view/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Search'), backgroundColor: Colors.white, surfaceTintColor: Colors.white,),
    backgroundColor: Colors.white,
    body: Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(15), 2, ScreenUtil().setSp(15), 2), // ✅ Add some spacing
          child: const Form(
            child: CustomTextFormField(
              label: 'Search',
              hintText: 'Search',
            ),
          ),
        ),
        SizedBox(height: ScreenUtil().setHeight(10)), // ✅ Optional spacing
        Expanded( // ✅ Makes ListView scrollable while search bar stays fixed
          child: ListView(
            padding: EdgeInsets.all(ScreenUtil().setSp(15)),
            children: const [
              Center(
                child: Text(
                  'No search yet'
                ),
              )
                
              /*
              PostCard(
                reportNumber: '1',
                classification: 'Classification',
                location: 'Location',
                status: 'Submitted',
                date: '01/01/2025',
                username: 'username',
                description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
              ),
              PostCard(
                reportNumber: '1',
                classification: 'Classification',
                location: 'Location',
                status: 'Accepted',
                date: '01/01/2025',
                username: 'username',
                description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
              ),
              PostCard(
                reportNumber: '1',
                classification: 'Classification',
                location: 'Location',
                status: 'Submitted',
                date: '01/01/2025',
                username: 'username',
                description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
              ),
              PostCard(
                reportNumber: '1',
                classification: 'Classification',
                location: 'Location',
                status: 'Accepted',
                date: '01/01/2025',
                username: 'username',
                description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
              ), */
            ],
          ),
        ),
      ],
    ),
  );

}