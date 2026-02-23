import 'dart:convert';

class Bookmark {
  final String surahName;
  final int surahNumber;
  final int ayahNumber;
  final DateTime timestamp;

  Bookmark({
    required this.surahName,
    required this.surahNumber,
    required this.ayahNumber,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'surahName': surahName,
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      surahName: map['surahName'] ?? '',
      surahNumber: map['surahNumber'] ?? 0,
      ayahNumber: map['ayahNumber'] ?? 0,
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Bookmark.fromJson(String source) => Bookmark.fromMap(json.decode(source));
}
