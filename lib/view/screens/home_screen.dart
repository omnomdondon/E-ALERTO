import 'package:e_alerto/view/widgets/post_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Home'),),
    backgroundColor: Colors.white,
    body: Center(
      child: ListView(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PostCard(
            reportNumber: '1',
            classification: 'Classification',
            location: 'Location',
            status: 'Status', //TODO: Change color depending on status 
            date: '01/01/2025',
            username: 'username',
            upVotes: 0,
            downVotes: 0,
          )
        ],
      ),
    ),
  );
}