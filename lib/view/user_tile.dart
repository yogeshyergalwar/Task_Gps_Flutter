import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/user_controller.dart';
import '../model/user_model.dart';

class UserTile extends StatelessWidget {
  final Data user;
  UserTile({required this.user});

  final UserController userController = Get.find();

  void _openImagePreview(BuildContext context, ImageProvider imageProvider) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: InteractiveViewer(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final uploadedPath = userController.imagePaths[user.id];
      final imageProvider = (uploadedPath != null && File(uploadedPath).existsSync())
          ? FileImage(File(uploadedPath))
          : NetworkImage(user.avatar!) as ImageProvider;

      return Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: GestureDetector(
            onTap: () => _openImagePreview(context, imageProvider),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: imageProvider,
            ),
          ),
          title: Text(
            '${user.firstName} ${user.lastName}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(user.email ?? ''),
          trailing: PopupMenuButton<ImageSource>(
            icon: Icon(Icons.upload_file, color: Colors.black54),
            onSelected: (source) {
              userController.pickImage(user.id!, source);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: ImageSource.camera,
                child: Text('Camera'),
              ),
              PopupMenuItem(
                value: ImageSource.gallery,
                child: Text('Gallery'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
