import 'package:flutter/material.dart';
import 'package:sqlite_notepad/model/note.dart';

import '../notes_database.dart';

import '../widgets/notes_list.dart';
import 'add_edit_note_screen.dart';

class MainScreen extends StatefulWidget {
  static String RouteName = '/main-screen';
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Note> _notes = [];
  late List<Note> _notesFiltered = [];
  late List<Note> selectedNotes = [];
  int _selectedFilter = 0;

  bool initApp = true;

  bool isLoading = false;

  void toggleFilter() {
    if (_selectedFilter == 0) {
      _selectedFilter++;
      // refreshNotes();
    } else if (_selectedFilter == 1) {
      _selectedFilter++;
      // refreshNotes();
    } else if (_selectedFilter == 2) {
      // refreshNotes();
      _selectedFilter = 0;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Object? result = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          TextButton(
            onPressed: toggleFilter,
            child: Text(
              _selectedFilter == 0
                  ? 'All'
                  : _selectedFilter == 1
                      ? 'Favorites'
                      : _selectedFilter == 2
                          ? 'Not Favorite'
                          : '',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: NotesList(
        selectedFilter: _selectedFilter,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            result = await Navigator.of(context).pushNamed(
              AddEditNoteScreen.RouteName,
              arguments: {
                'noteId': -1,
                'title': '',
                'description': '',
                'isImportant': false,
              },
            );
            if (result == 'update') {
              setState(() {});
            }
          },
          child: const Icon(Icons.note_add)),
    );
  }
}
