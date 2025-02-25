import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:front_end/screens/login_screen.dart';
import 'package:front_end/resources/auth_methods.dart';
import 'package:front_end/Admin/cousemanagement.dart';

class AdminDashboard extends StatefulWidget {
  final String username;
  final String adminId;

  const AdminDashboard(
      {super.key, required this.username, required this.adminId});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  File? _profileImage;

  String getGreeting() {
    var hour = DateTime.now().hour;
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

  void _logout() async {
    await AuthMethods().logoutUser();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${getGreeting()}, ${widget.username}"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: _buildAdminDrawer(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Search",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2,
                children: [
                  _buildDashboardCard(
                      "Total Students", "1,245", Icons.people, Colors.yellow),
                  _buildDashboardCard(
                      "Total Lecturers", "78", Icons.school, Colors.blueAccent),
                  _buildDashboardCard("Active Virtual Labs", "15",
                      Icons.science, Colors.orange),
                  _buildDashboardCard("Live Classes Ongoing", "5",
                      Icons.videocam, Colors.green),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
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
                Text("Admin ID: ${widget.adminId}",
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard (Home)'),
              onTap: () => Navigator.pop(context)),
          ListTile(
              leading: Icon(Icons.people),
              title: Text('Manage Lecturers'),
              onTap: () => Navigator.pop(context)),
          ListTile(
              leading: Icon(Icons.group),
              title: Text('Manage Students'),
              onTap: () => Navigator.pop(context)),
          ListTile(
            leading: Icon(Icons.menu_book),
            title: Text('Course Management'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CourseManagementScreen()),
              );
            },
          ),
          ListTile(
              leading: Icon(Icons.science),
              title: Text('Virtual Labs Management'),
              onTap: () => Navigator.pop(context)),
          ListTile(
              leading: Icon(Icons.analytics),
              title: Text('Analytics & Reports'),
              onTap: () => Navigator.pop(context)),
          ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => Navigator.pop(context)),
          ListTile(
              leading: Icon(Icons.event),
              title: Text('Manage Semester'),
              onTap: () => Navigator.pop(context)),
          ListTile(
              leading: Icon(Icons.timelapse),
              title: Text('Manage Sessions'),
              onTap: () => Navigator.pop(context)),
          Divider(),
          ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: _logout),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      color: color,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 4),
                Text(value,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
