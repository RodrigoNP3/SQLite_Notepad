import 'dart:math';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:sqlite_notepad/notes_database.dart';
import '../model/note.dart';

class NoteItem extends StatefulWidget {
  Note note;
  Function toggleIsImportant;

  NoteItem({
    Key? key,
    required this.note,
    required this.toggleIsImportant,
  }) : super(key: key);

  @override
  State<NoteItem> createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
  int noteLength = 0;

  @override
  Widget build(BuildContext context) {
    noteLength = widget.note.description.length;
    return Card(
      color: Colors.amberAccent,
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(10),
        height: widget.note.description.length < 50
            ? 200
            : ((200 + (widget.note.description.length * 0.5)) > 350
                ? 350
                : (200 + (widget.note.description.length * 0.3))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.note.title,
                    overflow: TextOverflow.fade,
                  ),
                ),
                !widget.note.isImportant
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            widget.toggleIsImportant(widget.note.id);
                          });
                        },
                        icon: const Icon(
                          Icons.star,
                        ))
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            widget.toggleIsImportant(widget.note.id);
                          });
                        },
                        icon: const Icon(Icons.star_border),
                      )
              ],
            ),
            const Divider(),
            Expanded(
              child: Container(
                child: Text(
                  widget.note.description,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
            const Divider(),
            Text(
              DateFormat.yMMMEd().format(widget.note.createdTime),
            ),
          ],
        ),
      ),
    );
  }
}
