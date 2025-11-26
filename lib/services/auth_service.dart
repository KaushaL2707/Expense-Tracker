import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String baseUrl = 'https://c849642d9914.ngrok-free.app';

  Future<User> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final user = User.fromJson(json.decode(response.body));
      await _saveUser(user);
      return user;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<User> register(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Registration successful, usually returns user or success message.
      // If it returns user with token, we can log them in directly.
      // Based on doc: Response: { "token": "...", "userId": 1, ... }
      final user = User.fromJson(json.decode(response.body));
      await _saveUser(user);
      return user;
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userId')) return null;

    return User(
      id: prefs.getInt('userId')!,
      name: prefs.getString('name') ?? '',
      email: prefs.getString('email') ?? '',
      token: prefs.getString('token') ?? '',
    );
  }

  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', user.id);
    await prefs.setString('name', user.name);
    await prefs.setString('email', user.email);
    await prefs.setString('token', user.token);
  }
}
