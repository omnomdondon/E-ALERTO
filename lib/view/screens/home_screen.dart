import 'dart:convert';
import 'package:e_alerto/constants.dart';
import 'package:e_alerto/view/screens/status_screen.dart/accepted_screen.dart';
import 'package:e_alerto/view/screens/status_screen.dart/in_progress_screen.dart';
import 'package:e_alerto/view/screens/status_screen.dart/resolved_screen.dart';
import 'package:e_alerto/view/screens/status_screen.dart/submitted__screen.dart';
import 'package:e_alerto/view/widgets/custom_section_box.dart';
import 'package:e_alerto/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant/api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PostCard> submitted = [];
  List<PostCard> accepted = [];
  List<PostCard> inProgress = [];
  List<PostCard> resolved = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  String formatDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat('MM/dd/yyyy').format(date);
    } catch (_) {
      return rawDate;
    }
  }

  Future<void> fetchReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print("Token is null, please log in.");
        return;
      }

      // Inside fetchReports():
      final uri = Uri.parse("$baseUrl/reports/cached");
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("📦 Response data: $data");

        if (data['success'] == true && data['reports'] is List) {
          final reports = List<Map<String, dynamic>>.from(data['reports']);

          List<PostCard> buildCards(String status) {
            return reports
                .where((r) =>
                    (r['status']?.toString().toLowerCase() ?? '') ==
                    status.toLowerCase())
                .map((r) {
              final imageUrl = "$baseUrl/image/${r['image_file']}";

              return PostCard(
                reportNumber: r['reportID'] ?? '',
                classification: r['classification'] ?? '',
                location: r['location'] ?? '',
                status: r['status'] ?? '',
                date: formatDate(r['timestamp'] ?? ''),
                username: r['username'] ?? '',
                description: r['description'] ?? '',
                image: imageUrl,
              );
            }).toList();
          }

          setState(() {
            submitted = buildCards('Submitted');
            accepted = buildCards('Accepted');
            inProgress = buildCards('In Progress');
            resolved = buildCards('Resolved');
            isLoading = false;
          });
        } else {
          print("⚠️ Unexpected data format or success=false: $data");
          setState(() => isLoading = false);
        }
      } else {
        print("❌ Failed to load reports: ${response.body}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching reports: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchReports,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(ScreenUtil().setSp(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    StatusBox(
                      title: 'Submitted',
                      color: COLOR_SUBMITTED,
                      screen: SubmittedScreen(reports: submitted),
                      imagePath:
                          'assets/images/section_boxes_images/submitted.jpg',
                    ),
                    StatusBox(
                      title: 'Accepted',
                      color: COLOR_ACCEPTED,
                      screen: AcceptedScreen(reports: accepted),
                      imagePath:
                          'assets/images/section_boxes_images/accepted.jpg',
                    ),
                    StatusBox(
                      title: 'In Progress',
                      color: COLOR_INPROGRESS,
                      screen: InProgressScreen(reports: inProgress),
                      imagePath:
                          'assets/images/section_boxes_images/in_progress.jpg',
                    ),
                    StatusBox(
                      title: 'Resolved',
                      color: COLOR_RESOLVED,
                      screen: ResolvedScreen(reports: resolved),
                      imagePath:
                          'assets/images/section_boxes_images/resolved.jpg',
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}