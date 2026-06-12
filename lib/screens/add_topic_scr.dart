import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddTopicScreen extends StatefulWidget {
  const AddTopicScreen({super.key});

  @override
  State<AddTopicScreen> createState() => _AddTopicScreenState();
}

class _AddTopicScreenState extends State<AddTopicScreen> {
  List<Map<String, dynamic>> subjects = [];

  String? selectedSubjectId;
  String difficulty = "Medium";
  final topicController = TextEditingController();

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    loadSubjects();

    topicController.addListener(checkFields);
  }

  Future<void> loadSubjects() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('subjects')
        .where(
          'userId',
          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
        )
        .get();

    subjects = snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['name'],
      };
    }).toList();

    setState(() {});
  }

  void checkFields() {
    setState(() {
      isButtonEnabled =
          topicController.text.trim().isNotEmpty &&
          selectedSubjectId != null;
    });
  }

  @override
  void dispose() {
    topicController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final now = DateTime.now();

    await FirebaseFirestore.instance.collection('topics').add({
      'title': topicController.text.trim(),
      'subjectId': selectedSubjectId,
      'difficulty': difficulty,

      'createdAt': Timestamp.fromDate(now),
      'nextRevision': Timestamp.fromDate(
        now.add(const Duration(days: 1)),
      ),

      'revisionLevel': 0,
      'reviewCount': 0,
      'lastReviewedAt': null,
    });

    topicController.clear();

    setState(() {
      difficulty = "Medium";
    });

    if (!mounted) return;

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
            DropdownButtonFormField<String>(
              initialValue: selectedSubjectId,
              decoration: const InputDecoration(
                labelText: "Subject",
                border: OutlineInputBorder(),
              ),
              items: subjects.map((subject) {
                return DropdownMenuItem<String>(
                  value: subject['id'],
                  child: Text(subject['name']),
                );
              }).toList(),
              onChanged: (initialValue) {
                setState(() {
                  selectedSubjectId = initialValue;
                });

                checkFields();
              },
            ),

            const SizedBox(height: 15),

            TextField(
              controller: topicController,
              decoration: const InputDecoration(
                labelText: "Topic Name",
              ),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChoiceChip(
                  label: const Text("Easy"),
                  selected: difficulty == "Easy",
                  onSelected: (_) {
                    setState(() {
                      difficulty = "Easy";
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text("Medium"),
                  selected: difficulty == "Medium",
                  onSelected: (_) {
                    setState(() {
                      difficulty = "Medium";
                    });
                  },
                ),
                ChoiceChip(
                  label: const Text("Hard"),
                  selected: difficulty == "Hard",
                  onSelected: (_) {
                    setState(() {
                      difficulty = "Hard";
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isButtonEnabled ? submit : null,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}