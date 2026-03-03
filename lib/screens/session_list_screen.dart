import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/reading_session.dart';
import '../models/bookmark.dart';
import '../widgets/skeuo_container.dart';
import '../constants/quran_data.dart';
import 'home_screen.dart';

class SessionListScreen extends StatefulWidget {
  const SessionListScreen({super.key});

  @override
  State<SessionListScreen> createState() => _SessionListScreenState();
}

class _SessionListScreenState extends State<SessionListScreen> {
  final StorageService _storageService = StorageService();
  List<ReadingSession> _sessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    setState(() => _isLoading = true);
    final sessions = await _storageService.getSessions();
    setState(() {
      _sessions = sessions;
      _isLoading = false;
    });
  }

  int _calculateTotalVersesRead(Bookmark? bookmark) {
    if (bookmark == null) return 0;
    int total = 0;
    for (var surah in QuranData.surahs) {
      if (surah['name'] == bookmark.surahName) {
        break;
      }
      total += surah['ayahs'] as int;
    }
    total += bookmark.ayahNumber;
    return total;
  }

  Future<void> _createNewSession() async {
    final TextEditingController controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1C1E),
        title: const Text("New Reading Session", style: TextStyle(color: Color(0xFF2ECC71))),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "e.g. Ramadan 2026",
            hintStyle: TextStyle(color: Colors.white24),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2ECC71))),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2ECC71), foregroundColor: Colors.black),
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await _storageService.createSession(controller.text);
                if (!context.mounted) return;
                Navigator.pop(context);
                _loadSessions();
              }
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C1E),
      appBar: AppBar(
        title: const Text('Reading Sessions', 
          style: TextStyle(color: Color(0xFF2ECC71), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2ECC71)))
          : _sessions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        // "logo.png",
                        "assets/logo.png",
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 24),
                      const Text("No sessions created yet.", style: TextStyle(color: Colors.white60)),
                      const SizedBox(height: 20),
                      SkeuoButton(
                        onTap: _createNewSession,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: const Text("Create Your First Session", style: TextStyle(color: Color(0xFF2ECC71))),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _sessions.length,
                  itemBuilder: (context, index) {
                    final session = _sessions[index];
                    final versesRead = _calculateTotalVersesRead(session.lastRead);
                    final progress = (versesRead / QuranData.totalVerses).clamp(0.0, 1.0);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: SkeuoButton(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(sessionId: session.id),
                            ),
                          ).then((_) => _loadSessions());
                        },
                        child: Row(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 45,
                                  height: 45,
                                  child: CircularProgressIndicator(
                                    value: progress,
                                    strokeWidth: 4,
                                    backgroundColor: Colors.white.withValues(alpha: 0.05),
                                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2ECC71)),
                                  ),
                                ),
                                 // const Icon(Icons.book, color: Color(0xFF2ECC71), size: 20),
                                Text(
                                  "${(progress * 100).toStringAsFixed(1)}%",
                                  style: const TextStyle(color: Color(0xFF2ECC71), fontWeight: FontWeight.bold, fontSize: 10),
                                )
                              ],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    session.name,
                                    style: const TextStyle(
                                      fontSize: 18, 
                                      fontWeight: FontWeight.bold, 
                                      color: Colors.white
                                    ),
                                  ),
                                  Text(
                                    session.lastRead != null
                                        ? "Last mark: ${session.lastRead!.surahName} ${session.lastRead!.ayahNumber}"
                                        : "Not started yet",
                                    style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Text(
                                //   "${(progress * 100).toStringAsFixed(1)}%",
                                //   style: const TextStyle(color: Color(0xFF2ECC71), fontWeight: FontWeight.bold, fontSize: 14),
                                // ),
                                Icon(Icons.chevron_right, color: Colors.white24, size: 20),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewSession,
        backgroundColor: const Color(0xFF2ECC71),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
