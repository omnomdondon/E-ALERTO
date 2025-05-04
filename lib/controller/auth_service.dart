import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  static final String baseUrl = dotenv.env['BASE_URL']!;
  static final String _clientIDWeb = dotenv.env['GOOGLE_CLIENT_ID']!;

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? _clientIDWeb : null,
    scopes: ['email', 'profile'],
  );

  static Future<bool> register(String email, String username, String password,
      String fullName, String phone) async {
    final url = Uri.parse('$baseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
          'full_name': fullName,
          'phone': phone,
        }),
      );
      final data = jsonDecode(response.body);
      return response.statusCode == 201 && data['success'] == true;
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  // static Future<bool> register(
  //     String email, String username, String password, String fullName) async {
  //   final url = Uri.parse('$baseUrl/register');
  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'email': email,
  //         'username': username,
  //         'password': password,
  //         'full_name': fullName,
  //       }),
  //     );
  //     final data = jsonDecode(response.body);
  //     return response.statusCode == 201 && data['success'] == true;
  //   } catch (e) {
  //     print('Registration error: $e');
  //     return false;
  //   }
  // }

  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        return true;
      } else {
        print('Login error: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  static Future<bool> googleLogin() async {
    if (!kIsWeb && !(Platform.isAndroid || Platform.isIOS)) {
      print('❌ Google Sign-In not supported on this platform.');
      return false;
    }

    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) return false;

      final GoogleSignInAuthentication auth = await account.authentication;
      final idToken = auth.idToken;

      final url = Uri.parse('$baseUrl/google-login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        return true;
      } else {
        print('Google login error: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Google login exception: $e');
      return false;
    }
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['username'];
      } else {
        print('Fetch username failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching username: $e');
      return null;
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _googleSignIn.signOut();
  }
}
