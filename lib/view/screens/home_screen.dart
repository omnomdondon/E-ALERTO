import 'package:e_alerto/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Home'), backgroundColor: Colors.white, surfaceTintColor: Colors.white),
    backgroundColor: Colors.white,
    body: Center(
      child: ListView(
        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
        children: [
          PostCard(
            reportNumber: '1',
            classification: 'Classification',
            location: 'Location',
            status: 'Submitted', 
            date: '01/01/2025',
            username: 'username',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum',
            image: 'assets/placeholder.png',
          ),
          PostCard(
            reportNumber: '2',
            classification: 'Classification',
            location: 'Location',
            status: 'Accepted', 
            date: '01/01/2025',
            username: 'username',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
          ),
          PostCard(
            reportNumber: '3',
            classification: 'Classification',
            location: 'Location',
            status: 'In Progress', 
            date: '01/01/2025',
            username: 'username',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
          ),
          PostCard(
            reportNumber: '4',
            classification: 'Classification',
            location: 'Location',
            status: 'Resolved', 
            date: '01/01/2025',
            username: 'username',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
          ),
          PostCard(
            reportNumber: '5',
            classification: 'Classification',
            location: 'Location',
            status: 'Declined',  
            date: '01/01/2025',
            username: 'username',
            description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
          )
        ],
      ),
    ),
  );
}