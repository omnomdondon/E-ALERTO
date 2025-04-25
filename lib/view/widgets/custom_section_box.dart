import 'package:e_alerto/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSectionBox extends StatelessWidget {
  final List<PostCard> reports;
  final String selectedStatus;

  const CustomSectionBox({
    super.key,
    required this.reports,
    required this.selectedStatus,
  });

  @override
  Widget build(BuildContext context) {
    final filteredReports = reports
        .where((report) =>
            (report.status.toLowerCase()) == selectedStatus.toLowerCase())
        .toList();

    if (filteredReports.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: ScreenUtil().setSp(40),
              color: Colors.grey.shade400,
            ),
            SizedBox(height: ScreenUtil().setHeight(16)),
            Text(
              'No $selectedStatus reports',
              style: TextStyle(
                fontSize: ScreenUtil().setSp(16),
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.only(
        top: ScreenUtil().setHeight(16),
        bottom: ScreenUtil().setHeight(20),
      ),
      itemCount: filteredReports.length,
      separatorBuilder: (context, index) => Divider(
        height: ScreenUtil().setHeight(1),
        thickness: 0.5,
        color: Colors.grey.shade200,
      ),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(16),
          ),
          child: filteredReports[index],
        );
      },
    );
  }
}

class StatusBox extends StatelessWidget {
  final String title;
  final Color color;
  final Widget screen;

  const StatusBox({
    super.key,
    required this.title,
    required this.color,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      child: Container(
        margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(12)),
        padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(18),
          horizontal: ScreenUtil().setWidth(16),
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(12)),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(18),
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
