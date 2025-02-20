import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:front_end/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _baseUrl = "https://backendar.onrender.com/api";

  /// Get authentication changes
  Stream<User?> get authChanges => _auth.authStateChanges();

  /// Get the current authenticated user
  User? get user => _auth.currentUser;

  /// Store authentication token securely
  Future<void> _storeToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token != null) {
      await prefs.setString('auth_token', token);
    }
  }

  /// Retrieve stored authentication token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Store the user role in SharedPreferences
  Future<void> _storeUserRole(String? role) async {
    final prefs = await SharedPreferences.getInstance();
    if (role != null) {
      await prefs.setString('user_role', role);
    }
  }

  /// Retrieve the stored user role
  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role');
  }

  /// Store the username in SharedPreferences
  Future<void> _storeUsername(String? username) async {
    final prefs = await SharedPreferences.getInstance();
    if (username != null) {
      await prefs.setString('username', username);
    }
  }

  /// Retrieve the stored username
  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  /// Clear authentication data and logout user
  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_role');
    await prefs.remove('username');
  }

  /// Login user and determine their role
  Future<bool> loginUser(
      String username, String password, BuildContext context) async {
    bool res = false;
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/login/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      print("🔹 Response status: ${response.statusCode}");
      print("🔹 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Debugging logs
        print("🔹 Parsed JSON: $data");

        // Ensure 'access' token exists
        String? token = data['access'];
        if (token == null) {
          showSnackBar(context, "Error: Token not received from server.");
          return false;
        }

        // Ensure 'user' object exists and contains 'role' & 'username'
        String? role;
        String? storedUsername;
        if (data.containsKey('user')) {
          final user = data['user'];
          print("🔹 User Data: $user");

          role = user.containsKey('role') ? user['role'] : null;
          storedUsername =
              user.containsKey('username') ? user['username'] : null;
        }

        if (role == null || storedUsername == null) {
          showSnackBar(context, "Error: User data missing in response.");
          return false;
        }

        await _storeToken(token);
        await _storeUserRole(role);
        await _storeUsername(storedUsername);

        showSnackBar(context, "Login Successful");

        // Navigate to respective dashboard based on role
        _navigateToDashboard(context, role);
        res = true;
      } else {
        final errorResponse = jsonDecode(response.body);
        String errorMessage = errorResponse.containsKey('error')
            ? errorResponse['error']
            : "Unknown error";
        showSnackBar(context, "Login Failed: $errorMessage");
      }
    } catch (e) {
      showSnackBar(context, "Error: $e");
    }
    return res;
  }

  /// Navigate to the correct dashboard based on user role
  void _navigateToDashboard(BuildContext context, String role) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("🔹 Navigating to $role screen...");

      String route;
      switch (role.toLowerCase()) {
        case "admin":
          route = "/admin";
          break;
        case "lecturer":
          route = "/lecturer";
          break;
        case "student":
          route = "/student";
          break;
        default:
          route = "/login";
          showSnackBar(context, "Invalid user role received: $role");
      }

      Navigator.of(context).pushReplacementNamed(route);
    });
  }

  /// Register new user
  Future<bool> registerUser(String username, String email, String password,
      BuildContext context) async {
    bool res = false;
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/register/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            {"username": username, "email": email, "password": password}),
      );

      if (response.statusCode == 201) {
        showSnackBar(context, "Registration Successful");
        res = true;
      } else {
        final errorResponse = jsonDecode(response.body);
        String errorMessage = errorResponse.containsKey('error')
            ? errorResponse['error']
            : "Unknown error";
        showSnackBar(context, "Registration Failed: $errorMessage");
      }
    } catch (e) {
      showSnackBar(context, "Error: $e");
    }
    return res;
  }

  /// Reset password request
  Future<bool> resetPassword(String email, BuildContext context) async {
    bool res = false;
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/password/reset/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        showSnackBar(context, "Password reset email sent");
        res = true;
      } else {
        final errorResponse = jsonDecode(response.body);
        String errorMessage = errorResponse.containsKey('error')
            ? errorResponse['error']
            : "Unknown error";
        showSnackBar(
            context, "Failed to send password reset email: $errorMessage");
      }
    } catch (e) {
      showSnackBar(context, "Error: $e");
    }
    return res;
  }

  /// Logout and remove user authentication data
  void signOut() async {
    try {
      await _auth.signOut();
      await logoutUser();
    } catch (e) {
      print("Sign Out Error: $e");
    }
  }
}
