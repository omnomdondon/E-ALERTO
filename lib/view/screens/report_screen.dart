import 'dart:io';
import 'package:e_alerto/constants.dart';
import 'package:e_alerto/controller/routes.dart';
import 'package:e_alerto/view/widgets/custom_dropdownmenu.dart';
import 'package:e_alerto/view/widgets/custom_filledbutton.dart';
import 'package:e_alerto/view/widgets/custom_radiobutton.dart';
import 'package:e_alerto/view/widgets/custom_textarea.dart';
import 'package:e_alerto/view/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ReportScreen extends StatefulWidget {
  final String? imagePath;
  const ReportScreen({super.key, this.imagePath});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final category = ['Road', 'Foot Bridge', 'Sidewalk', 'Lamp Post'];
  int selectedRadioValue = 1;
  TextEditingController descriptionController = TextEditingController();
  FocusNode descriptionFocusNode = FocusNode();
  String? _imagePath;
  bool _isImageValid = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _imagePath = widget.imagePath;
    _isImageValid = _imagePath != null && File(_imagePath!).existsSync();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    descriptionFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openCamera() async {
    final result = await context.push<String>(Routes.reportCamera);
    if (result != null && mounted) {
      setState(() {
        _imagePath = result;
        _isImageValid = true;
      });

      // Auto-scroll and focus after insertion
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
        FocusScope.of(context).requestFocus(descriptionFocusNode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.all(ScreenUtil().setSp(15)),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Classification",
                  style: TextStyle(color: Colors.black54)),
              SizedBox(height: ScreenUtil().setHeight(10)),
              CustomDropdown(
                items: category,
                onChanged: (value) {},
                hint: 'Select a category',
              ),
              SizedBox(height: ScreenUtil().setHeight(15)),
              const Text("Location", style: TextStyle(color: Colors.black54)),
              SizedBox(height: ScreenUtil().setHeight(10)),
              const CustomTextFormField(
                label: 'Location',
                hintText: 'Enter location',
              ),
              SizedBox(height: ScreenUtil().setHeight(15)),
              const Text("Distance", style: TextStyle(color: Colors.black54)),
              SizedBox(height: ScreenUtil().setHeight(10)),
              const CustomTextFormField(
                label: 'Distance',
                hintText: 'Enter distance from location',
              ),
              SizedBox(height: ScreenUtil().setHeight(15)),
              const Text("Severity", style: TextStyle(color: Colors.black54)),
              SizedBox(height: ScreenUtil().setHeight(10)),
              CustomRadiobutton(
                onChanged: (value) {
                  setState(() {
                    selectedRadioValue = value;
                  });
                },
              ),
              SizedBox(height: ScreenUtil().setHeight(15)),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Severity Level $selectedRadioValue',
                      style: const TextStyle(
                          color: COLOR_PRIMARY,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(5)),
                    Text(
                      _getSeverityDescription(selectedRadioValue),
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              const Text("Description",
                  style: TextStyle(color: Colors.black54)),
              SizedBox(height: ScreenUtil().setHeight(10)),
              CustomTextArea(
                controller: descriptionController,
                hintText: "Write your description about the issue here...",
                maxLines: 4,
                // Removed focusNode as CustomTextArea does not support it
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              const Text("Image", style: TextStyle(color: Colors.black54)),
              SizedBox(height: ScreenUtil().setHeight(10)),
              GestureDetector(
                onTap: _openCamera,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      switchInCurve: Curves.easeOutBack,
                      child: _buildImageWidget(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              CustomFilledButton(
                text: 'Submit',
                onPressed: () {
                  if (!_isImageValid) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please take a photo first'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }
                  // Handle submission with _imagePath
                },
                fullWidth: true,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    if (_imagePath == null || !File(_imagePath!).existsSync()) {
      return Container(
        key: const ValueKey('placeholder'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
            SizedBox(height: ScreenUtil().setHeight(10)),
            const Text('Tap to take photo',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    return Container(
      key: ValueKey(_imagePath),
      child: Image.file(
        File(_imagePath!),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.3,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 50, color: Colors.red),
        SizedBox(height: ScreenUtil().setHeight(10)),
        const Text('Failed to load image', style: TextStyle(color: Colors.red)),
        SizedBox(height: ScreenUtil().setHeight(10)),
        TextButton(
          onPressed: _openCamera,
          child: const Text('Retake Photo'),
        ),
      ],
    );
  }

  String _getSeverityDescription(int value) {
    switch (value) {
      case 1:
        return "Minimal impact, barely noticeable.";
      case 2:
        return "Minor issue, no major consequences.";
      case 3:
        return "Moderate severity, some disruptions.";
      case 4:
        return "Significant issue, requires attention.";
      case 5:
        return "High severity, potential risk involved.";
      case 6:
        return "Critical condition, urgent action needed.";
      case 7:
        return "Severe emergency, immediate response required!";
      default:
        return "Select a severity level.";
    }
  }
}
