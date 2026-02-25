import 'package:flutter/material.dart';
import 'package:ibadah_companion/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QuranBookmarkApp());
}
// Bismiallah
class QuranBookmarkApp extends StatelessWidget {
  const QuranBookmarkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ibadah Companion',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2ECC71),
          surface: const Color(0xFF1A1C1E),
          primary: const Color(0xFF2ECC71),
          secondary: const Color(0xFF27AE60),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF1A1C1E),
        useMaterial3: true,
        fontFamily: 'Brandon Grotesque',
      ),
      home: const SplashScreen(),
    );
  }
}
