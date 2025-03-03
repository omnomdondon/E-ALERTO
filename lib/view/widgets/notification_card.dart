import 'package:e_alerto/constants.dart';
import 'package:e_alerto/controller/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class NotificationCard extends StatefulWidget {
  final String reportNumber;
  final String classification;
  final String location;
  final String status;
  final String date;
  final String username;
  final String description;
  final String image;
  int initialUpVotes;
  int initialDownVotes;
  bool rate;

  NotificationCard({
    super.key,
    required this.reportNumber,
    required this.classification,
    required this.location,
    required this.status,
    required this.date,
    required this.username,
    required this.description,
    this.rate = false,
    this.image = '',
    this.initialUpVotes = 0,
    this.initialDownVotes = 0,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  Widget build(BuildContext context) {
      return GestureDetector(
        onTap: () => widget.rate ? context.push(Routes.profileRating) : context.push(
        '${Routes.homeDetail}?reportNumber=${widget.reportNumber}'
        '&classification=${widget.classification}'
        '&location=${widget.location}'
        '&status=${widget.status}'
        '&date=${widget.date}'
        '&username=${widget.username}'
        '&description=${widget.description}',
        extra: '&image=${widget.image}',
      ),

        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, // Removes the default radius
            side: BorderSide(color: Colors.grey.shade400, width: 0.5), // Adds a border
          ),
          margin: EdgeInsets.zero,
          child: Padding(padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(12), ScreenUtil().setSp(10), ScreenUtil().setSp(12), ScreenUtil().setSp(12)),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  child: CircleAvatar(
                    radius: ScreenUtil().setSp(15),
                    backgroundImage: AssetImage('assets/placeholder.png'),
                  ),
                ),
                SizedBox(width: ScreenUtil().setWidth(15)),

                Flexible(
                  flex: 1,
                  child: 
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.classification,
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
                              style: TextStyle(
                                fontSize: 14, //ScreenUtil().setSp(12),
                                color: Colors.black
                              ),
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                              child: Text(
                                widget.date,
                                style: TextStyle(
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
                      ],
                    )           
                )
              ],
            ),
          ),
        )
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