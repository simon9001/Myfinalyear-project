import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: StudentDashboard(),
    );
  }
}

class StudentDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Dashboard",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.account_circle,
                        size: 60, color: Colors.blueAccent),
                  ),
                  SizedBox(height: 10),
                  Text("Student Name",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text("student@example.com",
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            _buildDrawerItem(context, Icons.dashboard, "Dashboard"),
            _buildDrawerItem(context, Icons.book, "My Courses"),
            _buildDrawerItem(context, Icons.science, "Virtual Labs"),
            _buildDrawerItem(context, Icons.assignment, "Assignments & Exams"),
            _buildDrawerItem(context, Icons.videocam, "AI-Powered Classroom"),
            _buildDrawerItem(context, Icons.bar_chart, "Performance & Reports"),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("📚 Enrolled Courses",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.3,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return _buildCourseCard(index);
                },
              ),
            ),
            SizedBox(height: 20),
            Text("📊 Progress Tracker",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            LinearPercentIndicator(
              lineHeight: 8.0,
              percent: 0.7,
              backgroundColor: Colors.grey[300],
              progressColor: Colors.blueAccent,
              barRadius: Radius.circular(10),
            ),
            SizedBox(height: 10),
            Text("70% Course Completion",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: TextStyle(fontSize: 16)),
      onTap: () {},
    );
  }

  Widget _buildCourseCard(int index) {
    return Card(
      color: Colors.blueAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.book, color: Colors.white, size: 40),
            Spacer(),
            Text("Course ${index + 1}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            Text("Click to access", style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
