import 'package:flutter/material.dart';
import 'add_topic_scr.dart';
import 'subjects_scr.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SubjectsScreen(),
                ),
              );
            },
            child: const Text("Subjects"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: Text("Today's Revisions"),
                subtitle: Text("5 Topics"),
              ),
            ),
            SizedBox(height: 10),
            Card(
              child: ListTile(
                title: Text("Pending Topics"),
                subtitle: Text("12 Topics"),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddTopicScreen(),
                ),
              );
            },
            child: const Text("Add Topic"),
            ),
          ],
        ),
      ),
    );
  }
}


