import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sqlite_notepad/model/note.dart';
import 'package:sqlite_notepad/notes_database.dart';

import '../screens/add_edit_note_screen.dart';
import 'note_item.dart';

class NotesList extends StatefulWidget {
  List<Note> notes;
  Function toggleIsImportant;
  Function refreshNotes;

  NotesList({
    Key? key,
    required this.notes,
    required this.toggleIsImportant,
    required this.refreshNotes,
  }) : super(key: key);

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.infinity,
      child: widget.notes.isNotEmpty
          ? MasonryGridView.count(
              itemCount: widget.notes.length,
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () {},
                  onTap: () async {
                    await Navigator.of(context)
                        .pushNamed(AddEditNoteScreen.RouteName, arguments: {
                      'note': widget.notes[index],
                    });
                    widget.refreshNotes();
                  },
                  child: NoteItem(
                    note: widget.notes[index],
                    toggleIsImportant: widget.toggleIsImportant,
                  ),
                );
              },
            )
          : Container(child: const Center(child: Text('NO NOTES ADDED YET'))),
    );
  }
}
