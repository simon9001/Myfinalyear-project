import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LecturerDashboard(),
    );
  }
}

class LecturerDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Lecturer Panel',
                style: TextStyle(color: Colors.white, fontSize: 20),
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
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Lecturer Dashboard'),
      ),
      body: Padding(
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
            _buildQuickActions(),
            SizedBox(height: 20),
            Text('Student Engagement',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(child: _buildEngagementGraph()),
          ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCard('My Active Courses', '5', LucideIcons.book),
        _buildCard('Number of Students', '120', LucideIcons.users),
        _buildCard('Upcoming Live Sessions', '2', LucideIcons.video),
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
            Text(title, textAlign: TextAlign.center),
            Text(value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton('Create New Course', LucideIcons.plusSquare),
        _buildActionButton('Schedule Virtual Lab', LucideIcons.beaker),
        _buildActionButton('Upload Course Materials', LucideIcons.upload),
      ],
    );
  }

  Widget _buildActionButton(String title, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildEngagementGraph() {
    return Center(
      child: Text('Graph Placeholder',
          style: TextStyle(fontSize: 16, color: Colors.grey)),
    );
  }
}
