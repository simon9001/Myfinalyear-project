import 'package:flutter/material.dart';

class LecturerScreen extends StatelessWidget {
  const LecturerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lecturer Dashboard")),
      body: const Center(
        child: Text(
          "Welcome, Lecturer!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
