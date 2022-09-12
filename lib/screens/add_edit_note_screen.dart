import 'package:flutter/material.dart';

import '../widgets/app_text_field.dart';

class AddEditNoteScreen extends StatefulWidget {
  static String RouteName = '/AddEditNoteScreen';

  bool isImportant;
  bool isEditing;

  AddEditNoteScreen({
    Key? key,
    this.isImportant = false,
    this.isEditing = false,
  }) : super(key: key);

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  @override
  Widget build(BuildContext context) {
    var titleController = TextEditingController();
    var descriptionController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADD OR EDIT NOT'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.cancel)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.save)),
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
