import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqlite_notepad/model/note.dart';
import '../notes_database.dart';

class AddEditNoteScreen extends StatefulWidget {
  final String initTitle;
  final String initDescription;
  final bool initisImportant;

  static String RouteName = '/AddEditNoteScreen';

  AddEditNoteScreen({
    Key? key,
    this.initTitle = '',
    this.initDescription = '',
    this.initisImportant = false,
  }) : super(key: key);

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  String title = '';
  String description = '';
  int noteId = -1;
  bool isImportant = false;
  bool isEditing = false;
  late Note thisnote;

  bool boolSetData = true;

  void _submit() {
    if (title.trim().isEmpty && description.trim().isEmpty) {
      print('ADD A DESCRIPTION');
    } else {
      if (!isEditing) {
        print('add');
        Note note = Note(
            isImportant: !isImportant,
            number: 0,
            title: title,
            description: description,
            createdTime: DateTime.now());
        NotesDatabase.instance.create(note);
      } else {
        print('update');
        Note note = Note(
            id: noteId,
            isImportant: !isImportant,
            number: thisnote.number,
            title: title,
            description: description,
            createdTime: thisnote.createdTime);
        NotesDatabase.instance.update(note);
      }
      String asd = 'asd';
      Navigator.pop(context, 'update');
    }
  }

  void setData(Map<String, dynamic> data) async {
    if (boolSetData) {
      if (data['title'] != '' || data['description'] != '') {
        setState(() {
          isEditing = true;
        });
        title = data['title'];
        noteId = data['noteId'];
        description = data['description'];
        isImportant = !data['isImportant'];
        thisnote = await NotesDatabase.instance.readNote(noteId);
      }

      boolSetData = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    setData(data);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'EDIT NOTE' : 'ADD NOTE'),
        actions: [
          IconButton(
              onPressed: () {
                if (isEditing) {
                  NotesDatabase.instance.delete(thisnote.id as int);
                  Navigator.pop(context, 'update');
                }
              },
              icon: const Icon(Icons.delete)),
          IconButton(onPressed: _submit, icon: const Icon(Icons.save))
        ],
      ),
      body: Container(
        color: Colors.amberAccent,
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Title',
                      ),
                      onChanged: (value) {
                        title = value;
                        print(title);
                      },
                      autocorrect: true,
                      initialValue: title,
                      // controller: titleController,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isImportant = !isImportant;
                      });
                    },
                    icon: Icon(!isImportant ? Icons.star_outline : Icons.star),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TextFormField(
                onChanged: (value) {
                  description = value;
                  print(description);
                },
                autocorrect: true,
                initialValue: description,
                maxLines: 20,
                decoration: const InputDecoration(
                  hintText: 'Description',
                ),
                // controller: titleController),
              ),
            ),
            Text(DateFormat.yMMMMEEEEd().format(DateTime.now())),
          ],
        ),
      ),
    );
  }
}
