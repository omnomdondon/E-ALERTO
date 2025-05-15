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
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:http_parser/http_parser.dart';

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
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final locationStatus = await Permission.location.request();

    if (cameraStatus.isGranted && locationStatus.isGranted) {
      print("Permissions granted!");
      _openCameraAndCapture();
    } else {
      print("Camera/Location permission denied!");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera/Location permission denied!')),
      );
      openAppSettings();
    }
  }

  Future<void> _openCameraAndCapture() async {
    final picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      final file = File(pickedImage.path);
      if (await file.exists()) {
        print("Image Path: ${file.path}");
        setState(() {
          _capturedImage = file;
          detections = [];
          isLoading = true;
          outputImage = null;
        });

        await _sendToBackend(_capturedImage!);
      } else {
        print("Error: Image file doesn't exist at ${pickedImage.path}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image file does not exist.')),
        );
      }
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _sendToBackend(File image) async {
    final uri = Uri.parse('http://192.168.172.89:5000/detect');
    var request = http.MultipartRequest('POST', uri);

    if (await image.exists()) {
      final rawBytes = await image.readAsBytes();
      final decodedImage = img.decodeImage(rawBytes);

      if (decodedImage == null) {
        print("❌ Failed to decode image.");
        return;
      }

      final jpegBytes = img.encodeJpg(decodedImage);

      request.files.add(http.MultipartFile.fromBytes(
        'image',
        jpegBytes,
        filename: 'image.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));
    } else {
      print("Image file not found");
      return;
    }

    request.headers['Authorization'] = 'Bearer nagkaon_kana_lab';

    try {
      Position? position = await _getCurrentLocation();
      String? address;

      if (position != null) {
        address = await _getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        print("🐞 Raw JSON image field: ${json['image']}");

        setState(() {
          detections = List<Map<String, dynamic>>.from(json['detections']);
          if (json['image'] != null && json['image'] is String) {
            final imageId = json['image']; // should be GridFS file ID
            _imagePath = imageId; // GridFS ID only
          }
        });

        if (mounted) {
          context.go('/report', extra: {
            'imagePath': _imagePath,
            'detections': detections,
            'outputImage': null,
            'location': position,
            'address': address,
          });
        }
      } else {
        print('Failed: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to get a valid response from the server.'),
          ),
        );
      }
    } catch (e) {
      print('Error sending image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Position?> _getCurrentLocation() async {
    final status = await Permission.location.request();

    if (status.isDenied || status.isPermanentlyDenied) {
      print("Location permission denied.");
      return null;
    }

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

// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/foundation.dart'; // For Platform checks

// class CameraScreen extends StatefulWidget {
//   const CameraScreen({super.key});

//   @override
//   State<CameraScreen> createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   File? _capturedImage;
//   List<Map<String, dynamic>> detections = [];
//   bool isLoading = false;
//   Uint8List? outputImage;

//   @override
//   void initState() {
//     super.initState();
//     _requestPermissions(); // Request permissions on init
//   }

//   // Request the necessary permissions at runtime
//   Future<void> _requestPermissions() async {
//     // Request camera and location permissions
//     final cameraStatus = await Permission.camera.request();
//     final locationStatus = await Permission.location.request();

//     // Check if camera and location permissions are granted
//     if (cameraStatus.isGranted && locationStatus.isGranted) {
//       print("Permissions granted!");
//       _openCameraAndCapture(); // Open camera if permissions are granted
//     } else {
//       // Handle camera and location permission denials
//       print("Camera/Location permission denied!");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Camera/Location permission denied!')),
//       );
//       openAppSettings(); // Open settings if permissions are permanently denied
//     }
//   }

//   // Capture the image from the camera
//   Future<void> _openCameraAndCapture() async {
//     final picker = ImagePicker();
//     final XFile? pickedImage =
//         await picker.pickImage(source: ImageSource.camera);

//     if (pickedImage != null) {
//       final file = File(pickedImage.path);
//       if (await file.exists()) {
//         print("Image Path: ${file.path}");
//         setState(() {
//           _capturedImage = file;
//           detections = [];
//           isLoading = true;
//           outputImage = null;
//         });

//         await _sendToBackend(_capturedImage!);
//       } else {
//         print("Error: Image file doesn't exist at ${pickedImage.path}");
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Image file does not exist.')),
//         );
//       }
//     } else {
//       Navigator.pop(context);
//     }
//   }

//   // Send the captured image to the backend
//   Future<void> _sendToBackend(File image) async {
//     final uri =
//         Uri.parse('http://192.168.100.121:5000/detect'); // Updated the IP here
//     var request = http.MultipartRequest('POST', uri);
//     // Add the image file
//     if (await image.exists()) {
//       request.files.add(await http.MultipartFile.fromPath('image', image.path));
//     } else {
//       print("Image file not found");
//       return;
//     }

//     request.headers['Authorization'] = 'Bearer nagkaon_kana_lab';

//     try {
//       // 🧭 Get Location
//       Position? position = await _getCurrentLocation();
//       String? address;

//       if (position != null) {
//         address = await _getAddressFromCoordinates(
//             position.latitude, position.longitude);
//       }

//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       if (response.statusCode == 200) {
//         final json = jsonDecode(response.body);

//         setState(() {
//           detections = List<Map<String, dynamic>>.from(json['detections']);
//           if (json['image'] != null && json['image'] is String) {
//             outputImage = base64Decode(json['image']);
//           }
//         });

//         // Wait for the response to finish before navigating
//         if (mounted) {
//           context.go('/report', extra: {
//             'imagePath': _capturedImage!.path,
//             'detections': detections,
//             'outputImage': outputImage,
//             'location': position,
//             'address': address,
//           });
//         }
//       } else {
//         print('Failed: ${response.statusCode}');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text('Failed to get a valid response from the server.')),
//         );
//       }
//     } catch (e) {
//       print('Error sending image: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('An error occurred: $e')),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   // Get the current location
//   Future<Position?> _getCurrentLocation() async {
//     // 🔐 Request location permission using permission_handler
//     final status = await Permission.location.request();

//     if (status.isDenied || status.isPermanentlyDenied) {
//       print("Location permission denied.");
//       return null;
//     }

//     // 📍 Make sure location services are enabled
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       print("Location services are OFF");
//       await Geolocator.openLocationSettings();
//       return null;
//     }

//     return await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//   }

//   // Get the address from the coordinates (reverse geocoding)
//   Future<String?> _getAddressFromCoordinates(double lat, double lon) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
//       if (placemarks.isNotEmpty) {
//         final place = placemarks.first;
//         return "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
//       }
//     } catch (e) {
//       print("Error in reverse geocoding: $e");
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
// }