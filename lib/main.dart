import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:advanced_notepad_app/providers/note_provider.dart';
import 'package:advanced_notepad_app/providers/theme_provider.dart';
import 'package:advanced_notepad_app/screens/notes_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Advanced Notepad',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
              useMaterial3: true,
              brightness: Brightness.dark,
            ),
            themeMode: themeProvider.themeMode,
            home: const NotesListScreen(),
          );
        },
      ),
    );
  }
}


