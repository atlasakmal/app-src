import 'package:flutter/material.dart';
import 'package:advanced_notepad_app/data/models/note.dart';
import 'package:advanced_notepad_app/repositories/note_repository.dart';

class NoteProvider with ChangeNotifier {
  final NoteRepository _noteRepository = NoteRepository();
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];

  List<Note> get notes => _filteredNotes;

  NoteProvider() {
    loadNotes();
  }

  Future<void> loadNotes() async {
    _notes = await _noteRepository.getNotes();
    _filteredNotes = List.from(_notes);
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    await _noteRepository.insertNote(note);
    await loadNotes();
  }

  Future<void> updateNote(Note note) async {
    await _noteRepository.updateNote(note);
    await loadNotes();
  }

  Future<void> deleteNote(int id) async {
    await _noteRepository.deleteNote(id);
    await loadNotes();
  }

  void searchNotes(String query) {
    if (query.isEmpty) {
      _filteredNotes = List.from(_notes);
    } else {
      _filteredNotes = _notes.where((note) {
        final titleLower = note.title.toLowerCase();
        final contentLower = note.content.toLowerCase();
        final tagsLower = note.tags.toLowerCase();
        final searchQuery = query.toLowerCase();

        return titleLower.contains(searchQuery) ||
            contentLower.contains(searchQuery) ||
            tagsLower.contains(searchQuery);
      }).toList();
    }
    notifyListeners();
  }

  void sortNotes(String sortBy) {
    switch (sortBy) {
      case 'title':
        _filteredNotes.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case 'creationDate':
        _filteredNotes.sort((a, b) => b.creationDate.compareTo(a.creationDate));
        break;
      case 'lastModifiedDate':
        _filteredNotes.sort((a, b) => b.lastModifiedDate.compareTo(a.lastModifiedDate));
        break;
    }
    notifyListeners();
  }
}


