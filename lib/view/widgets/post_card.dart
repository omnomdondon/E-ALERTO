import 'package:e_alerto/constants.dart';
import 'package:e_alerto/controller/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PostCard extends StatefulWidget {
  final String reportNumber;
  final String classification;
  final String location;
  final String status;
  final String date;
  final String username;
  final String description;
  final String image;
  final int initialUpVotes;
  final int initialDownVotes;
  final bool rate;

  const PostCard({
    super.key,
    required this.reportNumber,
    required this.classification,
    required this.location,
    required this.status,
    required this.date,
    required this.username,
    required this.description,
    this.rate = false,
    required this.image,
    this.initialUpVotes = 0,
    this.initialDownVotes = 0,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int upVotes = 0;
  int downVotes = 0;
  int totalVote = 0;
  int userVote = 0; // 1 for upvote, -1 for downvote, 0 for neutral

  @override
  void initState() {
    super.initState();
    upVotes = widget.initialUpVotes;
    downVotes = widget.initialDownVotes;
    totalVote = upVotes - downVotes;
  }

  void vote(int voteType) {
    setState(() {
      if (userVote == voteType) {
        // If the user clicks the same vote, reset it
        if (voteType == 1) {
          upVotes--;
        } else {
          downVotes--;
        }
        userVote = 0;
      } else {
        // Remove previous vote if exists
        if (userVote == 1) {
          upVotes--;
        } else if (userVote == -1) {
          downVotes--;
        }

        // Apply new vote
        if (voteType == 1) {
          upVotes++;
        } else {
          downVotes++;
        }

        userVote = voteType;
      }
      totalVote = upVotes - downVotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
      widget.rate ?
      context.push(
        '${Routes.profileRating}?reportNumber=${widget.reportNumber}'
        '&classification=${widget.classification}'
        '&location=${widget.location}'
        '&status=${widget.status}'
        '&date=${widget.date}'
        '&username=${widget.username}'
        '&description=${widget.description}',
        extra: {'image': widget.image},
      )
      : context.push(
        '${Routes.homeDetail}?reportNumber=${widget.reportNumber}'
        '&classification=${widget.classification}'
        '&location=${widget.location}'
        '&status=${widget.status}'
        '&date=${widget.date}'
        '&username=${widget.username}'
        '&description=${widget.description}',
        extra: {'image': widget.image},
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
                    maxLines: 1, //TODO: FIX DIZ
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,//ScreenUtil().setSp(16),
                      color: Colors.black
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style:  ElevatedButton.styleFrom(
                      backgroundColor: getStatusColor(widget.status),// Set background color
                      minimumSize: Size(ScreenUtil().setWidth(100), ScreenUtil().setHeight(25)), // Ensures a minimum width and height
                      maximumSize: Size(ScreenUtil().setWidth(120), ScreenUtil().setHeight(100)),
                      //textStyle: TextStyle(fontSize: 12) 
                    ),
                    child: Text(widget.status, 
                      style: const TextStyle(
                      fontSize: 12, //ScreenUtil().setSp(10),
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
                    style: const TextStyle(
                      fontSize: 14, //ScreenUtil().setSp(12),
                      color: Colors.black
                    ),
                  ),
                  Padding(padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: Text(
                      widget.date,
                      style: const TextStyle(
                        fontSize: 12, //ScreenUtil().setSp(12),
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
                      fontSize: 12, //ScreenUtil().setSp(10),
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
                        fontSize: 12, //ScreenUtil().setSp(10),
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
                    onPressed: () {
                      vote(1);
                    }, 
                    icon: Icon(Icons.arrow_circle_up, size: 20, /*ScreenUtil().setSp(20),*/ color: userVote == 1 ? COLOR_PRIMARY : Colors.grey.shade400, weight: 20,), 
                    label: Text(totalVote.toString(),
                      style: TextStyle(
                        color: userVote == 1 || userVote == -1 ? COLOR_PRIMARY : Colors.grey.shade400,
                        fontWeight: FontWeight.bold,
                        fontSize: 14, //ScreenUtil().setSp(12)
                      ),
                    ),          
                  ),
                  IconButton(
                    onPressed: () {
                      vote(-1);
                    }, 
                    icon: const Icon(Icons.arrow_circle_down, weight: 20,), 
                    
                    style: IconButton.styleFrom(
                      foregroundColor: userVote == -1 ? COLOR_PRIMARY : Colors.grey.shade400,
                      iconSize: 20, //ScreenUtil().setSp(20)
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

Color getStatusColor (String status) {
  switch (status.toLowerCase()) {
    case 'submitted':
      return COLOR_SUBMITTED;
    case 'accepted':
      return COLOR_ACCEPTED;
    case 'in progress':
      return COLOR_INPROGRESS;
    case 'resolved':
      return COLOR_RESOLVED;
    default:
      return COLOR_DEFAULT; // Default color if no match
  }
}
