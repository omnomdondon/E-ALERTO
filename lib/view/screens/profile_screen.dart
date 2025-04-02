could you add a validation where if a user attempts to register an existing credential (or registers using google) they will be told that there is already an existing credential?

profile_screen.dart:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_alerto/constants.dart';
import 'package:e_alerto/controller/routes.dart';
import 'package:e_alerto/view/widgets/custom_filledbutton.dart';
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
  final User? user = FirebaseAuth.instance.currentUser;
  bool isEmailVerified = false;
  bool isVerificationInProgress = false;
  bool showVerificationSuccessMessage = false;
  bool isGoogleUser = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await user?.reload();
    setState(() {
      isEmailVerified = user?.emailVerified ?? false;
      isGoogleUser = user?.providerData
              .any((userInfo) => userInfo.providerId == 'google.com') ??
          false;
    });
  }

  Future<void> sendVerificationEmail() async {
    if (user == null) return;

    setState(() {
      isVerificationInProgress = true;
    });

    try {
      await user!.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification email sent! Please check your inbox.'),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending verification email: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        isVerificationInProgress = false;
      });
    }
  }

  Future<void> checkEmailVerification() async {
    if (user == null) return;

    setState(() {
      isVerificationInProgress = true;
    });

    try {
      await user!.reload();
      final updatedUser = FirebaseAuth.instance.currentUser;
      final verified = updatedUser?.emailVerified ?? false;

      setState(() {
        isEmailVerified = verified;
        if (verified) {
          showVerificationSuccessMessage = true;
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                showVerificationSuccessMessage = false;
              });
            }
          });
        }
      });

      if (!verified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email not yet verified. Please check your inbox.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error checking verification status: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        isVerificationInProgress = false;
      });
    }
  }

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
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      child: isGoogleUser && user?.photoURL != null
                          ? ClipOval(
                              child: Image.network(
                                user!.photoURL!,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.white,
                            ),
                    ),
                    SizedBox(width: ScreenUtil().setWidth(20)),
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                isGoogleUser
                                    ? user?.displayName ?? 'Google User'
                                    : '@${user?.email?.split('@')[0] ?? "user"}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (isEmailVerified)
                                const Padding(
                                  padding: EdgeInsets.only(left: 4.0),
                                  child: Icon(
                                    Icons.verified,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    )
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
          body: Column(
            children: [
              if (!isGoogleUser && !isEmailVerified)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Your email is not verified. Please verify to access all features.',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      CustomFilledButton(
                        text: 'Send Verification Email',
                        onPressed: isVerificationInProgress
                            ? null
                            : sendVerificationEmail,
                        fullWidth: true,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.email_outlined, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Send Verification Email',
                              style: TextStyle(
                                fontSize: 16,
                                color: isVerificationInProgress
                                    ? Colors.grey
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      CustomFilledButton(
                        text: 'Check Verification Status',
                        onPressed: isVerificationInProgress
                            ? null
                            : checkEmailVerification,
                        fullWidth: true,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.refresh, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Check Verification Status',
                              style: TextStyle(
                                fontSize: 16,
                                color: isVerificationInProgress
                                    ? Colors.grey
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isVerificationInProgress)
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              if (showVerificationSuccessMessage)
                Container(
                  color: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Email Verified Successfully!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              const Expanded(
                child: TabBarView(
                  children: [
                    MyReportsTab(),
                    ToRateTab(),
                    HistoryTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
          reportNumber: '2',
          classification: 'Deteriorated Parking',
          location: '106 Mendiola St.',
          status: 'In Progress',
          date: '3/1/2025',
          username: '@juan_dcruz',
          description:
              'The surface of the public parking lot on 106 Mendiola Street is severely deteriorated, with large potholes and uneven surfaces.',
          image: '/assets/images/image2.png',
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
          classification: 'Uneven Pavement',
          location: '128 Panay Ave. QC',
          status: 'Resolved',
          date: '2/2/2025',
          username: '@juan_dcruz',
          description:
              'The surface of this pavement is uneven making it prone for accidents to the citizens',
          image: '/assets/images/image7.png',
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
          reportNumber: '2',
          classification: 'Dim Street Lamp',
          location: '1110 Lacson St.',
          status: 'Rated',
          date: '2/29/2025',
          username: '@juan_dcruz',
          description:
              'The lamp in this street is always dim, it seems that it has been a while since it was last replaced',
          image: '/assets/images/image8.png',
        ),
      ],
    );
  }
}