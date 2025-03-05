import 'package:e_alerto/constants.dart';
import 'package:e_alerto/view/widgets/custom_filledbutton.dart';
import 'package:e_alerto/view/widgets/custom_textarea.dart';
import 'package:e_alerto/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DetailScreen extends StatefulWidget {
  final String reportNumber;
  final String classification;
  final String location;
  final String status;
  final String date;
  final String username;
  final String description;
  final bool rate;
  final String image;
  final int initialUpVotes;
  final int initialDownVotes;

DetailScreen({
  super.key,
  this.reportNumber = '1',
  this.classification = 'classification',
  this.location = 'location',
  this.status = 'status',
  this.date = 'date',
  this.username = 'username',
  this.description = 'description',
  this.rate = false,
  this.initialUpVotes = 0,
  this.initialDownVotes = 0,
  Map<String, dynamic>? extra, 
}) : image = extra?['image'] ?? '' {
  debugPrint("Constructor image path: $image");
}
// Prevent null access

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
 int upVotes = 0;
  int downVotes = 0;
  int totalVote = 0;
  int userVote = 0; // 1 for upvote, -1 for downvote, 0 for neutral
  String correctedImagePath = '';

  @override
  void initState() {
    super.initState();
    upVotes = widget.initialUpVotes;
    downVotes = widget.initialDownVotes;
    totalVote = upVotes - downVotes;

    // Remove the leading slash
    correctedImagePath = widget.image.startsWith('/')
        ? widget.image.substring(1)
        : widget.image;

    debugPrint("Final image path used: $correctedImagePath");
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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      //title: const Text('Rating'),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.all(8.0), // Adjust padding as needed
        child: Container(
          width: 5,
          decoration: BoxDecoration(
            color: COLOR_PRIMARY, // Background color
            shape: BoxShape.circle, // Makes it circular
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white), // Icon color
            onPressed: () {
              GoRouter.of(context).pop();
            },
          ),
        ),
      ),
    ),
    backgroundColor: Colors.white,
    body: ListView(
      padding: EdgeInsets.all(ScreenUtil().setSp(15)),
      children: [
        Padding(padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(15), 8, ScreenUtil().setSp(15), 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // ✅ Center items
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                    widget.classification,
                    style: TextStyle(
                      fontSize: 18,//ScreenUtil().setSp(16),
                      color: Colors.black,
                      //fontWeight: FontWeight.bold
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
                      style: TextStyle(
                      fontSize: 14, //ScreenUtil().setSp(10),
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
                      fontSize: 16, //ScreenUtil().setSp(12),
                      color: Colors.black
                    ),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: Text(
                      widget.date,
                      style: TextStyle(
                        fontSize: 14, //ScreenUtil().setSp(12),
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
                      fontSize: 14, //ScreenUtil().setSp(10),
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
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontSize: 14, //ScreenUtil().setSp(10),
                        color: Colors.grey.shade600
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: ScreenUtil().setHeight(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        correctedImagePath,
                        width: double.infinity, // ✅ Take available space
                        height: ScreenUtil().setHeight(200), // ✅ Avoid full screen height
                        fit: BoxFit.cover, // ✅ Adjust to fill container
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
                    icon: Icon(Icons.arrow_circle_up, size: 22, /*ScreenUtil().setSp(20),*/ color: userVote == 1 ? COLOR_PRIMARY : Colors.grey.shade400, weight: 20,), 
                    label: Text(totalVote.toString(),
                      style: TextStyle(
                        color: userVote == 1 || userVote == -1 ? COLOR_PRIMARY : Colors.grey.shade400,
                        fontWeight: FontWeight.bold,
                        fontSize: 16, //ScreenUtil().setSp(12)
                      ),
                    ),          
                  ),
                  IconButton(
                    onPressed: () {
                      vote(-1);
                    }, 
                    icon: const Icon(Icons.arrow_circle_down, weight: 22,), 
                    
                    style: IconButton.styleFrom(
                      foregroundColor: userVote == -1 ? COLOR_PRIMARY : Colors.grey.shade400,
                      iconSize: 22, //ScreenUtil().setSp(20)
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ]
    ),
  );
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