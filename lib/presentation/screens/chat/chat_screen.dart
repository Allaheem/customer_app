import 'package:flutter/material.dart';

// TODO: Import Chat BLoC, Events, States
// TODO: Import Message model

class ChatScreen extends StatefulWidget {
  final String rideId; // To identify the chat context
  final String recipientName; // e.g., Driver's name or Customer's name

  const ChatScreen({super.key, required this.rideId, required this.recipientName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // TODO: Fetch messages from ChatBloc/Repository
  final List<Map<String, dynamic>> _messages = [
    {'sender': 'other', 'text': 'Hello! I am on my way. / مرحبًا! أنا في طريقي.', 'timestamp': DateTime.now().subtract(const Duration(minutes: 2))},
    {'sender': 'me', 'text': 'Okay, thank you! / حسنًا، شكرًا لك!', 'timestamp': DateTime.now().subtract(const Duration(minutes: 1))},
    {'sender': 'other', 'text': 'I should be there in about 5 minutes. / سأكون هناك خلال 5 دقائق تقريبًا.', 'timestamp': DateTime.now()},
  ];

  @override
  void initState() {
    super.initState();
    // TODO: Dispatch event to load messages for widget.rideId
    // Scroll to bottom when messages load
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      // TODO: Dispatch SendMessage event to ChatBloc
      print("Sending message: $text for ride ${widget.rideId}");
      setState(() {
        _messages.add({'sender': 'me', 'text': text, 'timestamp': DateTime.now()});
      });
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    bool isMe = message['sender'] == 'me';
    // TODO: Format timestamp properly
    String time = TimeOfDay.fromDateTime(message['timestamp']).format(context);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isMe ? Colors.amber[700] : Colors.grey[800],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message['text'],
              style: TextStyle(color: isMe ? Colors.black : Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(color: isMe ? Colors.black54 : Colors.white54, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context); // Assuming theme is provided

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipientName), // Show driver/customer name
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.amber[700]),
        titleTextStyle: TextStyle(color: Colors.amber[700], fontSize: 20),
        // TODO: Add call button here (Knowledge ID: user_44, user_45)
        actions: [
          IconButton(
            icon: Icon(Icons.call, color: Colors.amber[700]),
            onPressed: () {
              // TODO: Implement call functionality using url_launcher
              print("Call button tapped for ${widget.recipientName}");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Calling ${widget.recipientName}... / جاري الاتصال بـ ${widget.recipientName}...")) // Placeholder
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            // TODO: Use BlocBuilder to display messages
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          // Message Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), spreadRadius: 0, blurRadius: 5)],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Type a message... / اكتب رسالة...', // Placeholder
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  mini: true,
                  onPressed: _sendMessage,
                  backgroundColor: Colors.amber[700],
                  child: const Icon(Icons.send, color: Colors.black, size: 18),
                  // TODO: Add animation on tap (Knowledge ID: user_47)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

