import 'package:e_alerto/constants.dart';
import 'package:e_alerto/view/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// TODO: FIX ERROR IN BUILDING STATE, NAG-EERROR KAPAG LUMIPAT NG PAGE WHILE SWIPING SA TABVIEW, BASTA YON
class NotificationScreen extends StatefulWidget {
  NotificationScreen({super.key});

  @override 
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) => DefaultTabController( // ✅ Wrap with DefaultTabController
        length: 2, // ✅ Set the number of tabs
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Notification'),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            bottom: const TabBar( // ✅ Move TabBar to AppBar's bottom
              indicatorColor: COLOR_PRIMARY,
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor: Colors.black54,
              indicator: BoxDecoration(
                color: COLOR_SECONDARY,
                border: Border(
                  bottom: BorderSide(color: COLOR_PRIMARY, width: 1), // ✅ Visible indicator line
                ),
              ),
              labelColor: COLOR_PRIMARY,
              tabs: [
                Tab(
                  child: Text(
                    'Unread',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    'Read',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          body: TabBarView( // ✅ Place inside the body
            children: [
              ListView(
                children: [
                  NotificationCard(
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
              ),
              ListView(
                children: [
                  NotificationCard(
                    reportNumber: '1',
                    classification: 'Classification',
                    location: 'Location',
                    status: 'Accepted',
                    date: '01/01/2025',
                    username: 'username',
                    description:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
                  ),
                  NotificationCard(
                    reportNumber: '1',
                    classification: 'Classification',
                    location: 'Location',
                    status: 'Submitted',
                    date: '01/01/2025',
                    username: 'username',
                    description:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
                  ),
                  NotificationCard(
                    reportNumber: '1',
                    classification: 'Classification',
                    location: 'Location',
                    status: 'Resolved',
                    date: '01/01/2025',
                    username: 'username',
                    description:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
                  ),
                  NotificationCard(
                    reportNumber: '1',
                    classification: 'Classification',
                    location: 'Location',
                    status: 'Resolved',
                    date: '01/01/2025',
                    username: 'username',
                    description:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
                  ),
                  NotificationCard(
                    reportNumber: '1',
                    classification: 'Classification',
                    location: 'Location',
                    status: 'Resolved',
                    date: '01/01/2025',
                    username: 'username',
                    description:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
                  ),
                  NotificationCard(
                    reportNumber: '1',
                    classification: 'Classification',
                    location: 'Location',
                    status: 'Resolved',
                    date: '01/01/2025',
                    username: 'username',
                    description:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
                  ),
                  NotificationCard(
                    reportNumber: '1',
                    classification: 'Classification',
                    location: 'Location',
                    status: 'Resolved',
                    date: '01/01/2025',
                    username: 'username',
                    description:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua',
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
