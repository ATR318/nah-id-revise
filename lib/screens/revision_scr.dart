import 'package:flutter/material.dart';

class RevisionScreen extends StatelessWidget {
  const RevisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Revision"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Binary Search",
              style: TextStyle(
                fontSize: 24,
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {},
              child: const Text("Easy"),
            ),

            ElevatedButton(
              onPressed: () {},
              child: const Text("Medium"),
            ),

            ElevatedButton(
              onPressed: () {},
              child: const Text("Hard"),
            ),

            ElevatedButton(
              onPressed: () {},
              child: const Text("Forgot"),
            ),
          ],
        ),
      ),
    );
  }
}