import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../model/user_model.dart';
import '../service/api_service.dart';
import '../storage/local_storage_service.dart';

class UserController extends GetxController {
  var users = <Data>[].obs;
  var imagePaths = <int, String>{}.obs;

  @override
  void onInit() {
    fetchUsers();
    loadStoredImages();
    super.onInit();
  }

  void fetchUsers() async {
    users.value = await ApiService.fetchUsers();
  }

  void pickImage(int userId, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      if (await file.exists()) {
        imagePaths[userId] = file.path;
        imagePaths.refresh();

        await LocalStorageService.saveImagePath(userId, file.path);

        print("Image saved and UI refreshed for user $userId");
      } else {
        print("Picked file does not exist");
      }
    } else {
      print("No image picked");
    }
  }

  void loadStoredImages() async {
    imagePaths.value = await LocalStorageService.loadAllImagePaths();
    imagePaths.refresh();
  }
}
