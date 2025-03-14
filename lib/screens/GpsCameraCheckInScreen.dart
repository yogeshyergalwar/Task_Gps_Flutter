import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geocoding/geocoding.dart';

import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:location/location.dart' as loc;

class GpsCameraCheckInScreen extends StatefulWidget {
  @override
  _GpsCameraCheckInScreenState createState() => _GpsCameraCheckInScreenState();
}

class _GpsCameraCheckInScreenState extends State<GpsCameraCheckInScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? cameras;
  String _currentDateTime = "";
  String _currentAddress = "Fetching location...";
  loc.LocationData? _currentLocation;
  final loc.Location _location = loc.Location();
  final LocalAuthentication _localAuth = LocalAuthentication();
  String? _imagePath; // Store captured image path

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndFetchLocation();
    _initializeCamera();
    _currentDateTime = DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now());
    _authenticate();
  }

  Future<void> _authenticate() async {
    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuth.authenticate(
        localizedReason: "Please authenticate to access Attendance Page",
        options: AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print("Authentication Error: $e");
    }
    if (!isAuthenticated) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _checkPermissionsAndFetchLocation() async {
    try {
      bool _serviceEnabled;
      loc.PermissionStatus _permissionGranted;

      await _location.changeSettings(accuracy: loc.LocationAccuracy.high);
      _serviceEnabled = await _location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await _location.requestService();
        if (!_serviceEnabled) return;
      }

      _permissionGranted = await _location.hasPermission();
      if (_permissionGranted == loc.PermissionStatus.denied) {
        _permissionGranted = await _location.requestPermission();
        if (_permissionGranted != loc.PermissionStatus.granted) return;
      }

      _getCurrentLocation();
    } catch (e) {
      print("Error checking permissions: $e");
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      _currentLocation = await _location.getLocation();
      if (_currentLocation != null) {
        _getAddressFromLatLng(
            _currentLocation!.latitude!, _currentLocation!.longitude!);
      }
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            "${place.street}, ${place.subLocality}, ${place.postalCode}";
      });
    } catch (e) {
      print("Error fetching address: $e");
    }
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    CameraDescription? frontCamera = cameras?.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras![0],
    );
    _cameraController =
        CameraController(frontCamera!, ResolutionPreset.ultraHigh);
    await _cameraController!.initialize();
    setState(() {});
  }

  Future<void> _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;
    try {
      final XFile image = await _cameraController!.takePicture();
      setState(() {
        _imagePath = image.path;
      });
    } catch (e) {
      print("Error capturing image: $e");
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          _cameraController != null && _cameraController!.value.isInitialized
              ? SizedBox(
                  width: screenWidth,
                  height: screenHeight,
                  child: CameraPreview(_cameraController!),
                )
              : Center(child: CircularProgressIndicator()),
          Positioned(
            top: screenHeight * 0.05,
            left: screenWidth * 0.05,
            child: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Colors.black87, size: screenWidth * 0.07),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            top: screenHeight * 0.13,
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left Column: Address
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Current Address:",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: MediaQuery.of(context).size.width *
                                0.03, // Responsive font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height *
                                0.005), // Responsive spacing
                        Text(
                          _currentAddress,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width *
                                0.026, // Responsive font size
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Vertical Divider
                  Container(
                    height: MediaQuery.of(context).size.height *
                        0.1, // Responsive height
                    width: MediaQuery.of(context).size.width *
                        0.004, // Responsive width
                    color: Colors.white, // Light grey divider
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width *
                          0.02, // Responsive margin
                    ),
                  ),

                  // Right Column: Date & Time
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height *
                              0.005), // Responsive spacing
                      Text(
                        _currentDateTime,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: MediaQuery.of(context).size.width *
                              0.026, // Responsive font size
                          fontWeight: FontWeight.bold, // Emphasized text
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_imagePath != null)
            Positioned(
              top: screenHeight * 0.4,
              left: screenWidth * 0.1,
              right: screenWidth * 0.1,
              child: Image.file(
                File(_imagePath!),
                width: screenWidth * 0.8,
                height: screenHeight * 0.4,
                fit: BoxFit.cover,
              ),
            ),
          Positioned(
            bottom: screenHeight * 0.05,
            left: screenWidth * 0.25,
            right: screenWidth * 0.25,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.01,
                    vertical: screenHeight * 0.015),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: _captureImage,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Check In",
                      style: TextStyle(
                          fontSize: screenWidth * 0.04, color: Colors.white)),
                  SizedBox(width: screenWidth * 0.02),
                  Icon(Icons.arrow_forward,
                      color: Colors.white, size: screenWidth * 0.05),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
