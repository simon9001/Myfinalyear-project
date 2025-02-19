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

  Future<Widget> getInitialScreen() async {
    String? token = await AuthMethods().getToken();
    String? role = await AuthMethods().getUserRole();

    print("🔹 Token: $token");
    print("🔹 Role: $role");

    if (token != null && role != null) {
      switch (role.toLowerCase()) {
        case "admin":
          return AdminDashboard(username: "AdminUser");
        case "lecturer":
          return LecturerDashboard();
        case "student":
          return StudentDashboard();
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

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'E-Learning Platform',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: backgroundColor,
          ),
          home: snapshot.data ?? const LoginScreen(),
          routes: {
            "/admin": (context) => AdminDashboard(username: "AdminUser"),
            "/lecturer": (context) => LecturerDashboard(),
            "/student": (context) => StudentDashboard(),
            "/login": (context) => const LoginScreen(),
          },
        );
      },
    );
  }
}
