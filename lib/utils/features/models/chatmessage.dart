// Define a model for chat messages
class ChatMessage {
  final String text;
  final String? id;
  final bool isBotResponse;
  final DateTime timestamp; // Add timestamp

  ChatMessage({
    required this.text,
    this.id,
    this.isBotResponse = true,
    DateTime? timestamp, // Initialize timestamp as nullable
  }) : timestamp = timestamp ??
            DateTime.now(); // Assign current time if timestamp is null
}
