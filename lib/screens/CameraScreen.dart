// ignore: file_names
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gardengru/services/gemini_api_service.dart';
import 'dart:io';
import 'package:location/location.dart';
import 'package:gardengru/services/location_services.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});


  @override
  State<CameraScreen> createState() => _CameraScreenState();
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

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _geminiApiService = GeminiApiService();
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

  void _showResponseDialog(String response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('API Response'),
          content: Text(response),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      final File imageFile = File(image.path);
      setState(() {});

      // Resmi işledikten sonra API'ye gönderin
      try {
       

        locationData = await locationService.getCurrentLocation();
        final prompt =
            "Bu fotoğraf bir toprak resmi ise türünü tahmin ederek en iyi hangi bitkilerin yetişeceğini açıkla. Aynı zamanda bu fotoğraf sırasıyla latitude ve longitude bilgileri " +
                locationData.latitude.toString() +
                " " +
                locationData.longitude.toString() +
                " olan bir konuma ait. Fotoğraf toprak fotoğrafı değil ise bunu belirt ve sadece lokasyona dayalı bilgi ver. Eğer fotoğraf ve lokasyon birlikte işine yarıyorsa bunu da belirterek cevap ver. Ve lokasyonu da cevabına ekle";
        final response = await _geminiApiService
            .generateContentWithImages(prompt, [imageFile]);
        print('API Response: $response');

        _showResponseDialog(response);
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
          Positioned(
            top: 30,
            left: 15,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          Positioned(
            bottom: 20,
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
                      // Resmi işledikten sonra API'ye gönderin
                      try {
                        locationData =
                            await locationService.getCurrentLocation();
                        final prompt =
                            "Bu fotoğraf bir toprak resmi ise türünü tahmin ederek en iyi hangi bitkilerin yetişeceğini açıkla. Aynı zamanda bu fotoğraf sırasıyla latitude ve longitude bilgileri " +
                                locationData.latitude.toString() +
                                " " +
                                locationData.longitude.toString() +
                                " olan bir konuma ait. Fotoğraf toprak fotoğrafı değil ise bunu belirt ve sadece lokasyona dayalı bilgi ver. Eğer fotoğraf ve lokasyon birlikte işine yarıyorsa bunu da belirterek cevap ver. Ve lokasyonu da cevabına ekle";
                        final response = await _geminiApiService
                            .generateContentWithImages(prompt, [imageFile]);
                        print('API Response: $response');
                        _showResponseDialog(response);
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
