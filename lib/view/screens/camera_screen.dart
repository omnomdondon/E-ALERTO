import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isLoading = true;
  bool _isCameraReady = false;
  bool _isFlashOn = false;
  int _selectedCameraIndex = 0;
  List<CameraDescription>? _cameras;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCamera();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      _controller = CameraController(
        _cameras![_selectedCameraIndex],
        ResolutionPreset.high,
        enableAudio: false,
      );

      _initializeControllerFuture = _controller.initialize();
      await _initializeControllerFuture;

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isCameraReady = true;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to initialize camera')),
        );
      }
    }
  }

  Future<void> _captureImage() async {
    if (_isTakingPicture || !_isCameraReady) return;

    setState(() => _isTakingPicture = true);

    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();

      if (!mounted) return;
      Navigator.of(context).pop(image.path);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to take picture')),
      );
    } finally {
      if (mounted) {
        setState(() => _isTakingPicture = false);
      }
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2 || _isTakingPicture) return;

    setState(() {
      _isCameraReady = false;
      _selectedCameraIndex = _selectedCameraIndex == 0 ? 1 : 0;
    });

    await _controller.dispose();
    await _initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                if (_isCameraReady)
                  SizedBox.expand(
                    child: CameraPreview(_controller),
                  ),
                Positioned(
                  bottom: ScreenUtil().setHeight(40),
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _isTakingPicture
                        ? const CircularProgressIndicator()
                        : GestureDetector(
                            onTap: _captureImage,
                            child: Container(
                              width: ScreenUtil().setWidth(70),
                              height: ScreenUtil().setWidth(70),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                Positioned(
                  top: ScreenUtil().setHeight(40),
                  left: ScreenUtil().setWidth(15),
                  child: IconButton(
                    icon:
                        const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: _isTakingPicture
                        ? null
                        : () => Navigator.of(context).pop(),
                  ),
                ),
                Positioned(
                  top: ScreenUtil().setHeight(40),
                  right: ScreenUtil().setWidth(15),
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isFlashOn ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: _isTakingPicture
                            ? null
                            : () {
                                if (_isCameraReady) {
                                  setState(() => _isFlashOn = !_isFlashOn);
                                  _controller.setFlashMode(
                                    _isFlashOn
                                        ? FlashMode.torch
                                        : FlashMode.off,
                                  );
                                }
                              },
                      ),
                      if (_cameras != null && _cameras!.length > 1)
                        SizedBox(height: ScreenUtil().setHeight(20)),
                      if (_cameras != null && _cameras!.length > 1)
                        IconButton(
                          icon: const Icon(Icons.cameraswitch,
                              color: Colors.white, size: 30),
                          onPressed: _isTakingPicture ? null : _switchCamera,
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}