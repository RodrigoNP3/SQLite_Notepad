import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:sqlite_notepad/model/note.dart';
import 'package:sqlite_notepad/notes_database.dart';

import '../screens/add_edit_note_screen.dart';

class NotesList extends StatefulWidget {
  List<Note> notes;
  Function toggleIsImportant;

  NotesList({
    Key? key,
    required this.notes,
    required this.toggleIsImportant,
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
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(AddEditNoteScreen.RouteName);
                  },
                  child: Card(
                    elevation: 10,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      height: (widget.notes[index].description.length < 170)
                          ? 200
                          : 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.notes[index].title),
                              !widget.notes[index].isImportant
                                  ? IconButton(
                                      onPressed: () {
                                        widget.toggleIsImportant(Note(
                                            id: widget.notes[index].id,
                                            isImportant: !widget
                                                .notes[index].isImportant,
                                            number: widget.notes[index].number,
                                            title: widget.notes[index].title,
                                            description:
                                                widget.notes[index].description,
                                            createdTime: widget
                                                .notes[index].createdTime));
                                      },
                                      icon: const Icon(Icons.star))
                                  : IconButton(
                                      onPressed: () {
                                        widget.toggleIsImportant(Note(
                                            id: widget.notes[index].id,
                                            isImportant: !widget
                                                .notes[index].isImportant,
                                            number: widget.notes[index].number,
                                            title: widget.notes[index].title,
                                            description:
                                                widget.notes[index].description,
                                            createdTime: widget
                                                .notes[index].createdTime));
                                      },
                                      icon: const Icon(Icons.star_border),
                                    )
                            ],
                          ),
                          const Divider(),
                          Expanded(
                            child: Container(
                              child: Text(
                                widget.notes[index].description,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ),
                          const Divider(),
                          Text(
                            DateFormat.yMMMEd()
                                .format(widget.notes[index].createdTime),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : const Text('NO NOTES ADDED YET'),
    );
  }
}
