import 'package:flutter/material.dart';
import 'package:front_end/resources/auth_methods.dart';
import 'package:front_end/screens/home_screen.dart';
import 'package:front_end/screens/login_screen.dart';
import 'package:front_end/screens/video_call_screen.dart';
import 'package:front_end/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zoom Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/video-call': (context) => const VideoCallScreen(),
      },
      home: FutureBuilder(
        future: AuthMethods().getToken(), // Check if token exists
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData && snapshot.data != null) {
            return const HomeScreen(); // Navigate to home if authenticated
          }

          return const LoginScreen(); // Otherwise, show login
        },
      ),
    );
  }
}
