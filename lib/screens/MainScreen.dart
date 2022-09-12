import 'package:flutter/material.dart';
import 'package:sqlite_notepad/model/note.dart';

import '../notes_database.dart';
import 'package:sqflite/sqflite.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Note> notes = [];
  bool isLoading = false;

  Future addNote() async {
    final note = Note(
      title: 'title',
      isImportant: true,
      number: 1,
      description: 'description',
      createdTime: DateTime.now(),
    );

    await NotesDatabase.instance.create(note);
    refreshNotes();
  }

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    this.notes = await NotesDatabase.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.remove),
          ),
          IconButton(
            onPressed: addNote,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
        width: double.maxFinite,
        height: 300,
        child: notes.isNotEmpty
            ? ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: [
                        Text('id: ${notes[index].id}'),
                        Text('isImportant: ${notes[index].isImportant}'),
                        Text('number: ${notes[index].number}'),
                        Text('title: ${notes[index].title}'),
                        Text('description: ${notes[index].description}'),
                        Text('createdTime: ${notes[index].createdTime}'),
                      ],
                    ),
                  );
                },
              )
            : const Text('NO NOTES ADDED YET'),
      ),
    );
  }
}
