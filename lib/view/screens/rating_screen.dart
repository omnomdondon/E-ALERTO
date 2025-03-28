import 'package:e_alerto/constants.dart';
import 'package:e_alerto/view/widgets/custom_filledbutton.dart';
import 'package:e_alerto/view/widgets/custom_textarea.dart';
import 'package:e_alerto/view/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RatingScreen extends StatefulWidget {
  final String reportNumber;
  final String classification;
  final String location;
  final String status;
  final String date;
  final String username;
  final String description;
  final String image;
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
    this.image = '',
    this.initialUpVotes = 0,
    this.initialDownVotes = 0,
  });

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  TextEditingController descriptionController = TextEditingController(); 
  double overallQuality = 0;
  double serviceQuality = 0;
  double speedQuality = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Rating'),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.all(8.0), // Adjust padding as needed
        child: Container(
          width: 5,
          decoration: const BoxDecoration(
            color: COLOR_PRIMARY, // Background color
            shape: BoxShape.circle, // Makes it circular
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white), // Icon color
            onPressed: () {
              GoRouter.of(context).pop();
            },
          ),
        ),
      ),
    ),
    backgroundColor: Colors.white,
    body: ListView(
      padding: EdgeInsets.all(ScreenUtil().setSp(15)),
      children: [
        PostCard(
          reportNumber: widget.reportNumber,
          classification: widget.classification,
          location: widget.location,
          status: widget.status,
          date: widget.date,
          username: widget.username,
          description: widget.description,
          image: widget.image,
        ),

        Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // ✅ Center items
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRatingRow('Overall Quality', overallQuality, (rating) {
                setState(() => overallQuality = rating);
              }),
              _buildRatingRow('Quality of Service', serviceQuality, (rating) {
                setState(() => serviceQuality = rating);
              }),
              _buildRatingRow('Quality of Speed', speedQuality, (rating) {
                setState(() => speedQuality = rating);
              }),
              SizedBox(height: ScreenUtil().setHeight(20)),

              const Text(
                "Description", 
                style: TextStyle(color: Colors.black54)
              ),
              SizedBox(height: ScreenUtil().setHeight(10)),
              CustomTextArea(
                controller: descriptionController,
                hintText: "Write your feedback here...",
                maxLines: 4,
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),

              CustomFilledButton(
                text: 'Submit', 
                onPressed: () => {}, //GoRouter.of(context).go('/home'),
                fullWidth: true,
              ),
              const SizedBox(height: 30),        
            ],
          )
        )

      ]
    )
  );
}

Widget _buildRatingRow(String label, double rating, Function(double) onRatingUpdate) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          RatingBar.builder(
            initialRating: rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 25,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(Icons.star, color: COLOR_INPROGRESS),
            onRatingUpdate: onRatingUpdate,
          ),
        ],
      ),
    );
  }