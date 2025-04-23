import 'package:e_alerto/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InProgressScreen extends StatelessWidget {
  final List<PostCard> reports;

  const InProgressScreen({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    final inProgressReports = reports
        .where(
            (report) => (report.status.toLowerCase() ?? '') == 'in progress')
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: inProgressReports.isEmpty
          ? Center(
              child: Text(
                'No in progress reports',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(ScreenUtil().setSp(15)),
              itemCount: inProgressReports.length,
              itemBuilder: (context, index) => inProgressReports[index],
            ),
    );
  }
}