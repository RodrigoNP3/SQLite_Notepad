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
  // late List<Note> _notesFiltered = [];
  late List<Note> selectedNotes = [];
  int _selectedFilter = 0;
  bool initApp = true;
  bool isLoading = false;

  void toggleFilter() {
    if (_selectedFilter == 0) {
      _selectedFilter++;
      refreshNotes();
    } else if (_selectedFilter == 1) {
      _selectedFilter++;
      refreshNotes();
    } else if (_selectedFilter == 2) {
      refreshNotes();
      _selectedFilter = 0;
    }
    setState(() {});
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

  void _toggleIsImportant(int id) {
    NotesDatabase.instance.toggleIsImportant(id);
    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() {
      isLoading = true;
      selectedNotes = [];
    });
    _notes = await NotesDatabase.instance.readAllNotes();
    filterNote();
    setState(() {
      isLoading = false;
    });
  }

  filterNote() {
    if (_selectedFilter == 0) {
      selectedNotes = _notes;
    } else if (_selectedFilter == 1) {
      selectedNotes = _notes.where((element) => !element.isImportant).toList();
    } else {
      selectedNotes = _notes.where((element) => element.isImportant).toList();
    }
    print(selectedNotes.length);
  }

  @override
  Widget build(BuildContext context) {
    Object? result = '';
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          TextButton(
            onPressed: toggleFilter,
            child: Text(
              _selectedFilter == 0
                  ? 'All'
                  : _selectedFilter == 1
                      ? 'Important'
                      : _selectedFilter == 2
                          ? 'Not Important'
                          : '',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(_selectedFilter == 0
                ? Icons.circle
                : _selectedFilter == 1
                    ? Icons.star
                    : _selectedFilter == 2
                        ? Icons.star_border
                        : Icons.remove_circle),
          ),
        ],
      ),
      body: isLoading
          ? Container(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : NotesList(
              notes: selectedNotes,
              toggleIsImportant: _toggleIsImportant,
              refreshNotes: refreshNotes,
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.of(context).pushNamed(
              AddEditNoteScreen.RouteName,
              arguments: {
                'note': Note(
                    isImportant: false,
                    number: 0,
                    title: '',
                    description: '',
                    createdTime: DateTime.now())
              },
            );
            setState(() {
              refreshNotes();
            });
          },
          child: const Icon(Icons.note_add)),
    );
  }
}
