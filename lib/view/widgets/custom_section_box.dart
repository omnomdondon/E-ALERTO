import 'package:e_alerto/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSectionBox extends StatelessWidget {
  final List<PostCard> reports;
  final String selectedStatus;
  final String? imagePath; // Made optional

  const CustomSectionBox({
    super.key,
    required this.reports,
    required this.selectedStatus,
    this.imagePath,
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

    return Column(
      children: [
        if (imagePath != null)
          Container(
            height: ScreenUtil().setHeight(120),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              image: DecorationImage(
                image: AssetImage(imagePath!),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
              alignment: Alignment.bottomLeft,
              child: Text(
                selectedStatus,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(24),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        Expanded(
          child: ListView.separated(
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
          ),
        ),
      ],
    );
  }
}

class StatusBox extends StatelessWidget {
  final String title;
  final Color color;
  final Widget screen;
  final String? imagePath;

  const StatusBox({
    super.key,
    required this.title,
    required this.color,
    required this.screen,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    IconData statusIcon;
    switch (title.toLowerCase()) {
      case 'submitted':
        statusIcon = Icons.assignment_late;
        break;
      case 'resolved':
        statusIcon = Icons.check_circle_outline;
        break;
      case 'in progress':
        statusIcon = Icons.hourglass_empty;
        break;
      case 'accepted':
        statusIcon = Icons.check_circle;
        break;
      default:
        statusIcon = Icons.report_problem;
    }

    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      child: Container(
        margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(12)),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(ScreenUtil().radius(16)),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          children: [
            if (imagePath != null)
              Container(
                height: ScreenUtil().setHeight(100),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  image: DecorationImage(
                    image: AssetImage(imagePath!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(18),
                horizontal: ScreenUtil().setWidth(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    statusIcon,
                    color: color,
                    size: ScreenUtil().setSp(22),
                  ),
                  SizedBox(width: ScreenUtil().setWidth(12)),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(18),
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}