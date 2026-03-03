import 'dua.dart';

class DuaCategory {
  final String id;
  final String name;
  final String icon;
  final List<Dua> duas;

  DuaCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.duas,
  });

  factory DuaCategory.fromJson(Map<String, dynamic> json) {
    return DuaCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? 'book',
      duas: (json['duas'] as List<dynamic>?)
              ?.map((d) => Dua.fromJson(d as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
