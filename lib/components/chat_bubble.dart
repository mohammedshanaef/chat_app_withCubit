import 'package:chat_scolar/constant.dart';
import 'package:chat_scolar/models/message.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final Message messageBubble;

  const ChatBubble({super.key, required this.messageBubble});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          color: kPrimaryColor,
        ),
        child: Text(
          messageBubble.message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class ChatBubbleForFriend extends StatelessWidget {
  final Message messageBubble;

  const ChatBubbleForFriend({super.key, required this.messageBubble});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          color: Color(0xff006D84),
        ),
        child: Text(
          messageBubble.message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
