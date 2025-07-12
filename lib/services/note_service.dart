import 'package:advanced_notepad_app/data/models/note.dart';
import 'package:advanced_notepad_app/repositories/note_repository.dart';

class NoteService {
  final NoteRepository _noteRepository = NoteRepository();

  Future<int> addNote(Note note) async {
    return await _noteRepository.insertNote(note);
  }

  Future<List<Note>> getNotes() async {
    return await _noteRepository.getNotes();
  }

  Future<int> updateNote(Note note) async {
    return await _noteRepository.updateNote(note);
  }

  Future<int> deleteNote(int id) async {
    return await _noteRepository.deleteNote(id);
  }
}


