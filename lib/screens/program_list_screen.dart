import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProgramListScreen extends StatefulWidget {
  @override
  _ProgramListScreenState createState() => _ProgramListScreenState();
}

class _ProgramListScreenState extends State<ProgramListScreen> {
  late Future<List<dynamic>> programs;

  @override
  void initState() {
    super.initState();
    programs = ApiService.fetchPrograms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Programs")),
      body: FutureBuilder<List<dynamic>>(
        future: programs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          List<dynamic> programs = snapshot.data ?? [];
          return ListView.builder(
            itemCount: programs.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(programs[index]['title']),
                onTap: () {
                  // Navigate to program details (if needed)
                },
              );
            },
          );
        },
      ),
    );
  }
}
