import 'package:flutter/material.dart';
import 'package:local_notes_app/controllers/notes_controller.dart';
import 'package:local_notes_app/models/note.dart';
import 'package:provider/provider.dart';

//------------------------------------------------------------------------------
class EditNotePage extends StatefulWidget {
  final Note? existingNote;
  const EditNotePage({super.key, this.existingNote});

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

//------------------------------------------------------------------------------
class _EditNotePageState extends State<EditNotePage> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.existingNote?.title ?? '',
    );
    _contentController = TextEditingController(
      text: widget.existingNote?.content ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final controller = context.read<NotesController>();

    if (widget.existingNote == null) {
      await controller.addNote(title: title, content: content);
    } else {
      final updatedNote = widget.existingNote!.copyWith(
        title: title,
        content: content,
      );
      await controller.updateNote(updatedNote);
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingNote != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'New Note'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _saveNote),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Title',
              ),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Start typing...',
                ),
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
