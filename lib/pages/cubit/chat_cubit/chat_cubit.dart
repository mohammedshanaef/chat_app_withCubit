import 'package:chat_scolar/constant.dart';
import 'package:chat_scolar/models/message.dart';
import 'package:chat_scolar/pages/cubit/chat_cubit/chat_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ChatCubit to handle sending and receiving messages
class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference messages = FirebaseFirestore.instance.collection(kMessagesCollection);

  List<Message> messagesList = [];

  void sendMessage({required String message, required String email}) {
    try {
      messages.add({
        kMessage: message,
        kCreatedAt: DateTime.now(),
        'id': email,
      });
      emit(ChatSuccess(messages: messagesList));
    } on Exception {
      emit(ChatFailure(
        failedMessage: message,
        errorMessage: 'Failed to send the message',
      ));
    }
  }

  void getMessages() {
    messages.orderBy(kCreatedAt, descending: true).snapshots().listen((event) {
      messagesList.clear();
      for (var doc in event.docs) {
        messagesList.add(Message.fromJson(doc));
      }
      emit(ChatSuccess(messages: messagesList));
    });
  }
}
