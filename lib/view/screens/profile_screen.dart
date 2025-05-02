import 'package:e_alerto/constants.dart';
import 'package:e_alerto/controller/auth_service.dart';
import 'package:e_alerto/controller/routes.dart';
import 'package:e_alerto/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    final fetchedUsername = await AuthService.getUsername();
    if (mounted) {
      setState(() {
        username = fetchedUsername ?? 'Unknown';
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined, size: 24),
              onPressed: () => context.push(Routes.profileSettings),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setSp(15)),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: ScreenUtil().setWidth(20)),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '@$username',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  const TabBar(
                    indicatorColor: COLOR_PRIMARY,
                    indicatorSize: TabBarIndicatorSize.tab,
                    unselectedLabelColor: Colors.black54,
                    indicator: BoxDecoration(
                      color: COLOR_SECONDARY,
                      border: Border(
                        bottom: BorderSide(color: COLOR_PRIMARY, width: 1),
                      ),
                    ),
                    labelColor: COLOR_PRIMARY,
                    tabs: [
                      Tab(text: 'My Reports'),
                      Tab(text: 'To Rate'),
                      Tab(text: 'History'),
                    ],
                  ),
                ),
              ),
            ],
            body: TabBarView(
              children: [
                MyReportsTab(username: username),
                ToRateTab(username: username),
                HistoryTab(username: username),
              ],
            ),
          ),
        ),
      );
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.grey.shade100, child: tabBar);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class MyReportsTab extends StatelessWidget {
  final String username;
  const MyReportsTab({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(ScreenUtil().setSp(15)),
      children: [
        PostCard(
          reportNumber: '1',
          classification: 'Pothole',
          location: 'Main Street',
          status: 'In Progress',
          date: '01/01/2025',
          username: '@$username',
          description: 'Huge pothole blocking the road.',
          image: 'assets/images/image1.png',
        ),
      ],
    );
  }
}

class ToRateTab extends StatelessWidget {
  final String username;
  const ToRateTab({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(ScreenUtil().setSp(15)),
      itemCount: 3,
      itemBuilder: (context, index) => PostCard(
        rate: true,
        reportNumber: '${index + 1}',
        classification: 'Incident ${index + 1}',
        location: 'Random Location',
        status: 'Resolved',
        date: '02/02/2025',
        username: '@$username',
        description: 'Sample description of report to rate.',
        image: 'assets/images/image2.png',
      ),
    );
  }
}

class HistoryTab extends StatelessWidget {
  final String username;
  const HistoryTab({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(ScreenUtil().setSp(15)),
      itemCount: 4,
      itemBuilder: (context, index) => PostCard(
        reportNumber: '${index + 1}',
        classification: 'Resolved Case ${index + 1}',
        location: 'Historical Place',
        status: 'Rated',
        date: '03/03/2025',
        username: '@$username',
        description: 'Sample description of completed report.',
        image: 'assets/images/image3.png',
      ),
    );
  }
}


// import 'package:e_alerto/constants.dart';
// import 'package:e_alerto/controller/auth_service.dart';
// import 'package:e_alerto/controller/routes.dart';
// import 'package:e_alerto/view/widgets/post_card.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   String username = 'Loading...'; // Default until fetched

//   @override
//   void initState() {
//     super.initState();
//     _fetchUsername();
//   }

