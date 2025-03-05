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
                    classification: 'Cracked Bridge',
                    location: 'Binondo-Intramuros Bridge',
                    status: 'Accepted', 
                    date: '1/25/2025',
                    username: '@omnom_alias',
                    description: 'Inspections have revealed significant cracks in the support beams of the Binondo-Intramuros Bridge',
                    image: '/assets/images/image1.png',
                  ),
                ],
              ),
              ListView(
                children: [
                  NotificationCard(
                    reportNumber: '2',
                    classification: 'Deteriorated Parking',
                    location: '106 Mendiola St.',
                    status: 'In Progress', 
                    date: '3/1/2025',
                    username: '@juan_dcruz',
                    description: 'The surface of the public parking lot on 106 Mendiola Street is severely deteriorated, with large potholes and uneven surfaces.',
                    image: '/assets/images/image2.png',
                  ),
                  NotificationCard(
                    reportNumber: '3',
                    classification: 'Sidewalk Damage',
                    location: 'Gerardo Tuazon, Balic Balic',
                    status: 'Submitted', 
                    date: '2/27/2025',
                    username: '@saur_latina',
                    description: 'The sidewalk on Pine Boulevard is cracked and uneven, posing a tripping hazard for pedestrians. Repairs are needed to ensure safe passage.',
                    image: '/assets/images/image3.png',
                  ),
                  NotificationCard(
                    reportNumber: '4',
                    classification: 'Broken Traffic Light',
                    location: 'Taft Avenue',
                    status: 'Resolved', 
                    date: '3/6/2025',
                    username: '@momioni',
                    description: 'Broken traffic light causes traffic at the intersection in Taft Avenue. 4 hours have passed and still no response from LGUs. Traffic enforcers took over to manage the said issue',
                    image: '/assets/images/image4.png',
                  ),
                  NotificationCard(
                    reportNumber: '4',
                    classification: 'Large Pot Hole',
                    location: 'Taft Avenue',
                    status: 'Resolved', 
                    date: '3/6/2025',
                    username: '@momioni',
                    description: 'Broken traffic light causes traffic at the intersection in Taft Avenue. 4 hours have passed and still no response from LGUs. Traffic enforcers took over to manage the said issue',
                    image: '/assets/images/image6.png',
                  ),
                  NotificationCard(
                    reportNumber: '4',
                    classification: 'Broken Bridge',
                    location: 'Taft Avenue',
                    status: 'Denied', 
                    date: '3/6/2025',
                    username: '@momioni',
                    description: 'Broken traffic light causes traffic at the intersection in Taft Avenue. 4 hours have passed and still no response from LGUs. Traffic enforcers took over to manage the said issue',
                    image: '/assets/images/image7.png',
                  ),
                  NotificationCard(
                    reportNumber: '4',
                    classification: 'Fallen Lamp',
                    location: 'Taft Avenue',
                    status: 'Accepted', 
                    date: '3/6/2025',
                    username: '@momioni',
                    description: 'Broken traffic light causes traffic at the intersection in Taft Avenue. 4 hours have passed and still no response from LGUs. Traffic enforcers took over to manage the said issue',
                    image: '/assets/images/image5.png',
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
