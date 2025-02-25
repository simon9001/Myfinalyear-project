import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:front_end/screens/login_screen.dart';
import 'package:front_end/resources/auth_methods.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          LecturerDashboard(username: "Dr. John Doe", lecturerId: "LEC-12345"),
    );
  }
}

class LecturerDashboard extends StatefulWidget {
  final String username;
  final String lecturerId;

  const LecturerDashboard(
      {super.key, required this.username, required this.lecturerId});

  @override
  _LecturerDashboardState createState() => _LecturerDashboardState();
}

class _LecturerDashboardState extends State<LecturerDashboard> {
  File? _profileImage;

  String getGreeting() {
    int hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 18) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }

  Future<void> _pickProfileImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _logout(BuildContext context) async {
    await AuthMethods().logoutUser();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _pickProfileImage,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? Icon(Icons.camera_alt,
                              size: 40, color: Colors.blueAccent)
                          : null,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(widget.username,
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text("ID: ${widget.lecturerId}",
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            _buildDrawerItem(LucideIcons.home, 'Dashboard', context),
            _buildDrawerItem(LucideIcons.book, 'My Courses', context),
            _buildDrawerItem(LucideIcons.flaskConical, 'Virtual Labs', context),
            _buildDrawerItem(
                LucideIcons.fileText, 'Assignments & Quizzes', context),
            _buildDrawerItem(LucideIcons.users, 'Student Progress', context),
            _buildDrawerItem(
                LucideIcons.video, 'AI-Powered Classroom', context),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Log Out", style: TextStyle(color: Colors.red)),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("${getGreeting()}, ${widget.username}"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Overview',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildOverviewCards(),
              SizedBox(height: 20),
              Text('Quick Actions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildQuickActions(),
              SizedBox(height: 20),
              Text('Student Engagement',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildEngagementGraph(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {},
    );
  }

  Widget _buildOverviewCards() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                child: _buildCard('My Active Courses', '5', LucideIcons.book)),
            SizedBox(width: 10),
            Expanded(
                child:
                    _buildCard('Number of Students', '120', LucideIcons.users)),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                child: _buildCard(
                    'Upcoming Live Sessions', '2', LucideIcons.video)),
            SizedBox(width: 10),
            Expanded(
                child: _buildCard(
                    'Pending Assignments', '3', LucideIcons.fileText)),
          ],
        ),
      ],
    );
  }

  Widget _buildCard(String title, String value, IconData icon) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(height: 10),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(value,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                child: _buildActionButton(
                    'Create New Course', LucideIcons.plusSquare)),
            SizedBox(width: 10),
            Expanded(
                child: _buildActionButton(
                    'Schedule Virtual Lab', LucideIcons.beaker)),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                child: _buildActionButton(
                    'Upload Course Materials', LucideIcons.upload)),
            SizedBox(width: 10),
            Expanded(
                child: _buildActionButton(
                    'Grade Assignments', LucideIcons.checkSquare)),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String title, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon),
      label: Text(title, textAlign: TextAlign.center),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildEngagementGraph() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text('Graph Placeholder',
            style: TextStyle(fontSize: 16, color: Colors.grey)),
      ),
    );
  }
}
