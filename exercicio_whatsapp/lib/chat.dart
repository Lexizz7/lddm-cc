import 'package:flutter/material.dart';
import 'models/user.dart';

class Chat extends StatelessWidget {
  const Chat({required this.user, super.key});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
          ],
        ),
        leadingWidth: 88,
        elevation: 1,
      ),
      body: body(),
    );
  }

  body() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: user.messages.length,
            itemBuilder: (context, index) => MessageCard(
              message: user.messages[index],
              isMe: index % 2 == 0,
            ),
          ),
        ),
        const Divider(height: 1),
        const SizedBox(height: 8),
        Row(
          children: [
            const SizedBox(width: 8),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(8),
                  hintText: "Digite uma mensagem",
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class MessageCard extends StatelessWidget {
  const MessageCard({required this.message, required this.isMe, super.key});

  final String message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isMe ? Colors.green[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(message),
      ),
    );
  }
}
