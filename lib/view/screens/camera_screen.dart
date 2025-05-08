import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';


class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _capturedImage;
  List<Map<String, dynamic>> detections = [];
  bool isLoading = false;
  Uint8List? outputImage;

  @override
  void initState() {
    super.initState();
    _openCameraAndCapture();
  }

  Future<void> _openCameraAndCapture() async {
    final picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _capturedImage = File(pickedImage.path);
        detections = [];
        isLoading = true;
        outputImage = null;
      });

      await _sendToBackend(_capturedImage!);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _sendToBackend(File image) async {
    final uri = Uri.parse('http://192.168.172.89:5000/detect');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    request.headers['Authorization'] = 'Bearer nagkaon_kana_lab';

    try {
      // 🧭 Get Location
      Position? position = await _getCurrentLocation();
      String? address;

      if (position != null) {
        address = await _getAddressFromCoordinates(position.latitude, position.longitude);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        setState(() {
          detections = List<Map<String, dynamic>>.from(json['detections']);
          if (json['image'] != null && json['image'] is String) {
            outputImage = base64Decode(json['image']);
          }
        });

        if (mounted) {
          context.go('/report', extra: {
            'imagePath': _capturedImage!.path,
            'detections': detections,
            'outputImage': outputImage,
            'location': position,
            'address': address,
          });
        }

      } else {
        print('Failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending image: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Position?> _getCurrentLocation() async {
    // 🔐 Request location permission using permission_handler
    final status = await Permission.location.request();

    if (status.isDenied || status.isPermanentlyDenied) {
      print("Location permission denied.");
      return null;
    }

    // 📍 Make sure location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are OFF");
      await Geolocator.openLocationSettings();
      return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String?> _getAddressFromCoordinates(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      }
    } catch (e) {
      print("Error in reverse geocoding: $e");
    }
  return null;
}


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
