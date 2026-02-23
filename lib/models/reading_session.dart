import 'dart:convert';
import 'bookmark.dart';

class ReadingSession {
  final String id;
  final String name;
  final Bookmark? lastRead;
  final List<Bookmark> history;
  final DateTime createdAt;

  ReadingSession({
    required this.id,
    required this.name,
    this.lastRead,
    this.history = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastRead': lastRead?.toMap(),
      'history': history.map((x) => x.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ReadingSession.fromMap(Map<String, dynamic> map) {
    return ReadingSession(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      lastRead: map['lastRead'] != null ? Bookmark.fromMap(map['lastRead']) : null,
      history: map['history'] != null 
          ? List<Bookmark>.from(map['history']?.map((x) => Bookmark.fromMap(x)))
          : [],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReadingSession.fromJson(String source) => ReadingSession.fromMap(json.decode(source));

  ReadingSession copyWith({
    String? name,
    Bookmark? lastRead,
    List<Bookmark>? history,
  }) {
    return ReadingSession(
      id: id,
      name: name ?? this.name,
      lastRead: lastRead ?? this.lastRead,
      history: history ?? this.history,
      createdAt: createdAt,
    );
  }
}
