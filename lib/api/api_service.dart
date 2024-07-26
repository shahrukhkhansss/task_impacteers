import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = "https://reqres.in/api";

  Future<Map<String, dynamic>> fetchUsers(int page) async {
    final response = await http.get(Uri.parse('$baseUrl/users?page=$page'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<Map<String, dynamic>> fetchUserDetails(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user details');
    }
  }
}