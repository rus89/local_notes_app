import 'package:local_notes_app/models/note.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class NotesRepository {
  Database? _database;

  //------------------------------------------------------------------------------
  Future<void> init() async {
    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, 'local_notes.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            createdAt INTEGER NOT NULL,
            updatedAt INTEGER NOT NULL
          )
        ''');
        await db.execute(
          'CREATE INDEX idx_notes_updatedAt ON notes (updatedAt DESC)',
        );
      },
    );
  }

  //------------------------------------------------------------------------------
  Database get database {
    if (_database == null) {
      throw Exception('Database not initialized. Call init() first.');
    }
    return _database!;
  }

  //------------------------------------------------------------------------------
  Future<List<Note>> getAllNotes() async {
    final db = database;
    final maps = await db.query('notes', orderBy: 'updatedAt DESC');
    return maps.map((map) => Note.fromMap(map)).toList();
  }

  //------------------------------------------------------------------------------
  Future<Note> addNote({required String title, required String content}) async {
    final db = database;
    final now = DateTime.now();
    final id = await db.insert('notes', {
      'title': title,
      'content': content,
      'createdAt': now.millisecondsSinceEpoch,
      'updatedAt': now.millisecondsSinceEpoch,
    });
    return Note(
      id: id,
      title: title,
      content: content,
      createdAt: now,
      updatedAt: now,
    );
  }

  //------------------------------------------------------------------------------
  Future<void> updateNote(Note note) async {
    final db = database;
    await db.update(
      'notes',
      {
        'title': note.title,
        'content': note.content,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  //------------------------------------------------------------------------------
  Future<void> deleteNote(int id) async {
    final db = database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
