import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:sqlite_notepad/notes_database.dart';
import '../model/note.dart';

class NoteItem extends StatefulWidget {
  int id;

  NoteItem({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<NoteItem> createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
  late Note note;

  void readNote() async {
    note = await NotesDatabase.instance.readNote(widget.id);
    setState(() {});
  }

  @override
  void initState() {
    readNote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.amberAccent,
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(10),
        height: (note.description.length < 170) ? 200 : 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    note.title,
                    overflow: TextOverflow.fade,
                  ),
                ),
                !note.isImportant
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            NotesDatabase.instance
                                .toggleIsImportant(note.id as int);
                            readNote();
                          });
                        },
                        icon: const Icon(
                          Icons.star,
                        ))
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            NotesDatabase.instance
                                .toggleIsImportant(note.id as int);
                            readNote();
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
                  note.description,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
            const Divider(),
            Text(
              DateFormat.yMMMEd().format(note.createdTime),
            ),
          ],
        ),
      ),
    );
  }
}
