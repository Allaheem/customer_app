import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// warning • Unused import: 'package:equatable/equatable.dart'

// TODO: Import ChatRepository
// TODO: Import Message model

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  // TODO: Inject ChatRepository
  // final ChatRepository _chatRepository;
  // StreamSubscription? _messageSubscription;

  ChatBloc(/* required this._chatRepository */) : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<MessageReceived>(_onMessageReceived);
    on<SendMessage>(_onSendMessage);
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      // TODO: Call _chatRepository.getMessages(event.rideId)
      // print("Loading messages for ride: ${event.rideId}");
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate API call
      // Placeholder messages
      final List<dynamic> messages = [
        {'sender': 'other', 'text': 'Hello! I am on my way. / مرحبًا! أنا في طريقي.', 'timestamp': DateTime.now().subtract(const Duration(minutes: 2))},
        {'sender': 'me', 'text': 'Okay, thank you! / حسنًا، شكرًا لك!', 'timestamp': DateTime.now().subtract(const Duration(minutes: 1))},
        {'sender': 'other', 'text': 'I should be there in about 5 minutes. / سأكون هناك خلال 5 دقائق تقريبًا.', 'timestamp': DateTime.now()},
      ];
      emit(ChatLoaded(messages));

      // TODO: Subscribe to new messages stream from repository
      // _messageSubscription?.cancel();
      // _messageSubscription = _chatRepository.getNewMessagesStream(event.rideId).listen((newMessage) {
      //   add(MessageReceived(newMessage));
      // });

    } catch (e) {
      emit(ChatError("Failed to load messages: ${e.toString()}"));
    }
  }

  void _onMessageReceived(
    MessageReceived event,
    Emitter<ChatState> emit,
  ) {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      // Add the new message to the existing list
      final updatedMessages = List<dynamic>.from(currentState.messages)..add(event.messageData);
      emit(ChatLoaded(updatedMessages));
    } else {
      // If messages weren't loaded yet, maybe just load them now including the new one?
      // Or handle as an error/unexpected state.
      // print("Received message but chat wasn't loaded. Message: ${event.messageData}");
      // Optionally trigger LoadMessages again if appropriate
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (state is ChatLoaded) {
      final currentState = state as ChatLoaded;
      // Optimistically add the message to the UI
      final optimisticMessage = {
        'sender': 'me',
        'text': event.text,
        'timestamp': DateTime.now(),
        'status': 'sending' // Optional: Add a sending status
      };
      final updatedMessages = List<dynamic>.from(currentState.messages)..add(optimisticMessage);
      emit(ChatLoaded(updatedMessages));

      try {
        // TODO: Call _chatRepository.sendMessage(event.rideId, event.text)
        // print("Sending message via repository: ${event.text}");
        await Future.delayed(const Duration(milliseconds: 300)); // Simulate API call

        // TODO: Update message status to 'sent' or handle potential error
        // If the backend confirms the message, update its status or ID
        // If error, update message status to 'failed'
        // Example: Find the message and update its status
        // final confirmedMessageIndex = updatedMessages.indexOf(optimisticMessage);
        // if (confirmedMessageIndex != -1) {
        //   updatedMessages[confirmedMessageIndex]['status'] = 'sent';
        //   emit(ChatLoaded(List<dynamic>.from(updatedMessages)));
        // }

      } catch (e) {
        emit(ChatError("Failed to send message: ${e.toString()}"));
        // Optionally revert the optimistic update or mark the message as failed
        final failedMessageIndex = updatedMessages.indexOf(optimisticMessage);
        if (failedMessageIndex != -1) {
           updatedMessages[failedMessageIndex]['status'] = 'failed';
           emit(ChatLoaded(List<dynamic>.from(updatedMessages)));
        }
      }
    }
  }

  @override
  Future<void> close() {
    // _messageSubscription?.cancel();
    return super.close();
  }
}

