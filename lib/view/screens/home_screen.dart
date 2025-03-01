import 'package:e_alerto/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Home'), backgroundColor: Colors.white,),
    backgroundColor: Colors.white,
    body: Center(
      child: ListView(
        //mainAxisAlignment: MainAxisAlignment.center,
        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
        children: [
          PostCard(
            reportNumber: '1',
            classification: 'Classification',
            location: 'Location',
            status: 'Submitted', //TODO: Change color depending on status 
            date: '01/01/2025',
            username: 'username',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
          ),
          PostCard(
            reportNumber: '1',
            classification: 'Classification',
            location: 'Location',
            status: 'Accepted', //TODO: Change color depending on status 
            date: '01/01/2025',
            username: 'username',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
          ),
          PostCard(
            reportNumber: '1',
            classification: 'Classification',
            location: 'Location',
            status: 'In Progress', //TODO: Change color depending on status 
            date: '01/01/2025',
            username: 'username',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
          ),
          PostCard(
            reportNumber: '1',
            classification: 'Classification',
            location: 'Location',
            status: 'Resolved', //TODO: Change color depending on status 
            date: '01/01/2025',
            username: 'username',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
          ),
          PostCard(
            reportNumber: '1',
            classification: 'Classification',
            location: 'Location',
            status: 'Declined', //TODO: Change color depending on status 
            date: '01/01/2025',
            username: 'username',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
          )
        ],
      ),
    ),
  );
}