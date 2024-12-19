// ChatState to define states
import 'package:chat_scolar/models/message.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatSuccess extends ChatState {
  List<Message> messages;

  ChatSuccess({required this.messages});
}

class ChatFailure extends ChatState {
  final String failedMessage;
  final String errorMessage;

  ChatFailure({required this.failedMessage, required this.errorMessage});
}
