import 'package:flutter/foundation.dart';
import 'package:local_notes_app/data/notes_repository.dart';
import 'package:local_notes_app/models/note.dart';

//------------------------------------------------------------------------------
class NotesController extends ChangeNotifier {
  final NotesRepository _repository;

  List<Note> _notes = [];
  List<Note> get notes => _notes;
  bool isLoading = false;

  NotesController(this._repository);

  //------------------------------------------------------------------------------
  Future<void> initializeNote() async {
    await _repository.init();
    _notes = await _repository.getAllNotes();
    notifyListeners();
  }

  //------------------------------------------------------------------------------
  Future<void> addNote({required String title, required String content}) async {
    await _repository.addNote(title: title, content: content);
    await _refreshNotes();
  }

  //------------------------------------------------------------------------------
  Future<void> updateNote(Note note) async {
    await _repository.updateNote(note);
    await _refreshNotes();
  }

  //------------------------------------------------------------------------------
  Future<void> deleteNote(int id) async {
    await _repository.deleteNote(id);
    await _refreshNotes();
  }

  //------------------------------------------------------------------------------
  Future<void> _refreshNotes() async {
    isLoading = true;
    notifyListeners();
    _notes = await _repository.getAllNotes();
    isLoading = false;
    notifyListeners();
  }
}
