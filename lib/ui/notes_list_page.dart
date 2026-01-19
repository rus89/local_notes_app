import 'package:flutter/material.dart';
import 'package:local_notes_app/controllers/notes_controller.dart';
import 'package:provider/provider.dart';

class NotesListPage extends StatelessWidget {
  const NotesListPage({super.key});

  ListView _buildNotesList(
    BuildContext context,
    NotesController notesController,
  ) {
    return ListView.builder(
      itemCount: notesController.notes.length,
      itemBuilder: (context, index) {
        final note = notesController.notes[index];
        return ListTile(
          title: Text(note.title.isEmpty ? '(No Title)' : note.title),
          subtitle: Text(
            note.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tapped on note: ${note.title}')),
            );
          },
          onLongPress: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Note'),
                content: const Text(
                  'Are you sure you want to delete this note? This action cannot be undone.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
            if (confirm == true && context.mounted) {
              context.read<NotesController>().deleteNote(note.id!);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var notesController = context.watch<NotesController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Local Notes')),
      body: notesController.notes.isEmpty
          ? Center(
              child: Text(
                'No notes available.',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            )
          : _buildNotesList(context, notesController),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<NotesController>().addNote(
            title: 'New Note',
            content: 'This is a new note.',
          );
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
