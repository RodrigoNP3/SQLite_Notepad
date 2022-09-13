import 'package:flutter/material.dart';
import 'package:sqlite_notepad/model/note.dart';

import '../widgets/app_text_field.dart';
import '../notes_database.dart';

class AddEditNoteScreen extends StatefulWidget {
  static String RouteName = '/AddEditNoteScreen';

  bool isImportant = false;
  bool isEditing = false;

  // AddEditNoteScreen({
  //   Key? key,
  //   this.isImportant = false,

  // }) : super(key: key);

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    void _submit() {
      String title = titleController.text.trim();
      String description = descriptionController.text.trim();

      if (title.isEmpty && description.isEmpty) {
        print('ADD A DESCRIPTION');
      } else {
        Note note = Note(
            isImportant: widget.isImportant,
            number: 0,
            title: title,
            description:
                'Description Description Description Description Description Description Description Description Description Description Description Description Description Description',
            createdTime: DateTime.now());

        NotesDatabase.instance.create(note);
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Note' : 'Add Note'),
        actions: [
          widget.isEditing
              ? IconButton(onPressed: () {}, icon: const Icon(Icons.delete))
              : IconButton(onPressed: () {}, icon: const Icon(Icons.cancel)),
          IconButton(onPressed: _submit, icon: const Icon(Icons.save)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppTextField(
              hintText: 'Title',
              icon: Icons.title,
              textController: titleController,
            ),
            AppTextField(
              hintText: 'Description',
              icon: Icons.description_outlined,
              textController: descriptionController,
              lines: 15,
            ),
            Container(
              width: double.infinity,
              height: 60,
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30), //Dimentions.radius30),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 7,
                    offset: const Offset(1, 10),
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('Important'),
                  Switch(
                      activeColor: Colors.green,
                      value: widget.isImportant,
                      onChanged: (bool newValue) {
                        setState(() {
                          widget.isImportant = newValue;
                        });
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
