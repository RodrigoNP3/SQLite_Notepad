import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sqlite_notepad/model/note.dart';
import 'package:sqlite_notepad/notes_database.dart';

import '../screens/add_edit_note_screen.dart';
import 'note_item.dart';

class NotesList extends StatefulWidget {
  int selectedFilter;

  NotesList({
    Key? key,
    required this.selectedFilter,
  }) : super(key: key);

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  var result = '';
  bool isLoading = false;
  List<Note> notes = [];
  List<Note> selectedNotes = [];

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

  // void _toggleIsImportant(Note note) {
  //   NotesDatabase.instance.update(note);
  //   refreshNotes();
  // }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    notes = await NotesDatabase.instance.readAllNotes();
    filterNote();
    setState(() => isLoading = false);
  }

  filterNote() {
    if (widget.selectedFilter == 0) {
      selectedNotes = notes;
    } else if (widget.selectedFilter == 1) {
      selectedNotes = notes.where((element) => !element.isImportant).toList();
    } else {
      selectedNotes = notes.where((element) => element.isImportant).toList();
    }
    print(selectedNotes.length);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.selectedFilter);
    return Container(
      width: double.maxFinite,
      height: double.infinity,
      child: notes.isNotEmpty
          ? MasonryGridView.count(
              itemCount: notes.length,
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    var thisResult = await Navigator.of(context).pushNamed(
                      AddEditNoteScreen.RouteName,
                      arguments: {
                        'noteId': selectedNotes[index].id,
                        'title': selectedNotes[index].title,
                        'description': selectedNotes[index].description,
                        'isImportant': selectedNotes[index].isImportant,
                      },
                    );
                    result = thisResult as String;
                    setState(() {
                      if (result == 'update') {
                        refreshNotes();
                      }
                    });
                  },
                  child: NoteItem(id: selectedNotes[index].id as int),
                );
              },
            )
          : const Text('NO NOTES ADDED YET'),
    );
  }
}
