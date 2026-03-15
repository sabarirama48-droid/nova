class ConversationMessage {
  final String role;
  final String content;
  final DateTime timestamp;

  ConversationMessage({
    required this.role,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'role': role,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ConversationMessage.fromJson(Map<String, dynamic> json) =>
    ConversationMessage(
      role: json['role'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
}
