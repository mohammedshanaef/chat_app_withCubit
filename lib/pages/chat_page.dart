// ChatPage to integrate everything together
import 'package:chat_scolar/components/chat_bubble.dart';
import 'package:chat_scolar/constant.dart';
import 'package:chat_scolar/models/message.dart';
import 'package:chat_scolar/pages/cubit/chat_cubit/chat_cubit.dart';
import 'package:chat_scolar/pages/cubit/chat_cubit/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatelessWidget {
  ChatPage({required this.email});

  final String? email;
  final List<Message> messagesList = [];
  final TextEditingController controller = TextEditingController();
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final chatCubit = BlocProvider.of<ChatCubit>(context);
    chatCubit.getMessages(); // Ensure messages are fetched when the page is built

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
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                var messagesList = BlocProvider.of<ChatCubit>(context).messagesList;
                return ListView.builder(
                  reverse: true,
                  controller: _controller,
                  itemCount: messagesList.length,
                  itemBuilder: (context, index) {
                    final message = messagesList[index];
                    return ChatBubble(
                      messageBubble: message,
                      isMe: message.id == email,
                      isFailed: state is ChatFailure && state.failedMessage == message.message,
                    );
                  },
                );
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
                  onPressed: () {
                    final message = controller.text;
                    if (message.isNotEmpty) {
                      chatCubit.sendMessage(message: message, email: email!);
                      controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
