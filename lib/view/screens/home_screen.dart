// home_screen.dart OPTION 1
import 'package:e_alerto/view/widgets/custom_section_box.dart';
import 'package:e_alerto/view/widgets/post_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedStatus = 'Submitted';
  final List<PostCard> reports = [
    const PostCard(
      reportNumber: '1',
      classification: 'Cracked Bridge',
      location: 'Binondo-Intramuros Bridge',
      status: 'Accepted',
      date: '1/25/2025',
      username: '@omnom_alias',
      description:
          'Inspections have revealed significant cracks in the support beams',
      image: '/assets/images/image1.png',
    ),
    const PostCard(
      reportNumber: '2',
      classification: 'Deteriorated Parking',
      location: '106 Mendiola St.',
      status: 'In Progress',
      date: '3/1/2025',
      username: '@juan_dcruz',
      description:
          'The surface of the public parking lot is severely deteriorated',
      image: '/assets/images/image2.png',
    ),
    const PostCard(
      reportNumber: '3',
      classification: 'Sidewalk Damage',
      location: 'Gerardo Tuazon, Balic Balic',
      status: 'Submitted',
      date: '2/27/2025',
      username: '@saur_latina',
      description:
          'The sidewalk is cracked and uneven, posing a tripping hazard',
      image: '/assets/images/image3.png',
    ),
    const PostCard(
      reportNumber: '4',
      classification: 'Broken Traffic Light',
      location: 'Taft Avenue',
      status: 'Resolved',
      date: '3/6/2025',
      username: '@momioni',
      description: 'Broken traffic light causes traffic at the intersection',
      image: '/assets/images/image4.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Home'),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              icon: const Icon(Icons.arrow_drop_down),
              onSelected: (String newValue) {
                setState(() {
                  selectedStatus = newValue;
                });
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'Submitted',
                  child: Text('Submitted'),
                ),
                const PopupMenuItem<String>(
                  value: 'Accepted',
                  child: Text('Accepted'),
                ),
                const PopupMenuItem<String>(
                  value: 'In Progress',
                  child: Text('In Progress'),
                ),
                const PopupMenuItem<String>(
                  value: 'Resolved',
                  child: Text('Resolved'),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: CustomSectionBox(
        reports: reports,
        selectedStatus: selectedStatus,
      ),
    );
  }
}

// OPTION 2
// import 'package:e_alerto/view/widgets/custom_section_box.dart';
// import 'package:e_alerto/view/widgets/post_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   String selectedStatus = 'Submitted';
//   final List<PostCard> reports = [
//     const PostCard(
//       reportNumber: '1',
//       classification: 'Cracked Bridge',
//       location: 'Binondo-Intramuros Bridge',
//       status: 'Accepted',
//       date: '1/25/2025',
//       username: '@omnom_alias',
//       description:
//           'Inspections have revealed significant cracks in the support beams',
//       image: '/assets/images/image1.png',
//     ),
//     const PostCard(
//       reportNumber: '2',
//       classification: 'Deteriorated Parking',
//       location: '106 Mendiola St.',
//       status: 'In Progress',
//       date: '3/1/2025',
//       username: '@juan_dcruz',
//       description:
//           'The surface of the public parking lot is severely deteriorated',
//       image: '/assets/images/image2.png',
//     ),
//     const PostCard(
//       reportNumber: '3',
//       classification: 'Sidewalk Damage',
//       location: 'Gerardo Tuazon, Balic Balic',
//       status: 'Submitted',
//       date: '2/27/2025',
//       username: '@saur_latina',
//       description:
//           'The sidewalk is cracked and uneven, posing a tripping hazard',
//       image: '/assets/images/image3.png',
//     ),
//     const PostCard(
//       reportNumber: '4',
//       classification: 'Broken Traffic Light',
//       location: 'Taft Avenue',
//       status: 'Resolved',
//       date: '3/6/2025',
//       username: '@momioni',
//       description: 'Broken traffic light causes traffic at the intersection',
//       image: '/assets/images/image4.png',
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.white,
//         actions: [
//           Row(
//             children: [
//               Text(
//                 'Status:',
//                 style: TextStyle(
//                   fontSize: ScreenUtil().setSp(14),
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//               const SizedBox(width: 8),
//               DropdownButton<String>(
//                 value: selectedStatus,
//                 items: const [
//                   DropdownMenuItem(
//                       value: 'Submitted', child: Text('Submitted')),
//                   DropdownMenuItem(value: 'Accepted', child: Text('Accepted')),
//                   DropdownMenuItem(
//                       value: 'In Progress', child: Text('In Progress')),
//                   DropdownMenuItem(value: 'Resolved', child: Text('Resolved')),
//                 ],
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     selectedStatus = newValue!;
//                   });
//                 },
//                 underline: const SizedBox(),
//                 icon: const Icon(Icons.arrow_drop_down),
//                 style: TextStyle(
//                   fontSize: ScreenUtil().setSp(14),
//                   color: Colors.black,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(width: 16),
//         ],
//       ),
//       backgroundColor: Colors.white,
//       body: CustomSectionBox(
//         reports: reports,
//         selectedStatus: selectedStatus,
//       ),
//     );
//   }
// }


// import 'package:e_alerto/view/screens/detail_screen.dart';
// import 'package:e_alerto/view/widgets/custom_section_box.dart';
// import 'package:e_alerto/view/widgets/post_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List<PostCard> reports = [
//       const PostCard(
//         reportNumber: '1',
//         classification: 'Cracked Bridge',
//         location: 'Binondo-Intramuros Bridge',
//         status: 'Accepted',
//         date: '1/25/2025',
//         username: '@omnom_alias',
//         description:
//             'Inspections have revealed significant cracks in the support beams',
//         image: '/assets/images/image1.png',
//       ),
//       const PostCard(
//         reportNumber: '2',
//         classification: 'Deteriorated Parking',
//         location: '106 Mendiola St.',
//         status: 'In Progress',
//         date: '3/1/2025',
//         username: '@juan_dcruz',
//         description:
//             'The surface of the public parking lot is severely deteriorated',
//         image: '/assets/images/image2.png',
//       ),
//       const PostCard(
//         reportNumber: '3',
//         classification: 'Sidewalk Damage',
//         location: 'Gerardo Tuazon, Balic Balic',
//         status: 'Submitted',
//         date: '2/27/2025',
//         username: '@saur_latina',
//         description:
//             'The sidewalk is cracked and uneven, posing a tripping hazard',
//         image: '/assets/images/image3.png',
//       ),
//       const PostCard(
//         reportNumber: '4',
//         classification: 'Broken Traffic Light',
//         location: 'Taft Avenue',
//         status: 'Resolved',
//         date: '3/6/2025',
//         username: '@momioni',
//         description: 'Broken traffic light causes traffic at the intersection',
//         image: '/assets/images/image4.png',
//       ),
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.white,
//       ),
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: EdgeInsets.all(ScreenUtil().setSp(15)),
//         child: CustomSectionBox(reports: reports),
//       ),
//     );
//   }
// }
