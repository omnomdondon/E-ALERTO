import 'package:e_alerto/constants.dart';
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
  final String image; // Still passed for navigation to detail
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
  int userVote = 0;

  @override
  void initState() {
    super.initState();
    upVotes = widget.initialUpVotes;
    downVotes = widget.initialDownVotes;
  }

  void vote(int voteType) {
    setState(() {
      if (userVote == voteType) {
        if (voteType == 1) upVotes--;
        if (voteType == -1) downVotes--;
        userVote = 0;
      } else {
        if (userVote == 1) upVotes--;
        if (userVote == -1) downVotes--;
        if (voteType == 1) upVotes++;
        if (voteType == -1) downVotes++;
        userVote = voteType;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalVote = upVotes - downVotes;

    return GestureDetector(
      onTap: () => widget.rate
          ? context.push(
              '/profileRating?reportNumber=${widget.reportNumber}'
              '&classification=${widget.classification}'
              '&location=${widget.location}'
              '&status=${widget.status}'
              '&date=${widget.date}'
              '&username=${widget.username}'
              '&description=${widget.description}',
              extra: {'image': widget.image},
            )
          : context.push(
              '/home/detail?reportNumber=${widget.reportNumber}'
              '&classification=${widget.classification}'
              '&location=${widget.location}'
              '&status=${widget.status}'
              '&date=${widget.date}'
              '&username=${widget.username}'
              '&description=${widget.description}',
              extra: {'image': widget.image},
            ),
      child: Hero(
        tag: widget.reportNumber,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Classification and Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.classification,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: getStatusColor(widget.status),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.status,
                        style: TextStyle(fontSize: 12.sp, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // Location
                Text(
                  widget.location,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                ),
                SizedBox(height: 8.h),

                // Description
                Text(
                  widget.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
                ),
                SizedBox(height: 12.h),

                // Bottom: Username + Date + Voting (All in one row)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 👤 Username & 📅 Date
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Posted by ',
                              style: TextStyle(
                                  fontSize: 11.sp, color: Colors.grey.shade600),
                            ),
                            TextSpan(
                              text: '@${widget.username}',
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade800),
                            ),
                            TextSpan(
                              text: ' • ${widget.date}',
                              style: TextStyle(
                                  fontSize: 11.sp, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ⬆️⬇️ Vote Buttons
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => vote(1),
                          icon: Icon(
                            Icons.arrow_upward,
                            color: userVote == 1
                                ? COLOR_PRIMARY
                                : Colors.grey.shade400,
                          ),
                        ),
                        Text(
                          '$totalVote',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp,
                          ),
                        ),
                        IconButton(
                          onPressed: () => vote(-1),
                          icon: Icon(
                            Icons.arrow_downward,
                            color: userVote == -1
                                ? COLOR_SUBMITTED
                                : Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Color getStatusColor(String status) {
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
      return COLOR_DEFAULT;
  }
}