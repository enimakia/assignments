import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Root widget — sets up the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NoteMeUp',
      home: const NoteKeeperPage(),
    );
  }
}

// The main screen
class NoteKeeperPage extends StatefulWidget {
  const NoteKeeperPage({super.key});

  @override
  NoteKeeperPageState createState() => NoteKeeperPageState();
}

class NoteKeeperPageState extends State<NoteKeeperPage> {
  // Stores all notes
  List<String> notes = [];

  // Controls the text input field
  TextEditingController controller = TextEditingController();

  // Add a note to the list
  void addNote() {
    String text = controller.text.trim();
    if (text.isNotEmpty) {
      setState(() => notes.add(text));
      controller.clear();
    }
  }

  // Remove a note from the list
  void deleteNote(int index) {
    setState(() => notes.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top bar
      appBar: AppBar(
        title: const Text('NoteMeUp'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          // --- Input Row ---
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Text field
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter a note...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Add button
                ElevatedButton(onPressed: addNote, child: const Text('Add')),
              ],
            ),
          ),

          // --- Notes List ---
          Expanded(
            child: notes.isEmpty
                // Show message when no notes
                ? const Center(
                    child: Text(
                      'No notes yet. Add one!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                // Show list of notes
                : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.note),
                        title: Text(notes[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteNote(index),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
