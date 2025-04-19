import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/user_controller.dart';
import 'user_tile.dart';

class UserList extends StatelessWidget {
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (userController.users.isEmpty) {
        return Center(child: CircularProgressIndicator());
      }

      return ListView.builder(
        itemCount: userController.users.length,
        itemBuilder: (context, index) {
          final user = userController.users[index];
          return UserTile(user: user);
        },
      );
    });
  }
}
