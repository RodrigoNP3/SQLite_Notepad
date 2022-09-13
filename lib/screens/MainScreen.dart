import 'package:flutter/material.dart';
import 'package:sqlite_notepad/model/note.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../notes_database.dart';
import 'package:sqflite/sqflite.dart';

import '../widgets/notes_list.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Note> _notes = [];
  bool isLoading = false;

  Future closeDB() async {
    await NotesDatabase.instance.close();
    refreshNotes();
  }

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
    this._notes = await NotesDatabase.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
            onPressed: closeDB,
            icon: const Icon(Icons.remove),
          ),
          IconButton(
            onPressed: addNote,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: NotesList(
        notes: _notes,
      ),
    );
  }
}
