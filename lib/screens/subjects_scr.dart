import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Subjects"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const AddSubjectDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('subjects')
            .where('userId', isEqualTo: uid)
            .snapshots(),
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final subjects = snapshot.data!.docs;

          if (subjects.isEmpty) {
            return const Center(
              child: Text("No subjects yet"),
            );
          }

          return ListView.builder(
            itemCount: subjects.length,
            itemBuilder: (context, index) {

              final doc = subjects[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(8),

                child: ListTile(
                  title: Text(data['name']),
                  subtitle: Text(
                    "Difficulty: ${data['difficulty']}",
                  ),

                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('subjects')
                          .doc(doc.id)
                          .delete();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AddSubjectDialog extends StatefulWidget {
  const AddSubjectDialog({super.key});

  @override
  State<AddSubjectDialog> createState() =>
      _AddSubjectDialogState();
}

class _AddSubjectDialogState
    extends State<AddSubjectDialog> {

  final TextEditingController nameController = TextEditingController();

  String difficulty = "Medium";

  Future<void> addSubject() async {

    if (nameController.text.trim().isEmpty) {
      return;
    }

    await FirebaseFirestore.instance
        .collection('subjects')
        .add({
      'name': nameController.text.trim(),
      'difficulty': difficulty,
      'userId':
          FirebaseAuth.instance.currentUser!.uid,
      'createdAt': Timestamp.now(),
    });

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: const Text("Add Subject"),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Subject Name",
            ),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
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
        ],
      ),

      actions: [

        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),

        ElevatedButton(
          onPressed: addSubject,
          child: const Text("Add"),
        ),
      ],
    );
  }
}