import 'dart:io';
import 'dart:typed_data';
import 'package:e_alerto/controller/routes.dart';
import 'package:e_alerto/view/widgets/custom_filledbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;

import '../../constant/api.dart';

class ReportScreen extends StatefulWidget {
  final String? imagePath;
  final List<Map<String, dynamic>>? detections;
  final Uint8List? outputImage;
  final Position? location;
  final String? address;

  const ReportScreen({
    super.key,
    this.imagePath,
    this.detections,
    this.outputImage,
    this.location,
    this.address,
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

bool _isSubmitting = false;

class _ReportScreenState extends State<ReportScreen> {
  List<Map<String, dynamic>>? _detections;
  Position? _location;
  String? _address;
  String? _imagePath;
  bool _isImageValid = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController descriptionController = TextEditingController();
  final FocusNode descriptionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _imagePath = widget.imagePath;
    _isImageValid = _imagePath != null;

    final isGridFsId =
        _imagePath != null && RegExp(r'^[a-f\d]{24}$').hasMatch(_imagePath!);

    if (_imagePath != null && !isGridFsId && File(_imagePath!).existsSync()) {
      print("📸 Local Image File: ${File(_imagePath!).uri.pathSegments.last}");
    } else if (isGridFsId) {
      print("📦 Detected GridFS Image ID: $_imagePath");
    }

    _detections = widget.detections;
    _location = widget.location;
    _address = widget.address;

    if (_detections != null && _detections!.isNotEmpty) {
      for (final detection in _detections!) {
        final label = detection['label'];
        final confidence = detection['confidence'];
        print(
            "🏷️ Label: $label | Confidence: ${(confidence * 100).toStringAsFixed(2)}%");
      }
    }

    if (_address != null) {
      print("📍 Address: $_address");
    } else if (_location != null) {
      print("🌐 Coordinates: ${_location!.latitude}, ${_location!.longitude}");
    }
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

  Future<void> _submitReport() async {
    // 🔐 Validate image again
    if (!_isImageValid || _imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please capture an image before submitting.')),
      );
      return;
    }

    // 🚫 Ensure detection results exist
    if (_detections == null ||
        _detections!.isEmpty ||
        _detections![0]['label'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No valid detection found.')),
      );
      return;
    }

    // 📍 Validate location
    if (_address == null && _location == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Location is required. Please allow location access.')),
      );
      return;
    }

    // ✍️ Validate description
    if (descriptionController.text.trim().isEmpty) {
      FocusScope.of(context).requestFocus(descriptionFocusNode);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Description cannot be empty.')),
      );
      return;
    }

    final uri = Uri.parse("$baseUrl/reports");
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('You must be logged in to submit a report.')),
        );
        return;
      }

      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      // 🖼️ Image handling stays the same...
      if (_imagePath!.startsWith('http')) {
        final response = await http.get(Uri.parse(_imagePath!));
        final decodedImage = img.decodeImage(response.bodyBytes);
        if (decodedImage == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid image format')),
          );
          return;
        }
        final jpegBytes = img.encodeJpg(decodedImage);
        request.files.add(http.MultipartFile.fromBytes(
          'image_file',
          jpegBytes,
          filename: 'image.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));
      } else if (RegExp(r'^[a-f\d]{24}$').hasMatch(_imagePath!)) {
        request.fields['image_file'] = _imagePath!;
      } else {
        final file = File(_imagePath!);
        if (!await file.exists()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image file not found')),
          );
          return;
        }

        final rawBytes = await file.readAsBytes();
        final decodedImage = img.decodeImage(rawBytes);
        if (decodedImage == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid image format')),
          );
          return;
        }

        final jpegBytes = img.encodeJpg(decodedImage);
        request.files.add(http.MultipartFile.fromBytes(
          'image_file',
          jpegBytes,
          filename: 'image.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      // 📤 Fill out remaining fields
      request.fields['classification'] = _detections![0]['label'];
      request.fields['measurement'] = 'No measurements';
      request.fields['location'] =
          _address ?? "${_location!.latitude}, ${_location!.longitude}";
      request.fields['timestamp'] = DateTime.now().toIso8601String();
      request.fields['description'] = descriptionController.text.trim();

      final response = await request.send();

      if (response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report submitted successfully!')),
        );
        context.go(Routes.homePage);
      } else {
        final responseBody = await response.stream.bytesToString();
        print('❌ Failed to submit: ${response.reasonPhrase}');
        print(responseBody);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to submit report. Please try again.')),
        );
      }
    } catch (e) {
      print("🚨 Submission error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
              const Text("Image", style: TextStyle(color: Colors.black54)),
              SizedBox(height: 10.h),
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
                      child: _buildImageWidget(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              const Text("Classification",
                  style: TextStyle(color: Colors.black54)),
              if (_detections != null && _detections!.isNotEmpty)
                ..._detections!.map((d) => Text(
                      "${d['label']} (${((d['confidence'] ?? 0) * 100).toStringAsFixed(1)}%)",
                      style: const TextStyle(color: Colors.black87),
                    ))
              else
                const Text("No detections found",
                    style: TextStyle(color: Colors.black54)),
              SizedBox(height: 10.h),
              const Text("Location", style: TextStyle(color: Colors.black54)),
              Text(
                _address ??
                    (_location != null
                        ? "${_location!.latitude}, ${_location!.longitude}"
                        : "Location not found"),
                style: const TextStyle(color: Colors.black87),
              ),
              SizedBox(height: 15.h),
              const Text("Measurement",
                  style: TextStyle(color: Colors.black54)),
              const Text("No measurements found",
                  style: TextStyle(color: Colors.black87)),
              SizedBox(height: 15.h),
              const Text("Description",
                  style: TextStyle(color: Colors.black54)),
              TextFormField(
                controller: descriptionController,
                focusNode: descriptionFocusNode,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Describe the issue here...',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.h),
              CustomFilledButton(
                text: 'Submit',
                onPressed: () async {
                  if (_isSubmitting) return;

                  if (!_isImageValid) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please take a photo first')),
                    );
                    return;
                  }

                  setState(() => _isSubmitting = true);
                  await _submitReport();
                  if (mounted) setState(() => _isSubmitting = false);
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
    if (_imagePath != null) {
      final isGridFsId = RegExp(r'^[a-f\d]{24}$').hasMatch(_imagePath!);

      if (isGridFsId) {
        final imageUrl = "$baseUrl/image/${_imagePath!}";
        print("🖼️ Image preview URL (GridFS): $imageUrl");

        return Image.network(
          imageUrl,
          key: ValueKey(imageUrl),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.3,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildErrorWidget(),
        );
      }

      print("⚠️ Not a valid GridFS ID, skipping preview.");
    }

    return _buildErrorWidget();
  }

  Widget _buildErrorWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 50, color: Colors.red),
        const SizedBox(height: 10),
        const Text('Failed to load image', style: TextStyle(color: Colors.red)),
        const SizedBox(height: 10),
        TextButton(onPressed: _openCamera, child: const Text('Retake Photo')),
      ],
    );
  }
}
