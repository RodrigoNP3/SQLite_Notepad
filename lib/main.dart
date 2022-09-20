import 'package:flutter/material.dart';
import 'package:sqlite_notepad/notes_database.dart';
import 'package:sqlite_notepad/screens/MainScreen.dart';
import 'package:sqlite_notepad/screens/add_edit_note_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: MainScreen.RouteName,
      routes: {
        MainScreen.RouteName: (context) => const MainScreen(),
        AddEditNoteScreen.RouteName: (context) => AddEditNoteScreen(),
      },
    );
  }
}
