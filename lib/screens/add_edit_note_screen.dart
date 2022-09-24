import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqlite_notepad/model/note.dart';
import '../notes_database.dart';

class AddEditNoteScreen extends StatefulWidget {
  // final String initTitle;
  // final String initDescription;
  // final bool initisImportant;

  static String RouteName = '/AddEditNoteScreen';

  // AddEditNoteScreen({
  //   Key? key,
  //   this.initTitle = '',
  //   this.initDescription = '',
  //   this.initisImportant = false,
  // }) : super(key: key);

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  late Note note;
  bool isEditing = false;
  bool boolSetData = true;
  String title = '';
  String description = '';
  bool isImportant = false;
  var lines;

  void _submit(Note note) {
    if (title.trim().isEmpty && description.trim().isEmpty) {
      print('ADD A DESCRIPTION');
    } else {
      if (!isEditing) {
        print('add');
        Note thisnote = Note(
          isImportant: !isImportant,
          number: 0,
          title: title,
          description: description,
          createdTime: DateTime.now(),
        );
        NotesDatabase.instance.create(thisnote);
      } else {
        print('update');
        Note thisnote = Note(
            id: note.id,
            isImportant: !isImportant,
            number: note.number,
            title: title,
            description: description,
            createdTime: note.createdTime);
        NotesDatabase.instance.update(thisnote);
      }
      Navigator.pop(context);
    }
  }

  void setData(Map<String, dynamic> data) async {
    note = data['note'];
    if (boolSetData) {
      if (note.title != '' || note.description != '') {
        setState(() {
          isEditing = true;
        });
        title = note.title;
        description = note.description;
        isImportant = !note.isImportant;
// thisnote = await NotesDatabase.instance.readNote(noteId);
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
                NotesDatabase.instance.delete(note.id as int);
                Navigator.pop(context);
              } else {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () => _submit(note),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      initialValue: note.title,
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
                },
                autocorrect: true,
                initialValue: note.description,
                maxLines: 25,
                decoration: const InputDecoration(
                  hintText: 'Description',
                ),
                // controller: titleController),
              ),
            ),
            Container(
              height: 50,
              child: Center(
                child: Text(
                  DateFormat.yMMMMEEEEd().format(DateTime.now()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
