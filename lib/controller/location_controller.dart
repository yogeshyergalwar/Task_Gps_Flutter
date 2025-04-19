import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class LocationController extends GetxController {
  var latitude = ''.obs;
  var longitude = ''.obs;
  var address = 'Fetching address...'.obs;
  var dateTime = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _getLocation();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      address.value = 'Location services are disabled.';
      return;
    }

    // Request permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        address.value = 'Location permission denied.';
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      address.value = 'Location permissions permanently denied.';
      return;
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    latitude.value = position.latitude.toString();
    longitude.value = position.longitude.toString();

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks.first;

    address.value =
        "${place.street},  ${place.locality},${place.subLocality}, ${place.country}";

    final now = DateTime.now();
    dateTime.value = DateFormat('dd-MMM-yyyy hh:mm a').format(now);
  }
}
