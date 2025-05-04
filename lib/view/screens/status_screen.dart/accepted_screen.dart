import 'package:e_alerto/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AcceptedScreen extends StatelessWidget {
  final List<PostCard> reports;

  const AcceptedScreen({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accepted'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: reports.isEmpty
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
              itemCount: reports.length,
              itemBuilder: (context, index) => reports[index],
            ),
    );
  }
}
