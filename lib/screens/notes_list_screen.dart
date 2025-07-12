import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:advanced_notepad_app/data/models/note.dart';
import 'package:advanced_notepad_app/providers/note_provider.dart';
import 'package:advanced_notepad_app/providers/theme_provider.dart';
import 'package:advanced_notepad_app/screens/note_detail_screen.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load notes when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NoteProvider>(context, listen: false).loadNotes();
    });
    _searchController.addListener(() {
      Provider.of<NoteProvider>(context, listen: false).searchNotes(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: NoteSearchDelegate());
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'toggleTheme') {
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme(
                  Theme.of(context).brightness == Brightness.light,
                );
              } else {
                Provider.of<NoteProvider>(context, listen: false).sortNotes(value);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'title',
                child: Text('Sort by Title'),
              ),
              const PopupMenuItem<String>(
                value: 'creationDate',
                child: Text('Sort by Creation Date'),
              ),
              const PopupMenuItem<String>(
                value: 'lastModifiedDate',
                child: Text('Sort by Last Modified'),
              ),
              const PopupMenuItem<String>(
                value: 'toggleTheme',
                child: Text('Toggle Theme'),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<NoteProvider>(
        builder: (context, noteProvider, child) {
          if (noteProvider.notes.isEmpty) {
            return const Center(
              child: Text('No notes yet. Start by adding a new note!'),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two cards per row
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.8, // Adjust as needed
            ),
            itemCount: noteProvider.notes.length,
            itemBuilder: (context, index) {
              final note = noteProvider.notes[index];
              return Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteDetailScreen(note: note),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8.0),
                        Expanded(
                          child: Text(
                            note.plainTextContent, // Use plainTextContent for preview
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Last Modified: ${note.lastModifiedDate.day}/${note.lastModifiedDate.month}/${note.lastModifiedDate.year}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (note.tags.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              'Tags: ${note.tags}',
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteDetailScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoteSearchDelegate extends SearchDelegate<Note?> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Provider.of<NoteProvider>(context, listen: false).searchNotes(query);
    return Consumer<NoteProvider>(
      builder: (context, noteProvider, child) {
        if (noteProvider.notes.isEmpty) {
          return const Center(
            child: Text('No notes found.'),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.8,
          ),
          itemCount: noteProvider.notes.length,
          itemBuilder: (context, index) {
            final note = noteProvider.notes[index];
            return Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteDetailScreen(note: note),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8.0),
                      Expanded(
                        child: Text(
                          note.plainTextContent,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Last Modified: ${note.lastModifiedDate.day}/${note.lastModifiedDate.month}/${note.lastModifiedDate.year}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (note.tags.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Tags: ${note.tags}',
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Provider.of<NoteProvider>(context, listen: false).searchNotes(query);
    return Consumer<NoteProvider>(
      builder: (context, noteProvider, child) {
        if (noteProvider.notes.isEmpty) {
          return const Center(
            child: Text('No notes found.'),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.8,
          ),
          itemCount: noteProvider.notes.length,
          itemBuilder: (context, index) {
            final note = noteProvider.notes[index];
            return Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteDetailScreen(note: note),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title,
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8.0),
                      Expanded(
                        child: Text(
                          note.plainTextContent,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Last Modified: ${note.lastModifiedDate.day}/${note.lastModifiedDate.month}/${note.lastModifiedDate.year}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (note.tags.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Tags: ${note.tags}',
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}


