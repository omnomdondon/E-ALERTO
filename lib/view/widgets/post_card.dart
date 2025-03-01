import 'package:e_alerto/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostCard extends StatefulWidget {
  final String reportNumber;
  final String classification;
  final String location;
  final String status;
  final String date;
  final String username;
  final int upVotes;
  final int downVotes;
  final int totalVote;

  PostCard({
    super.key,
    required this.reportNumber,
    required this.classification,
    required this.location,
    required this.status,
    required this.date,
    required this.username,
    required this.upVotes,
    required this.downVotes,
    this.totalVote = 0,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Placeholder()
        ),
      ),

      child: Card(
        color: const Color.fromARGB(255, 246, 246, 246),
        margin: EdgeInsets.all(ScreenUtil().setSp(15)),
        child: Padding(padding: EdgeInsets.all(ScreenUtil().setSp(15)),
          child: Column(

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.classification,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(12),
                      color: Colors.black
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red), // Set background color
                    ),
                    child: Text(widget.status, 
                      style: TextStyle(
                      fontSize: ScreenUtil().setSp(10),
                      color: Colors.white
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}