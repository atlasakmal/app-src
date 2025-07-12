import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:advanced_notepad_app/data/models/note.dart';
import 'package:advanced_notepad_app/providers/note_provider.dart';
import 'dart:async';

class NoteDetailScreen extends StatefulWidget {
  final Note? note;

  const NoteDetailScreen({super.key, this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  Timer? _autosaveTimer;

  // For rich text editing
  TextEditingController _richTextController = TextEditingController();
  TextStyle _currentTextStyle = const TextStyle();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _tagsController.text = widget.note!.tags;
      _richTextController.text = widget.note!.content; // Initialize rich text editor with content
    }

    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);
    _tagsController.addListener(_onTextChanged);
    _richTextController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_autosaveTimer != null && _autosaveTimer!.isActive) {
      _autosaveTimer!.cancel();
    }
    _autosaveTimer = Timer(const Duration(seconds: 2), () {
      _saveNote(isAutosave: true);
    });
  }

  @override
  void dispose() {
    _autosaveTimer?.cancel();
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    _richTextController.dispose();
    super.dispose();
  }

  void _saveNote({bool isAutosave = false}) {
    final title = _titleController.text;
    final content = _richTextController.text; // Use content from rich text editor
    final tags = _tagsController.text;

    if (title.isEmpty) {
      if (!isAutosave) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Title cannot be empty")),
        );
      }
      return;
    }

    if (widget.note == null) {
      // New note
      final newNote = Note(
        title: title,
        content: content,
        tags: tags,
        creationDate: DateTime.now(),
        lastModifiedDate: DateTime.now(),
      );
      Provider.of<NoteProvider>(context, listen: false).addNote(newNote);
    } else {
      // Existing note
      final updatedNote = Note(
        id: widget.note!.id,
        title: title,
        content: content,
        tags: tags,
        creationDate: widget.note!.creationDate,
        lastModifiedDate: DateTime.now(),
      );
      Provider.of<NoteProvider>(context, listen: false).updateNote(updatedNote);
    }
    if (!isAutosave) {
      Navigator.pop(context);
    }
  }

  void _deleteNote() {
    if (widget.note != null) {
      Provider.of<NoteProvider>(context, listen: false).deleteNote(widget.note!.id!); 
      Navigator.pop(context);
    }
  }

  void _applyStyle(TextStyle style) {
    final currentText = _richTextController.text;
    final selection = _richTextController.selection;

    if (selection.isValid && selection.textInside(currentText).isNotEmpty) {
      final start = selection.start;
      final end = selection.end;
      final selectedText = selection.textInside(currentText);

      // This is a very basic implementation and doesn't handle complex rich text.
      // For true rich text, you'd need to parse and apply styles to a structured document.
      // For simplicity, we'll just wrap the selected text with a placeholder for now.
      // In a real app, you'd likely use a library like flutter_quill or zefyr.
      String newText;
      if (style.fontWeight == FontWeight.bold) {
        newText = '${currentText.substring(0, start)}**$selectedText**${currentText.substring(end)}';
      } else if (style.fontStyle == FontStyle.italic) {
        newText = '${currentText.substring(0, start)}*${selectedText}*${currentText.substring(end)}';
      } else if (style.decoration == TextDecoration.underline) {
        newText = '${currentText.substring(0, start)}__${selectedText}__${currentText.substring(end)}';
      } else {
        newText = currentText;
      }
      _richTextController.text = newText;
      _richTextController.selection = TextSelection.collapsed(offset: start + newText.length - currentText.length + selectedText.length); // Adjust selection
    } else {
      // If no text is selected, apply style to the next typed characters
      setState(() {
        _currentTextStyle = style;
      });
    }
  }

  void _toggleBold() {
    _applyStyle(const TextStyle(fontWeight: FontWeight.bold));
  }

  void _toggleItalic() {
    _applyStyle(const TextStyle(fontStyle: FontStyle.italic));
  }

  void _toggleUnderline() {
    _applyStyle(const TextStyle(decoration: TextDecoration.underline));
  }

  void _toggleBulletPoint() {
    final currentText = _richTextController.text;
    final selection = _richTextController.selection;

    if (selection.isValid) {
      final lines = currentText.split('\n');
      final startLine = currentText.substring(0, selection.start).split('\n').length - 1;
      final endLine = currentText.substring(0, selection.end).split('\n').length - 1;

      for (int i = startLine; i <= endLine; i++) {
        if (lines[i].trim().startsWith('• ')) {
          lines[i] = lines[i].trim().substring(2);
        } else {
          lines[i] = '• ${lines[i].trim()}';
        }
      }
      _richTextController.text = lines.join('\n');
    } else {
      // If no selection, add bullet point to current line
      final cursorPosition = _richTextController.selection.start;
      final textBeforeCursor = currentText.substring(0, cursorPosition);
      final textAfterCursor = currentText.substring(cursorPosition);
      final lastNewlineIndex = textBeforeCursor.lastIndexOf('\n');
      final currentLineStart = lastNewlineIndex == -1 ? 0 : lastNewlineIndex + 1;
      final currentLine = textBeforeCursor.substring(currentLineStart);

      if (currentLine.trim().startsWith('• ')) {
        _richTextController.text = textBeforeCursor.substring(0, currentLineStart) + currentLine.trim().substring(2) + textAfterCursor;
        _richTextController.selection = TextSelection.collapsed(offset: cursorPosition - 2); // Adjust cursor
      } else {
        _richTextController.text = textBeforeCursor.substring(0, currentLineStart) + '• ' + currentLine.trim() + textAfterCursor;
        _richTextController.selection = TextSelection.collapsed(offset: cursorPosition + 2); // Adjust cursor
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? "New Note" : "Edit Note"),
        actions: [
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteNote,
            ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveNote(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: "Tags (comma-separated)",
                border: OutlineInputBorder(),
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.format_bold),
                  onPressed: _toggleBold,
                ),
                IconButton(
                  icon: const Icon(Icons.format_italic),
                  onPressed: _toggleItalic,
                ),
                IconButton(
                  icon: const Icon(Icons.format_underline),
                  onPressed: _toggleUnderline,
                ),
                IconButton(
                  icon: const Icon(Icons.format_list_bulleted),
                  onPressed: _toggleBulletPoint,
                ),
              ],
            ),
            Expanded(
              child: TextField(
                controller: _richTextController,
                maxLines: null, // Allows for multiline input
                expands: true, // Allows the TextField to expand to fill available space
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  labelText: "Content",
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                keyboardType: TextInputType.multiline,
                style: _currentTextStyle, // Apply current style
              ),
            ),
          ],
        ),
      ),
    );
  }
}


