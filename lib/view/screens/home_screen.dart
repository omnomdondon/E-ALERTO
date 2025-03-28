import 'package:e_alerto/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Home'), backgroundColor: Colors.white, surfaceTintColor: Colors.white),
    backgroundColor: Colors.white,
    body: Center(
      child: ListView(
        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
        children: const [
          PostCard(
            reportNumber: '1',
            classification: 'Cracked Bridge',
            location: 'Binondo-Intramuros Bridge',
            status: 'Accepted', 
            date: '1/25/2025',
            username: '@omnom_alias',
            description: 'Inspections have revealed significant cracks in the support beams of the Binondo-Intramuros Bridge',
            image: '/assets/images/image1.png',
          ),
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
            reportNumber: '3',
            classification: 'Sidewalk Damage',
            location: 'Gerardo Tuazon, Balic Balic',
            status: 'Submitted', 
            date: '2/27/2025',
            username: '@saur_latina',
            description: 'The sidewalk on Pine Boulevard is cracked and uneven, posing a tripping hazard for pedestrians. Repairs are needed to ensure safe passage.',
            image: '/assets/images/image3.png',
          ),
          PostCard(
            reportNumber: '4',
            classification: 'Broken Traffic Light',
            location: 'Taft Avenue',
            status: 'Resolved', 
            date: '3/6/2025',
            username: '@momioni',
            description: 'Broken traffic light causes traffic at the intersection in Taft Avenue. 4 hours have passed and still no response from LGUs. Traffic enforcers took over to manage the said issue',
            image: '/assets/images/image4.png',
          ),
        ],
      ),
    ),
  );
}