import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/location_controller.dart';
import '../controller/user_controller.dart';
import 'location_header.dart';
import 'user_list.dart';

class HomeScreen extends StatelessWidget {
  final userController = Get.put(UserController());
  final locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("User Directory",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black87,
        elevation: 4,
      ),
      body: Column(
        children: [
          LocationHeader(),
          Expanded(child: UserList()),
        ],
      ),
    );
  }
}
