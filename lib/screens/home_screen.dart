import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/bookmark.dart';
import '../models/reading_session.dart';
import '../services/storage_service.dart';
import '../widgets/skeuo_container.dart';
import '../constants/quran_data.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  final String sessionId;
  const HomeScreen({super.key, required this.sessionId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  ReadingSession? _session;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessionData();
  }

  Future<void> _loadSessionData() async {
    setState(() => _isLoading = true);
    final session = await _storageService.getSession(widget.sessionId);
    setState(() {
      _session = session;
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

  Future<void> _addNewBookmark() async {
    Map<String, dynamic> selectedSurah = QuranData.surahs[0];
    int currentSurahIndex = 0;

    if (_session?.lastRead != null) {
      currentSurahIndex = QuranData.surahs.indexWhere(
        (s) => s['name'] == _session!.lastRead!.surahName,
      );
      if (currentSurahIndex != -1) {
        selectedSurah = QuranData.surahs[currentSurahIndex];
      } else {
        currentSurahIndex = 0;
      }
    }

    final TextEditingController ayahController = TextEditingController(
      text: _session?.lastRead != null ? _session!.lastRead!.ayahNumber.toString() : "1",
    );
    final TextEditingController searchController = TextEditingController(text: selectedSurah['name']);
    
    String? errorText;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          String query = searchController.text.toLowerCase();
          List<Map<String, dynamic>> suggestions = [];
          
          if (query.isEmpty || query == selectedSurah['name'].toLowerCase()) {
            for (int i = currentSurahIndex; i < currentSurahIndex + 4; i++) {
              if (i < QuranData.surahs.length) suggestions.add(QuranData.surahs[i]);
            }
          } else {
            suggestions = QuranData.surahs.where((s) => 
              s['name'].toLowerCase().contains(query)).take(5).toList();
          }

          return AlertDialog(
            backgroundColor: const Color(0xFF1A1C1E),
            title: const Text("Update Progress", style: TextStyle(color: Color(0xFF2ECC71))),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Surah Search:", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF2ECC71)),
                      hintText: "Search Surah...",
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.05),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    onChanged: (val) => setDialogState(() {}),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: suggestions.map((s) {
                      bool isCurrent = s['name'] == selectedSurah['name'];
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            selectedSurah = s;
                            searchController.text = s['name'];
                            errorText = null;
                            final currentAyah = int.tryParse(ayahController.text) ?? 1;
                            if (currentAyah > s['ayahs']) {
                              ayahController.text = "1";
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isCurrent ? const Color(0xFF2ECC71) : Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            s['name'],
                            style: TextStyle(
                              color: isCurrent ? Colors.black : Colors.white70,
                              fontSize: 12,
                              fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: ayahController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Ayah Number (1 - ${selectedSurah['ayahs']})",
                      errorText: errorText,
                      labelStyle: const TextStyle(color: Color(0xFF2ECC71)),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF2ECC71))),
                    ),
                    onChanged: (val) {
                      final parsed = int.tryParse(val);
                      if (parsed != null && (parsed < 1 || parsed > selectedSurah['ayahs'])) {
                        setDialogState(() => errorText = "Invalid Ayah number");
                      } else {
                        setDialogState(() => errorText = null);
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2ECC71), foregroundColor: Colors.black),
                onPressed: errorText != null
                    ? null
                    : () async {
                        final finalAyah = int.tryParse(ayahController.text) ?? 1;
                        final newBookmark = Bookmark(
                          surahName: selectedSurah['name'],
                          surahNumber: QuranData.surahs.indexOf(selectedSurah) + 1,
                          ayahNumber: finalAyah,
                          timestamp: DateTime.now(),
                        );
                        await _storageService.updateSessionBookmark(widget.sessionId, newBookmark);
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        _loadSessionData();
                      },
                child: const Text("Save", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int versesRead = _calculateTotalVersesRead(_session?.lastRead);
    final double progressPercent = (versesRead / QuranData.totalVerses).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1C1E),
      appBar: AppBar(
        title: Text(_session?.name ?? 'Loading...', 
          style: const TextStyle(color: Color(0xFF2ECC71), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2ECC71)),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryScreen(sessionId: widget.sessionId)),
            ).then((_) => _loadSessionData()),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: CircularProgressIndicator(
                      value: progressPercent,
                      strokeWidth: 12,
                      backgroundColor: Colors.white.withValues(alpha: 0.05),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2ECC71)),
                    ),
                  ),
                  SkeuoContainer(
                    width: 140,
                    height: 140,
                    borderRadius: 70,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/logo.png",
                            height: 40,
                            width: 40,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${(progressPercent * 100).toStringAsFixed(1)}%",
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          "$versesRead / 6,236",
                          style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.5)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "Continue Reading",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF2ECC71)))
                : _session?.lastRead == null
                    ? SkeuoButton(
                        onTap: _addNewBookmark,
                        padding: const EdgeInsets.all(32),
                        child: const Text(
                          "No bookmarks yet. Start reading and save your progress!",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white60),
                        ),
                      )
                    : SkeuoButton(
                        onTap: _addNewBookmark,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Text(
                              _session!.lastRead!.surahName,
                              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF2ECC71)),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Ayah ${_session!.lastRead!.ayahNumber}",
                              style: const TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Saved on ${DateFormat('MMM dd, yyyy HH:mm').format(_session!.lastRead!.timestamp)}",
                              style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.4)),
                            ),
                          ],
                        ),
                      ),
            const Spacer(),
            SkeuoButton(
              onTap: _addNewBookmark,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_add, color: Color(0xFF2ECC71)),
                  SizedBox(width: 8),
                  Text(
                    "Save Current Progress",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2ECC71)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
