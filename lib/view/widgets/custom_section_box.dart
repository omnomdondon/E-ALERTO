// DROPDOWN OPTION 1
import 'package:e_alerto/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSectionBox extends StatelessWidget {
  final List<PostCard> reports;
  final String selectedStatus;

  const CustomSectionBox({
    super.key,
    required this.reports,
    required this.selectedStatus,
  });

  @override
  Widget build(BuildContext context) {
    final filteredReports = reports
        .where((report) =>
            (report.status?.toLowerCase() ?? '') ==
            selectedStatus.toLowerCase())
        .toList();

    if (filteredReports.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: ScreenUtil().setSp(40),
              color: Colors.grey.shade400,
            ),
            SizedBox(height: ScreenUtil().setHeight(16)),
            Text(
              'No $selectedStatus reports',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16),
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.only(
        top: ScreenUtil().setHeight(16),
        bottom: ScreenUtil().setHeight(20),
      ),
      itemCount: filteredReports.length,
      separatorBuilder: (context, index) => Divider(
        height: ScreenUtil().setHeight(1),
        thickness: 0.5,
        color: Colors.grey.shade200,
      ),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(16),
          ),
          child: filteredReports[index],
        );
      },
    );
  }
}

// DROPDOWN OPTION 2
// import 'package:e_alerto/view/widgets/post_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CustomSectionBox extends StatelessWidget {
//   final List<PostCard> reports;
//   final String selectedStatus;

//   const CustomSectionBox({
//     super.key,
//     required this.reports,
//     required this.selectedStatus,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final filteredReports = reports
//         .where((report) =>
//             (report.status?.toLowerCase() ?? '') ==
//             selectedStatus.toLowerCase())
//         .toList();

