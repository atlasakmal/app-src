import 'dart:convert';

class Note {
  int? id;
  String title;
  String content;
  String tags;
  DateTime creationDate;
  DateTime lastModifiedDate;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.creationDate,
    required this.lastModifiedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'tags': tags,
      'creationDate': creationDate.toIso8601String(),
      'lastModifiedDate': lastModifiedDate.toIso8601String(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      tags: map['tags'],
      creationDate: DateTime.parse(map['creationDate']),
      lastModifiedDate: DateTime.parse(map['lastModifiedDate']),
    );
  }

  // Helper to convert Quill Delta JSON to a readable string for preview
  String get plainTextContent {
    try {
      final List<dynamic> jsonContent = jsonDecode(content);
      String text = '';
      for (var block in jsonContent) {
        if (block is Map && block.containsKey('insert')) {
          text += block['insert'].toString();
        }
      }
      return text.replaceAll('\n', ' ').trim();
    } catch (e) {
      return content; // Fallback to raw content if parsing fails
    }
  }
}