//   Future<void> _fetchUsername() async {
//     final fetchedUsername = await AuthService.getUsername();
//     if (mounted) {
//       setState(() {
//         username = fetchedUsername ?? 'Unknown';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(
//           title: const Text('Profile'),
//           backgroundColor: Colors.white,
//           surfaceTintColor: Colors.white,
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.settings_outlined, size: 24),
//               onPressed: () => context.push(Routes.profileSettings),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.white,
//         body: DefaultTabController(
//           length: 3,
//           child: NestedScrollView(
//             headerSliverBuilder: (context, innerBoxIsScrolled) => [
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: EdgeInsets.all(ScreenUtil().setSp(15)),
//                   child: Row(
//                     children: [
//                       const CircleAvatar(
//                         radius: 40,
//                         backgroundColor: Colors.grey,
//                         child: Icon(
//                           Icons.person,
//                           size: 40,
//                           color: Colors.white,
//                         ),
//                       ),
//                       SizedBox(width: ScreenUtil().setWidth(20)),
//                       Flexible(
//                         flex: 1,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               '@$username',
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.black87,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const Text(
//                               'Edit Profile',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SliverPersistentHeader(
//                 pinned: true,
//                 delegate: _TabBarDelegate(
//                   const TabBar(
//                     indicatorColor: COLOR_PRIMARY,
//                     indicatorSize: TabBarIndicatorSize.tab,
//                     unselectedLabelColor: Colors.black54,
//                     indicator: BoxDecoration(
//                       color: COLOR_SECONDARY,
//                       border: Border(
//                         bottom: BorderSide(color: COLOR_PRIMARY, width: 1),
//                       ),
//                     ),
//                     labelColor: COLOR_PRIMARY,
//                     tabs: [
//                       Tab(text: 'My Reports'),
//                       Tab(text: 'To Rate'),
//                       Tab(text: 'History'),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//             body: TabBarView(
//               children: [
//                 MyReportsTab(username: username),
//                 ToRateTab(username: username),
//                 HistoryTab(username: username),
//               ],
//             ),
//           ),
//         ),
//       );
// }

// // Custom sticky TabBar delegate
// class _TabBarDelegate extends SliverPersistentHeaderDelegate {
//   final TabBar tabBar;

//   _TabBarDelegate(this.tabBar);

//   @override
//   double get minExtent => tabBar.preferredSize.height;
//   @override
//   double get maxExtent => tabBar.preferredSize.height;

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: Colors.grey.shade100,
//       child: tabBar,
//     );
//   }

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     return false;
//   }
// }

// // Tabs
// class MyReportsTab extends StatelessWidget {
//   final String username;
//   const MyReportsTab({super.key, required this.username});

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: EdgeInsets.all(ScreenUtil().setSp(15)),
//       children: [
//         PostCard(
//           reportNumber: '1',
//           classification: 'Pothole',
//           location: 'Main Street',
//           status: 'In Progress',
//           date: '01/01/2025',
//           username: '@$username',
//           description: 'Huge pothole blocking the road.',
//           image: 'assets/images/image1.png',
//         ),
//         PostCard(
//           reportNumber: '2',
//           classification: 'Broken Sign',
//           location: '2nd Avenue',
//           status: 'Accepted',
//           date: '02/01/2025',
//           username: '@$username',
//           description: 'Dangerous signage has fallen.',
//           image: 'assets/images/image2.png',
//         ),
//       ],
//     );
//   }
// }

// class ToRateTab extends StatelessWidget {
//   final String username;
//   const ToRateTab({super.key, required this.username});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: EdgeInsets.all(ScreenUtil().setSp(15)),
//       itemCount: 3,
//       itemBuilder: (context, index) => PostCard(
//         rate: true,
//         reportNumber: '${index + 1}',
//         classification: 'Incident ${index + 1}',
//         location: 'Random Location',
//         status: 'Resolved',
//         date: '02/02/2025',
//         username: '@$username',
//         description: 'Sample description of report to rate.',
//         image: 'assets/images/image2.png',
//       ),
//     );
//   }
// }

// class HistoryTab extends StatelessWidget {
//   final String username;
//   const HistoryTab({super.key, required this.username});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       padding: EdgeInsets.all(ScreenUtil().setSp(15)),
//       itemCount: 4,
//       itemBuilder: (context, index) => PostCard(
//         reportNumber: '${index + 1}',
//         classification: 'Resolved Case ${index + 1}',
//         location: 'Historical Place',
//         status: 'Rated',
//         date: '03/03/2025',
//         username: '@$username',
//         description: 'Sample description of completed report.',
//         image: 'assets/images/image3.png',
//       ),
//     );
//   }
// }