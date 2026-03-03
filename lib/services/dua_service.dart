import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/dua_category.dart';

class DuaService {
  static Future<List<DuaCategory>> loadDuas() async {
    try {
      final String response = await rootBundle.loadString('assets/data/duas.json');
      final data = await json.decode(response) as List<dynamic>;
      return data.map((json) => DuaCategory.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('Error loading duas: $e');
      return [];
    }
  }
}
