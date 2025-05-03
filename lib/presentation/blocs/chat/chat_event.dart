part of 'chat_bloc.dart';



abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

// Event to load messages for a specific ride
class LoadMessages extends ChatEvent {
  final String rideId;

  const LoadMessages(this.rideId);

  @override
  List<Object> get props => [rideId];
}

// Event when a new message is received (e.g., from WebSocket)
class MessageReceived extends ChatEvent {
  final dynamic messageData; // Placeholder for Message model

  const MessageReceived(this.messageData);

  @override
  List<Object> get props => [messageData];
}

// Event when the user sends a message
class SendMessage extends ChatEvent {
  final String rideId;
  final String text;

  const SendMessage({required this.rideId, required this.text});

  @override
  List<Object> get props => [rideId, text];
}

