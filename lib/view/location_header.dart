import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/location_controller.dart';

class LocationHeader extends StatelessWidget {
  final locationController = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 6,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Latitude: ${locationController.latitude.value}',
                      style: TextStyle(color: Colors.white)),
                  Text('Longitude: ${locationController.longitude.value}',
                      style: TextStyle(color: Colors.white)),
                  SizedBox(height: 4),
                  Text('${locationController.address.value}',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),

            // Divider
            Container(
              height: 70,
              width: 1,
              color: Colors.white54,
              margin: EdgeInsets.symmetric(horizontal: 12),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.access_time, color: Colors.white70, size: 18),
                SizedBox(height: 4),
                Text(
                  locationController.dateTime.value,
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
