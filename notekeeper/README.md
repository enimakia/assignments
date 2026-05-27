# 📒 NoteMeUp — Flutter App

A simple Flutter note-taking app where you can **add** and **delete** notes.
Built with clean, beginner-friendly Dart code.

---

## 📁 File: `lib/main.dart`

---

### 🔷 Block 1 — Import (Line 1)

```dart
import 'package:flutter/material.dart';
```

Loads the Flutter Material Design library.
Gives access to all Flutter widgets: `Text`, `Scaffold`, `AppBar`, `ListView`, etc.

---

### 🔷 Block 2 — Entry Point (Lines 3–5)

```dart
void main() {
  runApp(const MyApp());
}
```

| Part | Meaning |
|---|---|
| `void main()` | Starting point of every Dart program |
| `runApp(...)` | Launches the app and attaches the widget tree to the screen |
| `const MyApp()` | Creates the root widget. `const` = it never changes (better performance) |

---

### 🔷 Block 3 — Root App Widget (Lines 7–19)

```dart
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
```

| Part | Meaning |
|---|---|
| `extends StatelessWidget` | No changing data here — just sets up the app shell |
| `const MyApp({super.key})` | Constructor with `key` — Flutter best practice for widget identity |
| `Widget build(...)` | Returns the widget tree Flutter draws on screen |
| `MaterialApp(...)` | Top-level widget that wraps the whole app with Material Design |
| `debugShowCheckedModeBanner: false` | Hides the red DEBUG banner in the corner |
| `title: 'NoteMeUp'` | App name shown in the device task switcher |
| `home: const NoteKeeperPage()` | The first screen the user sees when the app opens |

---

### 🔷 Block 4 — Stateful Widget (Lines 21–27)

```dart
// The main screen
class NoteKeeperPage extends StatefulWidget {
  const NoteKeeperPage({super.key});

  @override
  NoteKeeperPageState createState() => NoteKeeperPageState();
}
```

| Part | Meaning |
|---|---|
| `extends StatefulWidget` | This screen has **changing data** (the notes list), so it must be stateful |
| `const NoteKeeperPage({super.key})` | Constructor with a key parameter |
| `createState()` | Creates and returns the `NoteKeeperPageState` object that holds all the logic |

---

### 🔷 Block 5 — State Class & Variables (Lines 29–34)

```dart
class NoteKeeperPageState extends State<NoteKeeperPage> {
  // Stores all notes
  List<String> notes = [];

  // Controls the text input field
  TextEditingController controller = TextEditingController();
```

| Part | Meaning |
|---|---|
| `extends State<NoteKeeperPage>` | The state class paired with `NoteKeeperPage` — holds all mutable data |
| `List<String> notes = []` | A list (array) that stores the notes as text. Starts empty |
| `TextEditingController controller` | Linked to the text field — lets us read what the user typed and clear it |

---

### 🔷 Block 6 — Add Note Method (Lines 36–43)

```dart
  // Add a note to the list
  void addNote() {
    String text = controller.text.trim();
    if (text.isNotEmpty) {
      setState(() => notes.add(text));
      controller.clear();
    }
  }
```

| Part | Meaning |
|---|---|
| `controller.text.trim()` | Reads the text field value and strips leading/trailing spaces |
| `if (text.isNotEmpty)` | Only adds a note if the user typed something |
| `setState(() => notes.add(text))` | Adds note to the list AND tells Flutter to rebuild the UI |
| `controller.clear()` | Empties the text field after saving so the user can type the next note |

---

### 🔷 Block 7 — Delete Note Method (Lines 45–48)

```dart
  // Remove a note from the list
  void deleteNote(int index) {
    setState(() => notes.removeAt(index));
  }
```

| Part | Meaning |
|---|---|
| `int index` | The position of the note to delete (0 = first, 1 = second, etc.) |
| `notes.removeAt(index)` | Removes the note at that position from the list |
| `setState(...)` | Tells Flutter to rebuild the UI to reflect the deletion |

---

### 🔷 Block 8 — Build: AppBar (Lines 50–58)

```dart
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top bar
      appBar: AppBar(
        title: const Text('NoteMeUp'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
```

| Part | Meaning |
|---|---|
| `Widget build(BuildContext context)` | Returns the UI for this screen. Flutter calls this every time state changes |
| `Scaffold` | Base layout widget — provides AppBar + body structure |
| `AppBar` | The top navigation bar |
| `title: const Text('NoteMeUp')` | Text shown in the app bar |
| `backgroundColor: Colors.deepPurple` | Purple background for the bar |
| `foregroundColor: Colors.white` | White colour for the title text |

---

### 🔷 Block 9 — Input Row (Lines 60–84)

```dart
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
```

| Part | Meaning |
|---|---|
| `Column` | Stacks children **vertically** — input row on top, notes list below |
| `Padding(padding: EdgeInsets.all(12))` | Adds 12px space around the row so it doesn't touch the screen edges |
| `Row` | Lays children out **horizontally** (side by side) |
| `Expanded` | Makes the `TextField` stretch to fill all available width |
| `TextField(controller: controller)` | The text box where the user types a note, linked to `controller` |
| `hintText: 'Enter a note...'` | Grey placeholder text shown when the field is empty |
| `OutlineInputBorder()` | Draws a rectangular border around the text field |
| `const SizedBox(width: 10)` | 10px gap between the text field and the button |
| `ElevatedButton(onPressed: addNote)` | Raised button — calls `addNote()` when tapped |
| `child: const Text('Add')` | Label on the button |

---

### 🔷 Block 10 — Notes List (Lines 86–110)

```dart
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
```

| Part | Meaning |
|---|---|
| `Expanded` | Makes the list fill all remaining vertical space below the input row |
| `notes.isEmpty ? ... : ...` | Ternary (if/else) — shows empty message OR the notes list |
| `Center(child: Text(...))` | Centers the "No notes yet" message on screen |
| `TextStyle(color: Colors.grey)` | Styles the message text to grey |
| `ListView.builder` | Efficiently builds a scrollable list — only renders visible items |
| `itemCount: notes.length` | How many rows to build (one per note) |
| `itemBuilder: (context, index)` | Called for each item; `index` = position of that note in the list |
| `ListTile` | Pre-built row widget with left icon, middle text, right button |
| `leading: Icon(Icons.note)` | Note icon on the **left** of each row |
| `title: Text(notes[index])` | The **note text** in the middle |
| `trailing: IconButton(...)` | Red delete icon on the **right** — calls `deleteNote(index)` when tapped |

---

### 🔷 Block 11 — Closing Brackets (Lines 111–115)

```dart
        ],
      ),
    );
  }
}
```

These close (in order):
- `Column`'s children list `]`
- `Column` widget `)`
- `Scaffold` `)`
- `build()` method `}`
- `NoteKeeperPageState` class `}`

---

## 🗂️ App Structure at a Glance

```
main()
  └── MyApp  (StatelessWidget)
        └── MaterialApp
              └── NoteKeeperPage  (StatefulWidget)
                    └── NoteKeeperPageState
                          ├── notes: List<String>   ← stores all note text
                          ├── controller            ← reads & clears text field
                          ├── addNote()             ← adds a note to the list
                          ├── deleteNote(index)     ← removes a note by position
                          └── build()
                                ├── AppBar          ← top purple bar
                                ├── Row             ← text field + Add button
                                └── ListView        ← scrollable notes list
```

---

## 🚀 How to Run

```bash
flutter run
```

Make sure you have an emulator running or a physical device connected.
