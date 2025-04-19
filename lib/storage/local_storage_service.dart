import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class LocalStorageService {
  static const String _boxName = 'user_images';

  static Future<void> initHive() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    await Hive.openBox<String>(_boxName);
  }

  static Future<void> saveImagePath(int userId, String path) async {
    final box = Hive.box<String>(_boxName);
    await box.put(userId.toString(), path);
  }

  static Future<Map<int, String>> loadAllImagePaths() async {
    final box = Hive.box<String>(_boxName);
    final Map<int, String> imagePaths = {};
    for (var key in box.keys) {
      imagePaths[int.parse(key)] = box.get(key)!;
    }
    return imagePaths;
  }
  static Future<void> debugHive() async {
    final box = Hive.box<String>(_boxName);
    print("Hive contents: ${box.toMap()}");
  }

}
