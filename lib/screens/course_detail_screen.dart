import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CourseDetailScreen extends StatelessWidget {
  final String slug;

  CourseDetailScreen({required this.slug});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Course Details")),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ApiService.fetchCourseDetail(slug),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          Map<String, dynamic> course = snapshot.data!;
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(course['title'],
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("Code: ${course['code']}"),
                Text("Credits: ${course['credit']}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
