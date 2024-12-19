import 'package:chat_scolar/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final String id;
  final DateTime createdAt;

  Message({required this.message, required this.id, required this.createdAt});

  factory Message.fromJson(jsonData) {
    return Message(
      message: jsonData[kMessage] ?? '',
      id: jsonData['id'] ?? '',
      createdAt: (jsonData[kCreatedAt] as Timestamp).toDate(),
    );
  }
}
