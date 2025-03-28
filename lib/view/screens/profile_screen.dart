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
          icon: const Icon(Icons.settings_outlined, size: 24,),  // ⚙️ Settings Icon
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
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(20)),
                  const Flexible(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '@juan_dcruz',
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
      reportNumber: '2',
      classification: 'Deteriorated Parking',
      location: '106 Mendiola St.',
      status: 'In Progress', 
      date: '3/1/2025',
      username: '@juan_dcruz',
      description: 'The surface of the public parking lot on 106 Mendiola Street is severely deteriorated, with large potholes and uneven surfaces.',
      image: '/assets/images/image2.png',
    ),
    PostCard(
      reportNumber: '2',
      classification: 'Broken Lamp Post',
      location: '551 M.F. Jhocson St.',
      status: 'Submitted', 
      date: '3/1/2025',
      username: '@juan_dcruz',
      description: 'A lamp post has fell at M.F. Jhocson St. Near NU Manila',
      image: '/assets/images/image5.png',
    ),
    PostCard(
      reportNumber: '2',
      classification: 'Man Hole',
      location: 'Legarda St.',
      status: 'Accepted', 
      date: '2/14/2025',
      username: '@juan_dcruz',
      description: 'This pot hole has not been resolved yet for a month. Please fix this, as it poses a potential risk in regards to traffic concerns and safety',
      image: '/assets/images/image6.png',
    ),
  ],
);

Widget ToRateTab() => ListView.builder(
  padding: EdgeInsets.all(ScreenUtil().setSp(15)),
  itemCount: 1,
  itemBuilder: (context, index) => 
  PostCard(
    reportNumber: '2',
    classification: 'Uneven Pavement',
    location: '128 Panay Ave. QC',
    status: 'Resolved', 
    date: '2/2/2025',
    username: '@juan_dcruz',
    description: 'The surface of this pavement is uneven making it prone for accidents to the citizens',
    image: '/assets/images/image7.png',
    rate: true,
  ),
);

Widget HistoryTab() => ListView.builder(
  padding: EdgeInsets.all(ScreenUtil().setSp(15)),
  itemCount: 1,
  itemBuilder: (context, index) => 
  PostCard(
    reportNumber: '2',
    classification: 'Dim Street Lamp',
    location: '1110 Lacson St.',
    status: 'Rated', 
    date: '2/29/2025',
    username: '@juan_dcruz',
    description: 'The lamp in this street is always dim, it seems that it has been a while since it was last replaced',
    image: '/assets/images/image8.png',
  ),
);
