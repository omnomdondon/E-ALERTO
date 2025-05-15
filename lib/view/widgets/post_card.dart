import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../constant/api.dart';
import '../../constants.dart';
import 'notification_card.dart';

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

    DateTime parsedDate;
    try {
      parsedDate = DateFormat("yyyy-MM-dd").parse(widget.date);
    } catch (e) {
      parsedDate = DateTime.now();
    }
    final timeAgo = timeago.format(parsedDate);

    final isGridFsId = RegExp(r'^[a-f\d]{24}$').hasMatch(widget.image);
    final imageUrl =
        isGridFsId ? "$baseUrl/image/${widget.image}" : widget.image;

    return GestureDetector(
      onTap: () {
        final extra = {
          'classification': widget.classification,
          'location': widget.location,
          'status': widget.status,
          'date': widget.date,
          'username': widget.username,
          'description': widget.description,
          'image': widget.image,
        };

        widget.rate
            ? context.pushNamed(
                'profileRating',
                pathParameters: {'reportNumber': widget.reportNumber},
                extra: extra,
              )
            : context.pushNamed(
                'homeDetail',
                pathParameters: {'reportNumber': widget.reportNumber},
                extra: extra,
              );
      },
      child: Builder(
        builder: (context) => Hero(
          tag: 'report_${widget.reportNumber}',
          child: Material(
            type: MaterialType.transparency,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
              elevation: 8,
              shadowColor: Colors.grey.shade300,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🖼️ Image from network
                    if (imageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          width: double.infinity,
                          height: 150.h, // 💥 Match height with DetailScreen
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    SizedBox(height: 12.h),

                    // Classification + Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.classification,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: getStatusColor(widget.status),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.status,
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    // Location
                    Text(
                      widget.location,
                      style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),

                    // Description
                    Text(
                      widget.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12.sp, color: Colors.grey.shade600),
                    ),
                    SizedBox(height: 12.h),

                    // Bottom row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Posted by ',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey.shade600),
                                ),
                                TextSpan(
                                  text: '@${widget.username}',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade800,
                                  ),
                                ),
                                TextSpan(
                                  text: ' • $timeAgo',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
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
        ),
      ),
    );
  }
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
// import 'package:timeago/timeago.dart' as timeago;

// import '../../constants.dart';
// import 'notification_card.dart';

// class PostCard extends StatefulWidget {
//   final String reportNumber;
//   final String classification;
//   final String location;
//   final String status;
//   final String date;
//   final String username;
//   final String description;
//   final String image;
//   final int initialUpVotes;
//   final int initialDownVotes;
//   final bool rate;

//   const PostCard({
//     super.key,
//     required this.reportNumber,
//     required this.classification,
//     required this.location,
//     required this.status,
//     required this.date,
//     required this.username,
//     required this.description,
//     this.rate = false,
//     required this.image,
//     this.initialUpVotes = 0,
//     this.initialDownVotes = 0,
//   });

//   @override
//   State<PostCard> createState() => _PostCardState();
// }

// class _PostCardState extends State<PostCard> {
//   int upVotes = 0;
//   int downVotes = 0;
//   int userVote = 0;

//   @override
//   void initState() {
//     super.initState();
//     upVotes = widget.initialUpVotes;
//     downVotes = widget.initialDownVotes;
//   }

//   void vote(int voteType) {
//     setState(() {
//       if (userVote == voteType) {
//         if (voteType == 1) upVotes--;
//         if (voteType == -1) downVotes--;
//         userVote = 0;
//       } else {
//         if (userVote == 1) upVotes--;
//         if (userVote == -1) downVotes--;
//         if (voteType == 1) upVotes++;
//         if (voteType == -1) downVotes++;
//         userVote = voteType;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final totalVote = upVotes - downVotes;

//     // Parsing date
//     DateTime parsedDate;
//     try {
//       parsedDate = DateFormat("yyyy-MM-dd").parse(widget.date);
//     } catch (e) {
//       parsedDate = DateTime.now();
//     }
//     final timeAgo = timeago.format(parsedDate);

