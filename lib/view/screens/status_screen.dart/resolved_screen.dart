import 'package:e_alerto/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResolvedScreen extends StatelessWidget {
  final List<PostCard> reports;

  const ResolvedScreen({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    final resolvedReports = reports
        .where((report) => (report.status.toLowerCase() ?? '') == 'resolved')
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: resolvedReports.isEmpty
          ? Center(
              child: Text(
                'No resolved reports',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(ScreenUtil().setSp(15)),
              itemCount: resolvedReports.length,
              itemBuilder: (context, index) => resolvedReports[index],
            ),
    );
  }
}