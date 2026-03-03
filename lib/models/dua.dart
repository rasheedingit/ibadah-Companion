class Dua {
  final String name;
  final String arabicText;
  final String transliteration;
  final String translation;
  final String benefit;
  final String count;

  Dua({
    required this.name,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.benefit,
    required this.count,
  });

  factory Dua.fromJson(Map<String, dynamic> json) {
    return Dua(
      name: json['name'] ?? '',
      arabicText: json['arabic_text'] ?? '',
      transliteration: json['transliteration'] ?? '',
      translation: json['english_translation'] ?? '',
      benefit: json['benefit_virtue'] ?? '',
      count: json['recitation_count'] ?? '1x',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'arabic_text': arabicText,
      'transliteration': transliteration,
      'english_translation': translation,
      'benefit_virtue': benefit,
      'recitation_count': count,
    };
  }
}
