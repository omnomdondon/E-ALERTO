import 'package:e_alerto/view/screens/status_screen.dart/accepted_screen.dart';
import 'package:e_alerto/view/screens/status_screen.dart/in_progress_screen.dart';
import 'package:e_alerto/view/screens/status_screen.dart/resolved_screen.dart';
import 'package:e_alerto/view/screens/status_screen.dart/submitted__screen.dart';
import 'package:e_alerto/view/widgets/custom_section_box.dart';
import 'package:e_alerto/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<PostCard> reports = const [
    PostCard(
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
    PostCard(
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
    PostCard(
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
    PostCard(
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
        title: const Text('Home'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil().setSp(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StatusBox(
              title: 'Submitted',
              color: Colors.blueAccent,
              screen: SubmittedScreen(reports: reports),
            ),
            StatusBox(
              title: 'Accepted',
              color: Colors.green,
              screen: AcceptedScreen(reports: reports),
            ),
            StatusBox(
              title: 'In Progress',
              color: Colors.orange,
              screen: InProgressScreen(reports: reports),
            ),
            StatusBox(
              title: 'Resolved',
              color: Colors.purple,
              screen: ResolvedScreen(reports: reports),
            ),
          ],
        ),
      ),
    );
  }
}



// // home_screen.dart OPTION 1
// import 'package:e_alerto/view/widgets/custom_section_box.dart';
// import 'package:e_alerto/view/widgets/post_card.dart';
// import 'package:flutter/material.dart';

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
//         title: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text('Home'),
//             const SizedBox(width: 8),
//             PopupMenuButton<String>(
//               icon: const Icon(Icons.arrow_drop_down),
//               onSelected: (String newValue) {
//                 setState(() {
//                   selectedStatus = newValue;
//                 });
//               },
//               itemBuilder: (BuildContext context) => [
//                 const PopupMenuItem<String>(
//                   value: 'Submitted',
//                   child: Text('Submitted'),
//                 ),
//                 const PopupMenuItem<String>(
//                   value: 'Accepted',
//                   child: Text('Accepted'),
//                 ),
//                 const PopupMenuItem<String>(
//                   value: 'In Progress',
//                   child: Text('In Progress'),
//                 ),
//                 const PopupMenuItem<String>(
//                   value: 'Resolved',
//                   child: Text('Resolved'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.white,
//       ),
//       backgroundColor: Colors.white,
//       body: CustomSectionBox(
//         reports: reports,
//         selectedStatus: selectedStatus,
//       ),
//     );
//   }
// }