import 'package:advanced_notepad_app/data/database/database_helper.dart';
import 'package:advanced_notepad_app/data/models/note.dart';

class NoteRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertNote(Note note) async {
    return await _databaseHelper.insertNote(note);
  }

  Future<List<Note>> getNotes() async {
    return await _databaseHelper.getNotes();
  }

  Future<int> updateNote(Note note) async {
    return await _databaseHelper.updateNote(note);
  }

  Future<int> deleteNote(int id) async {
    return await _databaseHelper.deleteNote(id);
  }
}


