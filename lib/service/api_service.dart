import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';

class ApiService {
  static Future<List<Data>> fetchUsers() async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users?page=2'));

    if (response.statusCode == 200) {
      final userModel = UserModel.fromJson(json.decode(response.body));
      return userModel.data ?? [];
    } else {
      throw Exception('Failed to load users');
    }
  }
}
