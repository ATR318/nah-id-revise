import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTopicScreen extends StatefulWidget {
  const AddTopicScreen({super.key});

  @override
  State<AddTopicScreen> createState() => _AddTopicScreenState();
}



class _AddTopicScreenState extends State<AddTopicScreen> {
  
  final subjectController = TextEditingController();
  final topicController = TextEditingController();
  final difficultyController = TextEditingController();

  bool isButtonEnabled = false;

  void checkFields() {
    setState(() {
      isButtonEnabled =
          subjectController.text.trim().isNotEmpty &&
          difficultyController.text.trim().isNotEmpty &&
          topicController.text.trim().isNotEmpty;
    });
  }



  @override
  void dispose() {
    subjectController.dispose();
    topicController.dispose();
    difficultyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    subjectController.addListener(checkFields);
    difficultyController.addListener(checkFields);
    topicController.addListener(checkFields);
  }

  Future<void> submit() async {
  await FirebaseFirestore.instance.collection('subjects').add({
    'name': subjectController.text.trim(),
    'topic': topicController.text.trim(),
    'difficulty': difficultyController.text.trim(),
  });

  subjectController.clear();
  topicController.clear();
  difficultyController.clear();

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Topic added successfully'),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Topic"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: subjectController,
              decoration: InputDecoration(
                labelText: "Subject",
              ),
            ),
            SizedBox(height: 15),
            
            TextField(
              controller: topicController,
              decoration: InputDecoration(
                labelText: "Topic Name",
              ),
            ),
            SizedBox(height: 15),
            
            TextField(
              controller: difficultyController,
              decoration: InputDecoration(
                labelText: "Difficulty",
              ),
            ),
            SizedBox(height: 15),
            
            ElevatedButton(
              onPressed: isButtonEnabled ? submit : null,  
            child: const Text('Submit')
            )
            
          ],
        ),
      ),
    );
  }
}