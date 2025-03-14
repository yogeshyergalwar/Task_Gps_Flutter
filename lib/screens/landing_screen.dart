import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import '../global_files/Colors.dart';
import 'GpsCameraCheckInScreen.dart';

class LandingScreen extends StatefulWidget {
  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

CustomColors color = CustomColors();

class _LandingScreenState extends State<LandingScreen> {
  GoogleMapController? _mapController;
  loc.LocationData? _currentLocation;
  final loc.Location _location = loc.Location();
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndFetchLocation();
  }

  Future<void> _checkPermissionsAndFetchLocation() async {
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    try {
      serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return;
      }

      permissionGranted = await _location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) return;
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
        LatLng currentLatLng = LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
        setState(() {
          _markers.clear();
          _markers.add(
            Marker(
              markerId: MarkerId("currentLocation"),
              position: currentLatLng,
              infoWindow: InfoWindow(title: "Your Location"),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            ),
          );
        });
        _moveCameraToCurrentLocation(_currentLocation!.latitude!, _currentLocation!.longitude!);
      }
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  void _moveCameraToCurrentLocation(double latitude, double longitude) {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(latitude, longitude), zoom: 15),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: _buildGoogleMap(),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: _buildAttendanceButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleMap() {
    return _currentLocation == null
        ? Center(child: CircularProgressIndicator())
        : GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        zoom: 15,
      ),
      markers: _markers,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        Future.delayed(Duration(milliseconds: 500), () {
          _moveCameraToCurrentLocation(_currentLocation!.latitude!, _currentLocation!.longitude!);
        });
      },
    );
  }

  Widget _buildAttendanceButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GpsCameraCheckInScreen()),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Mark The Attendance", style: TextStyle(fontSize: 16, color: Colors.white)),
          SizedBox(width: 10),
          Icon(Icons.arrow_forward, color: Colors.white),
        ],
      ),
    );
  }
}
