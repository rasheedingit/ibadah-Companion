import 'package:shared_preferences/shared_preferences.dart';
import '../models/reading_session.dart';
import '../models/bookmark.dart';

class StorageService {
  static const String _sessionsKey = 'reading_sessions';

  Future<List<ReadingSession>> getSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> sessionsJson = prefs.getStringList(_sessionsKey) ?? [];
    return sessionsJson.map((json) => ReadingSession.fromJson(json)).toList();
  }

  Future<void> saveSessions(List<ReadingSession> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> sessionsJson = sessions.map((s) => s.toJson()).toList();
    await prefs.setStringList(_sessionsKey, sessionsJson);
  }

  Future<void> createSession(String name) async {
    final sessions = await getSessions();
    final newSession = ReadingSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      createdAt: DateTime.now(),
    );
    sessions.insert(0, newSession);
    await saveSessions(sessions);
  }

  Future<void> updateSessionBookmark(String sessionId, Bookmark bookmark) async {
    final sessions = await getSessions();
    final index = sessions.indexWhere((s) => s.id == sessionId);
    if (index != -1) {
      final session = sessions[index];
      
      // Check if the current progress matches the last history entry
      bool isDuplicate = false;
      if (session.history.isNotEmpty) {
        final lastHistory = session.history.first;
        if (lastHistory.surahNumber == bookmark.surahNumber &&
            lastHistory.ayahNumber == bookmark.ayahNumber) {
          isDuplicate = true;
        }
      }

      List<Bookmark> newHistory = List.from(session.history);
      if (!isDuplicate) {
        newHistory.insert(0, bookmark);
        if (newHistory.length > 50) newHistory = newHistory.sublist(0, 50);
      }
      
      sessions[index] = session.copyWith(
        lastRead: bookmark,
        history: newHistory,
      );
      await saveSessions(sessions);
    }
  }

  Future<ReadingSession?> getSession(String sessionId) async {
    final sessions = await getSessions();
    try {
      return sessions.firstWhere((s) => s.id == sessionId);
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteSession(String sessionId) async {
    final sessions = await getSessions();
    sessions.removeWhere((s) => s.id == sessionId);
    await saveSessions(sessions);
  }

  Future<void> clearSessionHistory(String sessionId) async {
    final sessions = await getSessions();
    final index = sessions.indexWhere((s) => s.id == sessionId);
    if (index != -1) {
      sessions[index] = sessions[index].copyWith(
        lastRead: null,
        history: [],
      );
      await saveSessions(sessions);
    }
  }
}
