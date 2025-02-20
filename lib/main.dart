import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:front_end/Admin/admin_home.dart';
import 'package:front_end/Student/student_home.dart';
import 'package:front_end/lectuler/lec_home.dart';
import 'package:front_end/resources/auth_methods.dart';
import 'package:front_end/screens/login_screen.dart';
import 'package:front_end/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// Fetches the initial screen based on authentication state
  Future<Widget> getInitialScreen() async {
    String? token = await AuthMethods().getToken();
    String? role = await AuthMethods().getUserRole();
    String? username = await AuthMethods().getUsername(); // Fetch username

    print("🔹 Token: $token");
    print("🔹 Role: $role");
    print("🔹 Username: $username");

    if (token != null && role != null) {
      switch (role.toLowerCase()) {
        case "admin":
          return AdminDashboard(
            username: username ?? "AdminUser",
            adminId: "oooo1",
          );
        case "lecturer":
          return LecturerDashboard(
              username: username ?? "Lecturer", lecturerId: "LEC-12345");
        case "student":
          return StudentDashboard(
            username: username ?? "Student",
            studentEmail: "hiiiiiSSSSSS",
          );
        default:
          return const LoginScreen();
      }
    } else {
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: getInitialScreen(),
      builder: (context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          print("Error in fetching initial screen: ${snapshot.error}");
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(child: Text("Error loading app. Please restart.")),
            ),
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'E-Learning Platform',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: backgroundColor,
          ),
          home: snapshot.data ?? const LoginScreen(),
          routes: {
            "/admin": (context) =>
                AdminDashboard(username: "AdminUser", adminId: "oooo1"),
            "/lecturer": (context) => LecturerDashboard(
                username: "Lecturer", lecturerId: "LEC-12345"),
            "/student": (context) =>
                StudentDashboard(username: "Student", studentEmail: "hiiii"),
            "/login": (context) => const LoginScreen(),
          },
        );
      },
    );
  }
}
