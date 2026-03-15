class PersonalWord {
  final String word;
  final String meaning;
  final DateTime learnedAt;
  int usageCount;

  PersonalWord({
    required this.word,
    required this.meaning,
    required this.learnedAt,
    this.usageCount = 0,
  });

  Map<String, dynamic> toJson() => {
    'word': word,
    'meaning': meaning,
    'learnedAt': learnedAt.toIso8601String(),
    'usageCount': usageCount,
  };

  factory PersonalWord.fromJson(Map<String, dynamic> json) => PersonalWord(
    word: json['word'],
    meaning: json['meaning'],
    learnedAt: DateTime.parse(json['learnedAt']),
    usageCount: json['usageCount'] ?? 0,
  );
}
