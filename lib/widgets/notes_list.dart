import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:sqlite_notepad/model/note.dart';

class NotesList extends StatefulWidget {
  List<Note> notes;

  NotesList({Key? key, required this.notes}) : super(key: key);

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
                return Card(
                  elevation: 10,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    height: (widget.notes[index].description.length < 50)
                        ? widget.notes[index].description.length * 15
                        : 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.notes[index].title),
                            widget.notes[index].isImportant
                                ? const Icon(Icons.flag)
                                : Container()
                          ],
                        ),
                        const Divider(),
                        Expanded(
                          child: Container(
                              child: Text(widget.notes[index].description)),
                        ),
                        const Divider(),
                        Text(
                          DateFormat.yMMMEd()
                              .format(widget.notes[index].createdTime),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Text('NO NOTES ADDED YET'),
    );
  }
}
