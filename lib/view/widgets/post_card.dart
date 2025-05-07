import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../constants.dart';
import 'notification_card.dart';

class PostCard extends StatefulWidget {
  final String reportNumber;
  final String classification;
  final String location;
  final String status;
  final String date; // Keep the raw date string
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
    required this.date, // This will be passed as the raw timestamp
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

    // Try parsing the raw date string and handle the exception if it fails
    DateTime parsedDate;
    try {
      // Try parsing using the correct format
      parsedDate = DateFormat("yyyy-MM-dd")
          .parse(widget.date); // Match the expected format (e.g., '2025-05-05')
    } catch (e) {
      // If the format is incorrect, use the current date as a fallback
      parsedDate = DateTime.now();
    }

    final timeAgo = timeago.format(parsedDate); // Convert to relative time

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
                // Image Preview
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.memory(
                    base64Decode(widget.image), // Decoding base64 image data
                    width: double.infinity,
                    height: 150.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 8.h),
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
                              text: ' • $timeAgo', // Show the relative time
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