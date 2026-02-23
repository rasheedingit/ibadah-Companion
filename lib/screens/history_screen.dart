import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/reading_session.dart';
import '../services/storage_service.dart';
import '../widgets/skeuo_container.dart';

class HistoryScreen extends StatefulWidget {
  final String sessionId;
  const HistoryScreen({super.key, required this.sessionId});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final StorageService _storageService = StorageService();
  ReadingSession? _session;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final session = await _storageService.getSession(widget.sessionId);
    setState(() {
      _session = session;
      _isLoading = false;
    });
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1C1E),
        title: const Text("Clear History", style: TextStyle(color: Color(0xFF2ECC71))),
        content: const Text("Are you sure you want to clear history for this session?", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Clear", style: TextStyle(color: Color(0xFF2ECC71)))),
        ],
      ),
    );

    if (confirmed == true) {
      await _storageService.clearSessionHistory(widget.sessionId);
      _loadHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1C1E),
      appBar: AppBar(
        title: Text('${_session?.name ?? ""} History', 
          style: const TextStyle(color: Color(0xFF2ECC71), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2ECC71)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: (_session?.history.isEmpty ?? true) ? null : _clearHistory,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2ECC71)))
          : (_session?.history.isEmpty ?? true)
              ? const Center(
                  child: Text(
                    "No history found",
                    style: TextStyle(color: Colors.white60),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _session!.history.length,
                  itemBuilder: (context, index) {
                    final bookmark = _session!.history[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SkeuoContainer(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        borderRadius: 15,
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1C1E),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    offset: const Offset(2, 2),
                                    blurRadius: 4,
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    offset: const Offset(-2, -2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  bookmark.surahNumber.toString(),
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2ECC71)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bookmark.surahName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Ayah ${bookmark.ayahNumber}",
                                    style: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              DateFormat('MMM dd').format(bookmark.timestamp),
                              style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.3)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
