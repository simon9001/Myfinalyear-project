import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:front_end/utils/utils.dart';

class AuthMethods {
  final String _baseUrl = "https://backendar.onrender.com/api";

  /// Get stored authentication token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Store authentication token
  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  /// Store user role
  Future<void> _storeUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', role);
  }

  /// Get stored user role
  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role');
  }

  /// Logout user
  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_role');
  }

  /// Login user with credentials
  Future<bool> loginUser(
      String username, String password, BuildContext context) async {
    bool res = false;
    try {
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json"
      };

      final Map<String, String> body = {
        "username": username,
        "password": password
      };

      final response = await http.post(
        Uri.parse("$_baseUrl/login/"),
        headers: headers,
        body: jsonEncode(body),
      );

      print("🔄 API Call: POST $_baseUrl/login/");
      print("📤 Request Body: ${jsonEncode(body)}");
      print("📥 Response Status: ${response.statusCode}");
      print("📥 Raw Response Body: ${response.body}"); // Debugging step

      // Ensure response is not empty before decoding
      if (response.body.isEmpty) {
        showSnackBar(context, "❌ Error: Empty response from server.");
        return false;
      }

      // Check for HTML response (error pages)
      if (response.body.startsWith("<") || response.body.contains("html")) {
        showSnackBar(
            context, "⚠️ Error: Server returned an unexpected HTML response.");
        return false;
      }

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> data = jsonDecode(response.body);
          if (data.containsKey('access') && data.containsKey('user')) {
            await _storeToken(data['access']);
            await _storeUserRole(data['user']['role']);
            showSnackBar(context, "✅ Login Successful");
            res = true;
          } else {
            showSnackBar(context, "⚠️ Error: Unexpected response format.");
          }
        } catch (e) {
          showSnackBar(context, "❌ Error decoding JSON response: $e");
        }
      } else {
        try {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          showSnackBar(context, "❌ Login Failed: ${errorData['error']}");
        } catch (e) {
          showSnackBar(context, "❌ Error: Unable to parse server response.");
        }
      }
    } catch (e) {
      showSnackBar(context, "❌ Network Error: $e");
    }
    return res;
  }

  /// Register a new user
  Future<bool> registerUser(String username, String email, String password,
      BuildContext context) async {
    bool res = false;
    try {
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json"
      };

      final Map<String, String> body = {
        "username": username,
        "email": email,
        "password": password
      };

      final response = await http.post(
        Uri.parse("$_baseUrl/register/"),
        headers: headers,
        body: jsonEncode(body),
      );

      print("Registration Response: ${response.body}");

      if (response.body.isEmpty) {
        showSnackBar(context, "Error: Empty response from server.");
        return false;
      }

      if (response.body.startsWith("<") || response.body.contains("html")) {
        showSnackBar(context, "Error: Server returned an unexpected response.");
        return false;
      }

      if (response.statusCode == 201) {
        showSnackBar(context, "Registration Successful");
        res = true;
      } else {
        try {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          showSnackBar(context, "Registration Failed: ${errorData['error']}");
        } catch (e) {
          showSnackBar(context, "Error: Unable to parse server response.");
        }
      }
    } catch (e) {
      showSnackBar(context, "Network Error: $e");
    }
    return res;
  }

  /// Reset user password
  Future<bool> resetPassword(String email, BuildContext context) async {
    bool res = false;
    try {
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json"
      };

      final Map<String, String> body = {"email": email};

      final response = await http.post(
        Uri.parse("$_baseUrl/password/reset/"),
        headers: headers,
        body: jsonEncode(body),
      );

      print("Password Reset Response: ${response.body}");

      if (response.body.isEmpty) {
        showSnackBar(context, "Error: Empty response from server.");
        return false;
      }

      if (response.body.startsWith("<") || response.body.contains("html")) {
        showSnackBar(context, "Error: Server returned an unexpected response.");
        return false;
      }

      if (response.statusCode == 200) {
        showSnackBar(context, "Password reset email sent");
        res = true;
      } else {
        showSnackBar(context, "Failed to send password reset email");
      }
    } catch (e) {
      showSnackBar(context, "Network Error: $e");
    }
    return res;
  }

  /// Sign out user
  void signOut() async {
    try {
      await logoutUser();
    } catch (e) {
      print("Sign Out Error: $e");
    }
  }
}
