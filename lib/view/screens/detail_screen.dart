import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // For formatting date
import 'package:timeago/timeago.dart' as timeago;

import '../../constants.dart';
import '../widgets/notification_card.dart'; // Import the timeago package

class DetailScreen extends StatefulWidget {
  final String reportNumber;
  final String classification;
  final String location;
  final String status;
  final String date; // Raw date passed here
  final String username;
  final String description;
  final String image;

  DetailScreen({
    super.key,
    required this.reportNumber,
    required this.classification,
    required this.location,
    required this.status,
    required this.date, // Raw date passed here
    required this.username,
    required this.description,
    required Map<String, dynamic>? extra,
  }) : image = extra?['image'] ?? '';

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int upVotes = 0;
  int downVotes = 0;
  int userVote = 0;

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
    // Decode the base64 image string passed in `extra`
    base64Decode(widget.image);

    // Convert the raw date string to DateTime and format it (similar to how it's done in PostCard)
    final parsedDate = DateFormat("yyyy-MM-dd").parse(widget.date);
    final timestamp = parsedDate.toLocal(); // Convert to local time
    final timeAgo = timeago
        .format(timestamp); // Convert to relative time (e.g., 2 hours ago)

    final int totalVote = upVotes - downVotes;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              color: COLOR_PRIMARY,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => GoRouter.of(context).pop(),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.all(15.w),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Classification and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.classification,
                      style: TextStyle(fontSize: 18.sp, color: Colors.black)),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: getStatusColor(widget.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.status,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),

              // Location
              Text(widget.location,
                  style: const TextStyle(fontSize: 14, color: Colors.black)),
              SizedBox(height: 10.h),

              // Description
              Text(widget.description,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade800)),
              SizedBox(height: 20.h),

              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(
                  base64Decode(widget.image), // Decoding base64 image data
                  width: double.infinity,
                  height: 150.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20.h),

              // 🔻 Username + Date + Vote Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Username and date
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
                            text: ' • $timeAgo', // Display relative time
                            style: TextStyle(
                                fontSize: 11.sp, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Voting buttons
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => vote(1),
                        icon: Icon(
                          Icons.arrow_upward,
                          color: userVote == 1
                              ? Colors.blue
                              : Colors.grey.shade400,
                        ),
                      ),
                      Text(
                        '$totalVote',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      IconButton(
                        onPressed: () => vote(-1),
                        icon: Icon(
                          Icons.arrow_downward,
                          color: userVote == -1
                              ? Colors.red
                              : Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}