import 'package:e_alerto/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubmittedScreen extends StatelessWidget {
  final List<PostCard> reports;

  const SubmittedScreen({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    final submittedReports = reports
        .where((report) => (report.status.toLowerCase() ?? '') == 'submitted')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Submitted'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: submittedReports.isEmpty
          ? Center(
              child: Text(
                'No submitted reports',
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(ScreenUtil().setSp(15)),
              itemCount: submittedReports.length,
              itemBuilder: (context, index) => submittedReports[index],
            ),
    );
  }
}
