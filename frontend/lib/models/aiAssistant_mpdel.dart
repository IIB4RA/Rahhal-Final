class ChatMessage {
  final String text;
  final bool isUser;
  final String? imageUrl; 
  final String? title;

  ChatMessage({required this.text, required this.isUser, this.imageUrl, this.title});
}