//     if (filteredReports.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.assignment_outlined,
//               size: ScreenUtil().setSp(40),
//               color: Colors.grey.shade400,
//             ),
//             SizedBox(height: ScreenUtil().setHeight(16)),
//             Text(
//               'No $selectedStatus reports',
//               style: TextStyle(
//                 fontSize: ScreenUtil().setSp(16),
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.separated(
//       padding: EdgeInsets.only(
//         top: ScreenUtil().setHeight(16),
//         bottom: ScreenUtil().setHeight(20),
//       ),
//       itemCount: filteredReports.length,
//       separatorBuilder: (context, index) => Divider(
//         height: ScreenUtil().setHeight(1),
//         thickness: 0.5,
//         color: Colors.grey.shade200,
//       ),
//       itemBuilder: (context, index) {
//         return Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: ScreenUtil().setWidth(16),
//           ),
//           child: filteredReports[index],
//         );
//       },
//     );
//   }
// }


// MINIMAL TAB
// import 'package:e_alerto/constants.dart';
// import 'package:e_alerto/view/widgets/post_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CustomSectionBox extends StatefulWidget {
//   final List<PostCard> reports;

//   const CustomSectionBox({super.key, required this.reports});

//   @override
//   State<CustomSectionBox> createState() => _CustomSectionBoxState();
// }

// class _CustomSectionBoxState extends State<CustomSectionBox> {
//   String selectedStatus = 'Submitted';
//   final List<String> statuses = [
//     'Submitted',
//     'Accepted',
//     'In Progress',
//     'Resolved'
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           height: ScreenUtil().setHeight(48),
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: statuses.length,
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding: EdgeInsets.only(
//                   left: index == 0
//                       ? ScreenUtil().setWidth(16)
//                       : ScreenUtil().setWidth(8),
//                 ),
//                 child: TextButton(
//                   onPressed: () {
//                     setState(() {
//                       selectedStatus = statuses[index];
//                     });
//                   },
//                   style: TextButton.styleFrom(
//                     foregroundColor: selectedStatus == statuses[index]
//                         ? COLOR_PRIMARY
//                         : Colors.grey.shade600,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     backgroundColor: selectedStatus == statuses[index]
//                         ? COLOR_PRIMARY.withOpacity(0.1)
//                         : Colors.transparent,
//                   ),
//                   child: Text(
//                     statuses[index],
//                     style: TextStyle(
//                       fontWeight: selectedStatus == statuses[index]
//                           ? FontWeight.bold
//                           : FontWeight.normal,
//                       fontSize: ScreenUtil().setSp(14),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//         Divider(
//           height: ScreenUtil().setHeight(1),
//           thickness: 0.5,
//           color: Colors.grey.shade200,
//         ),
//         Expanded(child: _buildStatusList(selectedStatus)),
//       ],
//     );
//   }

//   Widget _buildStatusList(String status) {
//     final filteredReports = widget.reports
//         .where((report) =>
//             (report.status?.toLowerCase() ?? '') == status.toLowerCase())
//         .toList();

//     if (filteredReports.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.assignment_outlined,
//               size: ScreenUtil().setSp(40),
//               color: Colors.grey.shade400,
//             ),
//             SizedBox(height: ScreenUtil().setHeight(16)),
//             Text(
//               'No $status reports',
//               style: TextStyle(
//                 fontSize: ScreenUtil().setSp(16),
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.separated(
//       padding: EdgeInsets.only(
//         top: ScreenUtil().setHeight(16),
//         bottom: ScreenUtil().setHeight(20),
//       ),
//       itemCount: filteredReports.length,
//       separatorBuilder: (context, index) => Divider(
//         height: ScreenUtil().setHeight(1),
//         thickness: 0.5,
//         color: Colors.grey.shade200,
//       ),
//       itemBuilder: (context, index) {
//         return Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: ScreenUtil().setWidth(16),
//           ),
//           child: filteredReports[index],
//         );
//       },
//     );
//   }
// }

// SEGMENT
// import 'package:e_alerto/constants.dart';
// import 'package:e_alerto/view/widgets/post_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CustomSectionBox extends StatefulWidget {
//   final List<PostCard> reports;

//   const CustomSectionBox({super.key, required this.reports});

//   @override
//   State<CustomSectionBox> createState() => _CustomSectionBoxState();
// }

// class _CustomSectionBoxState extends State<CustomSectionBox> {
//   String selectedStatus = 'Submitted';
//   final List<String> statuses = [
//     'Submitted',
//     'Accepted',
//     'In Progress',
//     'Resolved'
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: ScreenUtil().setWidth(16),
//             vertical: ScreenUtil().setHeight(8),
//           ),
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: SegmentedButton<String>(
//               segments: statuses.map((status) {
//                 return ButtonSegment(
//                     value: status,
//                     label: Text(
//                       status,
//                       style: TextStyle(fontSize: ScreenUtil().setSp(14)),
//                     ));
//               }).toList(),
//               selected: {selectedStatus},
//               onSelectionChanged: (Set<String> newSelection) {
//                 setState(() {
//                   selectedStatus = newSelection.first;
//                 });
//               },
//               showSelectedIcon: false,
//               style: ButtonStyle(
//                 backgroundColor: WidgetStateProperty.resolveWith<Color>(
//                   (Set<WidgetState> states) {
//                     if (states.contains(WidgetState.selected)) {
//                       return COLOR_PRIMARY.withOpacity(0.1);
//                     }
//                     return Colors.grey.shade100;
//                   },
//                 ),
//                 foregroundColor: MaterialStateProperty.resolveWith<Color>(
//                   (Set<MaterialState> states) {
//                     if (states.contains(MaterialState.selected)) {
//                       return COLOR_PRIMARY;
//                     }
//                     return Colors.grey.shade700;
//                   },
//                 ),
//                 side: MaterialStateProperty.resolveWith<BorderSide>(
//                   (Set<MaterialState> states) {
//                     return BorderSide(
//                       color: states.contains(MaterialState.selected)
//                           ? COLOR_PRIMARY
//                           : Colors.grey.shade300,
//                     );
//                   },
//                 ),
//                 shape: MaterialStateProperty.all(
//                   RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Divider(
//           height: ScreenUtil().setHeight(1),
//           thickness: 0.5,
//           color: Colors.grey.shade200,
//         ),
//         Expanded(child: _buildStatusList(selectedStatus)),
//       ],
//     );
//   }

//   Widget _buildStatusList(String status) {
//     final filteredReports = widget.reports
//         .where((report) =>
//             (report.status?.toLowerCase() ?? '') == status.toLowerCase())
//         .toList();

//     if (filteredReports.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.assignment_outlined,
//               size: ScreenUtil().setSp(40),
//               color: Colors.grey.shade400,
//             ),
//             SizedBox(height: ScreenUtil().setHeight(16)),
//             Text(
//               'No $status reports',
//               style: TextStyle(
//                 fontSize: ScreenUtil().setSp(16),
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.separated(
//       padding: EdgeInsets.only(
//         top: ScreenUtil().setHeight(16),
//         bottom: ScreenUtil().setHeight(20),
//       ),
//       itemCount: filteredReports.length,
//       separatorBuilder: (context, index) => Divider(
//         height: ScreenUtil().setHeight(1),
//         thickness: 0.5,
//         color: Colors.grey.shade200,
//       ),
//       itemBuilder: (context, index) {
//         return Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: ScreenUtil().setWidth(16),
//           ),
//           child: filteredReports[index],
//         );
//       },
//     );
//   }
// }

// CHIP FIILTER
// import 'package:e_alerto/constants.dart';
// import 'package:e_alerto/view/widgets/post_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CustomSectionBox extends StatefulWidget {
//   final List<PostCard> reports;

//   const CustomSectionBox({super.key, required this.reports});

//   @override
//   State<CustomSectionBox> createState() => _CustomSectionBoxState();
// }

// class _CustomSectionBoxState extends State<CustomSectionBox> {
//   String selectedStatus = 'Submitted';
//   final List<String> statuses = [
//     'Submitted',
//     'Accepted',
//     'In Progress',
//     'Resolved'
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Chip Filter Section
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           padding: EdgeInsets.symmetric(
//             horizontal: ScreenUtil().setWidth(16),
//             vertical: ScreenUtil().setHeight(8),
//           ),
//           child: Row(
//             children: statuses.map((status) {
//               return Padding(
//                 padding: EdgeInsets.only(right: ScreenUtil().setWidth(8)),
//                 child: FilterChip(
//                   label: Text(
//                     status,
//                     style: TextStyle(
//                       fontSize: ScreenUtil().setSp(14),
//                     ),
//                   ),
//                   selected: selectedStatus == status,
//                   onSelected: (bool selected) {
//                     setState(() {
//                       selectedStatus = status;
//                     });
//                   },
//                   backgroundColor: Colors.grey.shade100,
//                   selectedColor: COLOR_PRIMARY.withOpacity(0.2),
//                   labelStyle: TextStyle(
//                     color:
//                         selectedStatus == status ? COLOR_PRIMARY : Colors.black,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius:
//                         BorderRadius.circular(ScreenUtil().setWidth(8)),
//                     side: BorderSide(
//                       color: selectedStatus == status
//                           ? COLOR_PRIMARY
//                           : Colors.grey.shade300,
//                       width: 1,
//                     ),
//                   ),
//                   padding: EdgeInsets.symmetric(
//                     horizontal: ScreenUtil().setWidth(12),
//                     vertical: ScreenUtil().setHeight(4),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//         // Divider line
//         Divider(
//           height: ScreenUtil().setHeight(1),
//           thickness: 0.5,
//           color: Colors.grey.shade200,
//         ),
//         // Content Area
//         Expanded(
//           child: _buildStatusList(selectedStatus),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatusList(String status) {
//     final filteredReports = widget.reports
//         .where((report) =>
//             (report.status?.toLowerCase() ?? '') == status.toLowerCase())
//         .toList();

//     if (filteredReports.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.assignment_outlined,
//               size: ScreenUtil().setSp(40),
//               color: Colors.grey.shade400,
//             ),
//             SizedBox(height: ScreenUtil().setHeight(16)),
//             Text(
//               'No $status reports',
//               style: TextStyle(
//                 fontSize: ScreenUtil().setSp(16),
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     return ListView.separated(
//       padding: EdgeInsets.only(
//         top: ScreenUtil().setHeight(16),
//         bottom: ScreenUtil().setHeight(20),
//       ),
//       itemCount: filteredReports.length,
//       separatorBuilder: (context, index) => Divider(
//         height: ScreenUtil().setHeight(1),
//         thickness: 0.5,
//         color: Colors.grey.shade200,
//       ),
//       itemBuilder: (context, index) {
//         return Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: ScreenUtil().setWidth(16),
//           ),
//           child: filteredReports[index],
//         );
//       },
//     );
//   }
// }
