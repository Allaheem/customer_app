part of 'chat_bloc.dart';


abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

// Initial state, no messages loaded yet
class ChatInitial extends ChatState {}

// Messages are being loaded
class ChatLoading extends ChatState {}

// Messages loaded successfully
class ChatLoaded extends ChatState {
  final List<dynamic> messages; // Placeholder for Message model list

  const ChatLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

// Error state during loading or sending
class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}