//     return GestureDetector(
//       onTap: () {
//         final extra = {
//           'classification': widget.classification,
//           'location': widget.location,
//           'status': widget.status,
//           'date': widget.date,
//           'username': widget.username,
//           'description': widget.description,
//           'image': widget.image,
//         };

//         widget.rate
//             ? context.pushNamed(
//                 'profileRating',
//                 pathParameters: {'reportNumber': widget.reportNumber},
//                 extra: extra,
//               )
//             : context.pushNamed(
//                 'homeDetail',
//                 pathParameters: {'reportNumber': widget.reportNumber},
//                 extra: extra,
//               );
//       },
//       child: Hero(
//         tag: 'report_${widget.reportNumber}',
//         child: Card(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
//           elevation: 8,
//           shadowColor: Colors.grey.shade300,
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               return SingleChildScrollView(
//                 physics: const NeverScrollableScrollPhysics(),
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(
//                     minWidth: constraints.maxWidth,
//                     maxWidth: constraints.maxWidth,
//                     minHeight: 0,
//                     maxHeight: double.infinity,
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(16.w),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Image Preview
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(16),
//                           child: AspectRatio(
//                             aspectRatio: 16 / 9,
//                             child: Image.memory(
//                               base64Decode(widget.image),
//                               width: double.infinity,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: 12.h),

//                         // Classification and Status
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Flexible(
//                               child: Text(
//                                 widget.classification,
//                                 style: TextStyle(
//                                   fontSize: 18.sp,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black87,
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                               ),
//                             ),
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 12.w, vertical: 6.h),
//                               decoration: BoxDecoration(
//                                 color: getStatusColor(widget.status),
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Text(
//                                 widget.status,
//                                 style: TextStyle(
//                                     fontSize: 14.sp, color: Colors.white),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 8.h),

//                         // Location
//                         Text(
//                           widget.location,
//                           style:
//                               TextStyle(fontSize: 14.sp, color: Colors.black54),
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                         ),
//                         SizedBox(height: 8.h),

//                         // Description
//                         Text(
//                           widget.description,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                               fontSize: 12.sp, color: Colors.grey.shade600),
//                         ),
//                         SizedBox(height: 12.h),

//                         // Bottom: Username + Date + Voting
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             // Username & Date
//                             Expanded(
//                               child: Text.rich(
//                                 TextSpan(
//                                   children: [
//                                     TextSpan(
//                                       text: 'Posted by ',
//                                       style: TextStyle(
//                                           fontSize: 12.sp,
//                                           color: Colors.grey.shade600),
//                                     ),
//                                     TextSpan(
//                                       text: '@${widget.username}',
//                                       style: TextStyle(
//                                           fontSize: 12.sp,
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.blue.shade800),
//                                     ),
//                                     TextSpan(
//                                       text: ' • $timeAgo',
//                                       style: TextStyle(
//                                           fontSize: 12.sp,
//                                           color: Colors.grey.shade600),
//                                     ),
//                                   ],
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                               ),
//                             ),

//                             // Vote Buttons
//                             Row(
//                               children: [
//                                 IconButton(
//                                   onPressed: () => vote(1),
//                                   icon: Icon(
//                                     Icons.arrow_upward,
//                                     color: userVote == 1
//                                         ? COLOR_PRIMARY
//                                         : Colors.grey.shade400,
//                                   ),
//                                 ),
//                                 Text(
//                                   '$totalVote',
//                                   style: TextStyle(
//                                     color: Colors.black87,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 13.sp,
//                                   ),
//                                 ),
//                                 IconButton(
//                                   onPressed: () => vote(-1),
//                                   icon: Icon(
//                                     Icons.arrow_downward,
//                                     color: userVote == -1
//                                         ? COLOR_SUBMITTED
//                                         : Colors.grey.shade400,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }