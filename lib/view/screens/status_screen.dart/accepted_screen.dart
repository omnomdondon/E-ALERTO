import 'package:e_alerto/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AcceptedScreen extends StatelessWidget {
  final List<PostCard> reports;

  const AcceptedScreen({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    final acceptedReports = reports
        .where((report) => (report.status.toLowerCase() ?? '') == 'accepted')
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: acceptedReports.isEmpty
          ? Center(
              child: Text(
                'No accepted reports',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(ScreenUtil().setSp(15)),
              itemCount: acceptedReports.length,
              itemBuilder: (context, index) => acceptedReports[index],
            ),
    );
  }
}