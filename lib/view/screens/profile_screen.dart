import 'dart:convert';
import 'package:e_alerto/constants.dart';
import 'package:e_alerto/controller/routes.dart';
import 'package:e_alerto/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = 'Loading...';
  String email = '';
  String phone = '';
  bool verified = false;
  List<dynamic> allReports = [];

  @override
  void initState() {
    super.initState();
    _fetchUserProfileAndReports();
  }

  Future<void> _fetchUserProfileAndReports() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return;

    // Get profile
    final profileRes = await http.get(
      Uri.parse('${const String.fromEnvironment('BASE_URL')}/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (profileRes.statusCode == 200) {
      final data = jsonDecode(profileRes.body);
      setState(() {
        username = data['username'];
        email = data['email'];
        phone = data['phone'];
        verified = data['verified'];
      });
    }

    // Get reports
    final reportsRes = await http.get(
      Uri.parse('${const String.fromEnvironment('BASE_URL')}/reports'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (reportsRes.statusCode == 200) {
      final data = jsonDecode(reportsRes.body);
      setState(() {
        allReports = data['reports'];
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
                        child:
                            Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      SizedBox(width: ScreenUtil().setWidth(20)),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    '@$username',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                if (verified)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 6),
                                    child: Icon(Icons.verified,
                                        color: Colors.green, size: 18),
                                  ),
                              ],
                            ),
                            const Text('Edit Profile',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black87)),
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
                MyReportsTab(
                  username: username,
                  reports: allReports
                      .where((r) => r['username'] == username)
                      .toList(),
                ),
                ToRateTab(
                  username: username,
                  reports: allReports.where((r) {
                    return r['username'] == username &&
                        r['status'] == 'Resolved';
                  }).toList(),
                ),
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
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      Container(color: Colors.grey.shade100, child: tabBar);
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class MyReportsTab extends StatelessWidget {
  final String username;
  final List<dynamic> reports;
  const MyReportsTab(
      {super.key, required this.username, required this.reports});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(ScreenUtil().setSp(15)),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final r = reports[index];
        return PostCard(
          reportNumber: r['reportID'],
          classification: r['classification'],
          location: r['location'],
          status: r['status'],
          date: r['timestamp'].toString().split('T')[0],
          username: '@$username',
          description: r['description'] ?? '',
          image: r['image_file'] ?? '',
        );
      },
    );
  }
}

class ToRateTab extends StatelessWidget {
  final String username;
  final List<dynamic> reports;
  const ToRateTab({super.key, required this.username, required this.reports});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(ScreenUtil().setSp(15)),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final r = reports[index];
        return PostCard(
          rate: true,
          reportNumber: r['reportID'],
          classification: r['classification'],
          location: r['location'],
          status: r['status'],
          date: r['timestamp'].toString().split('T')[0],
          username: '@$username',
          description: r['description'] ?? '',
          image: r['image_file'] ?? '',
        );
      },
    );
  }
}

class HistoryTab extends StatelessWidget {
  final String username;
  const HistoryTab({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("History view coming soon...",
          style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
    );
  }
}
