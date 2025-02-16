import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:front_end/utils/utils.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _baseUrl = "http://192.168.179.36/api";

  Stream<User?> get authChanges => _auth.authStateChanges();
  User? get user => _auth.currentUser;

  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<bool> loginUser(
      String username, String password, BuildContext context) async {
    bool res = false;
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/login/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _storeToken(data['access']);
        await _storeUserRole(data['user']['role']);
        showSnackBar(context, "Login Successful");
        res = true;
      } else {
        showSnackBar(
            context, "Login Failed: ${jsonDecode(response.body)['error']}");
      }
    } catch (e) {
      showSnackBar(context, "Error: $e");
    }
    return res;
  }

  Future<void> _storeUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', role);
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role');
  }

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
        showSnackBar(context,
            "Registration Failed: ${jsonDecode(response.body)['error']}");
      }
    } catch (e) {
      showSnackBar(context, "Error: $e");
    }
    return res;
  }

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
        showSnackBar(context, "Failed to send password reset email");
      }
    } catch (e) {
      showSnackBar(context, "Error: $e");
    }
    return res;
  }

  void signOut() async {
    try {
      await _auth.signOut();
      await logoutUser();
    } catch (e) {
      print("Sign Out Error: $e");
    }
  }
}
