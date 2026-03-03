import 'package:flutter/material.dart';
import '../models/dua.dart';
import '../models/dua_category.dart';
import '../widgets/skeuo_container.dart';

class DuaDetailScreen extends StatelessWidget {
  final DuaCategory category;
  const DuaDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final List<Dua> duas = category.duas;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1C1E),
      appBar: AppBar(
        title: Text(category.name, 
          style: const TextStyle(color: Color(0xFF2ECC71), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2ECC71)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: duas.length,
        itemBuilder: (context, index) {
          final dua = duas[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: SkeuoContainer(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          dua.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2ECC71),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          dua.count,
                          style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    dua.arabicText,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 22,
                      height: 1.5,
                      fontFamily: 'Amiri',
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    dua.transliteration,
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.white60,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    dua.translation,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                  ),
                  if (dua.benefit.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2ECC71).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline, size: 18, color: Color(0xFF2ECC71)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              dua.benefit,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF2ECC71),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
