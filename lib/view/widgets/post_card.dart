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
  final String description;
  final String image;
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
    required this.description,
    this.image = '',
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        margin: EdgeInsets.fromLTRB(0, 0, 0, ScreenUtil().setSp(15)),
        child: Padding(padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(15), 8, ScreenUtil().setSp(15), 0),
          child: Column(
            children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                    widget.classification,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      color: Colors.black
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style:  ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,// Set background color
                      minimumSize: const Size(90, 30), // Ensures a minimum width and height
                      maximumSize: const Size(150, 50),
                    ),
                    child: Text(widget.status, 
                      style: TextStyle(
                      fontSize: ScreenUtil().setSp(10),
                      color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.location,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(12),
                      color: Colors.black
                    ),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: Text(
                      widget.date,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(12),
                        color: Colors.black
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.username,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(12),
                      color: Colors.grey.shade600
                    ),
                  ),
                ],
              ),

              SizedBox(height: ScreenUtil().setHeight(5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(child: Text(
                      widget.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(10),
                        color: Colors.grey.shade600
                      ),
                    ),
                  ),
                ],
              ),

              //SizedBox(height: ScreenUtil().setHeight(5)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {}, 
                    icon: Icon(Icons.arrow_upward, size: ScreenUtil().setSp(18)), 
                    label: Text(widget.totalVote.toString(),
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: ScreenUtil().setSp(12)
                      ),
                    ),
                    style: TextButton.styleFrom(
                      iconColor: Colors.grey.shade400
                    ),
                  ),
                  IconButton(
                    onPressed: () {}, 
                    icon: const Icon(Icons.arrow_downward), 
                    
                    style: IconButton.styleFrom(
                      foregroundColor: Colors.grey.shade400,
                      iconSize: ScreenUtil().setSp(18)
                    ),
                  )
                  
                  
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}