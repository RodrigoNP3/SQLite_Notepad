import 'package:flutter/material.dart';
import 'package:sqlite_notepad/model/note.dart';

import '../notes_database.dart';

import '../widgets/notes_list.dart';
import 'add_edit_note_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Note> _notes = [];
  late List<Note> _notesFiltered = [];
  late List<Note> selectedNotes = [];
  int selectedFilter = 0;

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

  void _toggleIsImportant(Note note) {
    NotesDatabase.instance.update(note);
    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    this._notes = await NotesDatabase.instance.readAllNotes();
    filterNote();
    setState(() => isLoading = false);
  }

  filterNote() {
    if (selectedFilter == 0) {
      selectedNotes = _notes;
    } else if (selectedFilter == 1) {
      selectedNotes = _notes.where((element) => !element.isImportant).toList();
    } else {
      selectedNotes = _notes.where((element) => element.isImportant).toList();
    }
  }

  void toggleFilter() {
    if (selectedFilter == 0) {
      selectedFilter++;
      refreshNotes();
    } else if (selectedFilter == 1) {
      selectedFilter++;
      refreshNotes();
    } else if (selectedFilter == 2) {
      refreshNotes();
      selectedFilter = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          // Icon(Icons.category_outlined),
          TextButton(
            onPressed: toggleFilter,
            child: Text(
              selectedFilter == 0
                  ? 'All'
                  : selectedFilter == 1
                      ? 'Favorites'
                      : selectedFilter == 2
                          ? 'Not Favorite'
                          : '',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: NotesList(
        notes: selectedNotes,
        toggleIsImportant: _toggleIsImportant,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .pushNamed(AddEditNoteScreen.RouteName, arguments: {});
          },
          child: const Icon(Icons.note_add)),
    );
  }
}
