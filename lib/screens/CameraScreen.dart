// ignore: file_names
import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:gardengru/data/UserDataProvider.dart';
import 'package:gardengru/data/dataModels/SavedModel.dart';
import 'package:gardengru/screens/HomeScreen.dart';
import 'package:gardengru/screens/ResultTestScreen.dart';
import 'package:gardengru/services/gemini_api_service.dart';
import 'dart:io';
import 'package:location/location.dart';
import 'package:gardengru/services/location_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}
Future<File> createTemporaryTextFile(String text) async {
  final Directory tempDir = await getTemporaryDirectory();
  final String tempPath = tempDir.path;
  final File tempFile = File('$tempPath/tempfile.txt');
  await tempFile.writeAsString(text);
  return tempFile;
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  String? _error;
  late GeminiApiService _geminiApiService;
  LocationService locationService = LocationService();
  late LocationData locationData;
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _geminiApiService = GeminiApiService();
  }


  Future<SavedModel> initSavedModelForResultScreen(File image) async {
    locationData = await locationService.getCurrentLocation();

    SavedModel savedModel = SavedModel();
    savedModel.createdAt = Timestamp.now();
    final response = await _geminiApiService.generateContentWithImages([image], locationData);

    savedModel.image = image;
    savedModel.text = response;
    return savedModel;
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _controller = CameraController(
          _cameras![0], // İlk kullanılabilir kamerayı kullan
          ResolutionPreset.high,
        );
        await _controller!.initialize();
        if (!mounted) return;
        setState(() {
          _isCameraInitialized = true;
        });
      } else {
        setState(() {
          _error = 'No cameras available';
        });
      }
    } catch (e) {
      print('Camera initialization error: $e');
      setState(() {
        _error = 'Camera initialization error: $e';
      });
    }
  }

  Future<void> navigateToResultScreenWithData(File img) async {
    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      SavedModel savedModel = await initSavedModelForResultScreen(img);
      String title = await _geminiApiService.generateTitle(savedModel
          .text!);
      if (savedModel.text != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultTestScreen(

              savedModel: savedModel,
              title: title,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      final File imageFile = File(image.path);
      setState(() {});
      try {
        await navigateToResultScreenWithData(imageFile);
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        body: Center(child: Text(_error!)),
      );
    }

    if (!_isCameraInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: CameraPreview(_controller!),
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),

          Positioned(
            bottom: MediaQuery.of(context).size.width * 0.2,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    if (_controller != null &&
                        _controller!.value.isInitialized) {
                      final image = await _controller!.takePicture();
                      final imageFile = File(image.path);
                      setState(() {});
                      try {
                        await navigateToResultScreenWithData(imageFile);
                      } catch (e) {
                        print('Error: $e');
                      }
                    }
                  },
                  icon: Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.width * 0.15,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: _pickImageFromGallery,
                  icon: Container(
                    width: MediaQuery.of(context).size.width * 0.15,
                    height: MediaQuery.of(context).size.width * 0.15,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: const Icon(Icons.photo, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
