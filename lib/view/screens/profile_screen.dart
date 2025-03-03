import 'package:e_alerto/constants.dart';
import 'package:e_alerto/controller/routes.dart';
import 'package:e_alerto/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

// TODO: FIX ERROR IN BUILDING STATE, NAG-EERROR KAPAG LUMIPAT NG PAGE WHILE SWIPING SA TABVIEW, BASTA YON
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Profile'),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      actions: [
        IconButton(
          icon: Icon(Icons.settings_outlined, size: 24,),  // ⚙️ Settings Icon
          onPressed: () => context.push(Routes.profileSettings)
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
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/placeholder.png'),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(20)),
                  const Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Username',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
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
            MyReportsTab(),
            ToRateTab(),
            HistoryTab(),
          ],
        ),
      ),
    ),
  );
}

// Custom TabBar Delegate to make it sticky
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
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



Widget MyReportsTab() => ListView(
  padding: EdgeInsets.all(ScreenUtil().setSp(15)),
  children: [
    PostCard(
    reportNumber: '1',
    classification: 'Classification',
    location: 'Location',
    status: 'In Progress',
    date: '01/01/2025',
    username: 'username',
    description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
    ),
    PostCard(
    reportNumber: '1',
    classification: 'Classification',
    location: 'Location',
    status: 'Accepted',
    date: '01/01/2025',
    username: 'username',
    description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
    ),
    PostCard(
      reportNumber: '1',
      classification: 'Classification',
      location: 'Location',
      status: 'Submitted',
      date: '01/01/2025',
      username: 'username',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
    ),
  ],
);

Widget ToRateTab() => ListView.builder(
  padding: EdgeInsets.all(ScreenUtil().setSp(15)),
  itemCount: 5,
  itemBuilder: (context, index) => PostCard(
    rate: true,
    reportNumber: '${index + 1}',
    classification: 'Classification',
    location: 'Location',
    status: 'Resolved',
    date: '01/01/2025',
    username: 'username',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
  ),
);

Widget HistoryTab() => ListView.builder(
  padding: EdgeInsets.all(ScreenUtil().setSp(15)),
  itemCount: 5,
  itemBuilder: (context, index) => PostCard(
    reportNumber: '${index + 1}',
    classification: 'Classification',
    location: 'Location',
    status: 'Rated',
    date: '01/01/2025',
    username: 'username',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
  ),
);
