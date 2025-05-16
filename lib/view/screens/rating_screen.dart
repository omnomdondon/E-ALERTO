import 'dart:convert';
import 'package:e_alerto/constants.dart';
import 'package:e_alerto/view/widgets/custom_filledbutton.dart';
import 'package:e_alerto/view/widgets/custom_textarea.dart';
import 'package:e_alerto/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/api.dart';

class RatingScreen extends StatefulWidget {
  final String reportNumber;
  final String classification;
  final String location;
  final String status;
  final String date;
  final String username;
  final String description;
  final String? image;
  final int initialUpVotes;
  final int initialDownVotes;
  final bool rate;

  const RatingScreen({
    super.key,
    required this.reportNumber,
    required this.classification,
    required this.location,
    required this.status,
    required this.date,
    required this.username,
    required this.description,
    this.rate = false,
    this.image,
    this.initialUpVotes = 0,
    this.initialDownVotes = 0,
    required Map<String, dynamic> extra,
  });

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  TextEditingController descriptionController = TextEditingController();
  double overallQuality = 0;
  double serviceQuality = 0;
  double speedQuality = 0;

  // Method to get the auth token from SharedPreferences
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs
        .getString('token'); // Assuming the token is stored under 'token'
  }

  // Method to submit the rating
  Future<void> submitRating() async {
    final token = await _getAuthToken();
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to submit your rating.')),
      );
      return;
    }

    if (overallQuality < 1 || serviceQuality < 1 || speedQuality < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all rating fields.')),
      );
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback cannot be empty.')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/submit-rating'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'reportID': widget.reportNumber,
        'overall': overallQuality.toInt(),
        'service': serviceQuality.toInt(),
        'speed': speedQuality.toInt(),
        'feedback': descriptionController.text.trim(),
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thank you for your feedback!')),
      );

      // ✅ Force refresh by popping to root and going home
      context.goNamed('home'); // Ensures full rebuild of HomeScreen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit rating: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGridFsId = widget.image != null &&
        RegExp(r'^[a-f\d]{24}$').hasMatch(widget.image!);
    final imageUrl =
        isGridFsId ? "$baseUrl/image/${widget.image}" : (widget.image ?? '');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rating'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 5,
            decoration: const BoxDecoration(
              color: COLOR_PRIMARY,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => GoRouter.of(context).pop(),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ScreenUtil().setSp(15)),
          child: Column(
            children: [
              PostCard(
                reportNumber: widget.reportNumber,
                classification: widget.classification,
                location: widget.location,
                status: widget.status,
                date: widget.date,
                username: widget.username,
                description: widget.description,
                image: imageUrl,
              ),
              SizedBox(height: 20.h),
              Form(
                child: Column(
                  children: [
                    _buildRatingRow('Overall Quality', overallQuality,
                        (rating) {
                      setState(() => overallQuality = rating);
                    }),
                    _buildRatingRow('Quality of Service', serviceQuality,
                        (rating) {
                      setState(() => serviceQuality = rating);
                    }),
                    _buildRatingRow('Quality of Speed', speedQuality, (rating) {
                      setState(() => speedQuality = rating);
                    }),
                    SizedBox(height: 20.h),
                    const Text(
                      "Description",
                      style: TextStyle(color: Colors.black54),
                    ),
                    SizedBox(height: 10.h),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 150.h,
                      ),
                      child: CustomTextArea(
                        controller: descriptionController,
                        hintText: "Write your feedback here...",
                        maxLines: 4,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    CustomFilledButton(
                      text: 'Submit',
                      onPressed: submitRating, // Use submitRating here
                      fullWidth: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingRow(
      String label, double rating, Function(double) onRatingUpdate) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          RatingBar.builder(
            initialRating: rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 25.w,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.w),
            itemBuilder: (context, _) =>
                const Icon(Icons.star, color: COLOR_INPROGRESS),
            onRatingUpdate: onRatingUpdate,
          ),
        ],
      ),
    );
  }
}
