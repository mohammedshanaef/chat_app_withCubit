import 'package:chat_scolar/components/chat_bubble.dart';
import 'package:chat_scolar/constant.dart';
import 'package:chat_scolar/models/message.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatelessWidget {
  ChatPage({required this.email});

  
  String? email;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference messages = FirebaseFirestore.instance.collection(kMessagesCollection); // Collection of data base

  TextEditingController controller = TextEditingController();
  ScrollController _controller = ScrollController();

  void sendMessage() {
    final data = controller.text;
    if (data.isNotEmpty) {
      messages.add({
        kMessage: data,
        kCreatedAt: DateTime.now(),
        'id': email,
      });
      controller.clear();
      _controller.animateTo(
        0,
        duration: Duration(seconds: 1),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
          }

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: kPrimaryColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    kLogo,
                    height: 80,
                  ),
                  Text(
                    'Chat',
                    style: TextStyle(color: Colors.white, fontFamily: 'Pacifico', fontSize: 30),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].id == email
                          ? ChatBubble(messageBubble: messagesList[index])
                          : ChatBubbleForFriend(messageBubble: messagesList[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          onSubmitted: (_) => sendMessage(),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide: BorderSide(
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: kPrimaryColor),
                        onPressed: sendMessage, // Send message when icon is tapped
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text('Loading The Data .... '));
        }
      },
    );
  }
}
