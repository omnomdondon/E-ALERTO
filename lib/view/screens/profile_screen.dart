// profile_screen.dart (Firebase-stripped)
import 'package:e_alerto/constants.dart';
import 'package:e_alerto/controller/routes.dart';
import 'package:e_alerto/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    const Expanded(
                      child: Text(
                        '@username',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
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
                  labelColor: COLOR_PRIMARY,
                  unselectedLabelColor: Colors.black54,
                  tabs: [
                    Tab(text: 'My Reports'),
                    Tab(text: 'To Rate'),
                    Tab(text: 'History'),
                  ],
                ),
              ),
            ),
          ],
          body: const TabBarView(
            children: [
              MyReportsTab(),
              ToRateTab(),
              HistoryTab(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.grey.shade100,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class MyReportsTab extends StatelessWidget {
  const MyReportsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(ScreenUtil().setSp(15)),
      children: const [
        PostCard(
          reportNumber: '1',
          classification: 'Cracked Road',
          location: 'Sample Location',
          status: 'In Progress',
          date: '1/1/2025',
          username: '@user',
          description: 'This is a sample report',
          image: '/assets/images/image1.png',
        ),
      ],
    );
  }
}

class ToRateTab extends StatelessWidget {
  const ToRateTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(ScreenUtil().setSp(15)),
      children: const [
        PostCard(
          reportNumber: '2',
          classification: 'Damaged Signage',
          location: 'Another Location',
          status: 'Resolved',
          date: '2/2/2025',
          username: '@user',
          description: 'Needs replacement',
          image: '/assets/images/image2.png',
          rate: true,
        ),
      ],
    );
  }
}

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(ScreenUtil().setSp(15)),
      children: const [
        PostCard(
          reportNumber: '3',
          classification: 'Street Light Issue',
          location: 'Third Street',
          status: 'Rated',
          date: '3/3/2025',
          username: '@user',
          description: 'Light is flickering at night',
          image: '/assets/images/image3.png',
        ),
      ],
    );
  }
}
