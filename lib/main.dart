import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:local_notes_app/controllers/notes_controller.dart';
import 'package:local_notes_app/data/notes_repository.dart';

//------------------------------------------------------------------------------
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final notesRepository = NotesRepository();

  runApp(
    MultiProvider(
      providers: [
        Provider<NotesRepository>.value(value: notesRepository),
        ChangeNotifierProvider<NotesController>(
          create: (_) => NotesController(notesRepository),
        ),
      ],
      child: const NoteApp(),
    ),
  );
}

//------------------------------------------------------------------------------
class NoteApp extends StatefulWidget {
  const NoteApp({super.key});

  @override
  State<NoteApp> createState() => _NoteAppState();
}

//------------------------------------------------------------------------------
class _NoteAppState extends State<NoteApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
      ),
      home: const NotesRoot(),
    );
  }
}

//------------------------------------------------------------------------------
class NotesRoot extends StatefulWidget {
  const NotesRoot({super.key});

  @override
  State<NotesRoot> createState() => _NotesRootState();
}

//------------------------------------------------------------------------------
class _NotesRootState extends State<NotesRoot> {
  @override
  void initState() {
    super.initState();
    context.read<NotesController>().initializeNote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: const Center(child: Text('Welcome to Local Notes App!')),
    );
  }
}
