import 'package:chat_app/components/chat_item.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats'),),
      body: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
              const ChatPage(
                title: 'Test',
              )));
            },
            child: const ChatItem(leading: 'JD',
                title: 'John Doe',
                subtitle: 'Hello!',
                date: '31.05.2023'),
          ),
          const Divider(height: 0),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
              const ChatPage(
                title: 'Test',
              )));
            },
            child: const ChatItem(leading: 'JD',
                title: 'John Doe',
                subtitle: 'Hello!',
                date: '31.05.2023'),
          ),
          const Divider(height: 0),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
              const ChatPage(
                title: 'Test',
              )));
            },
            child: const ChatItem(leading: 'JD',
                title: 'John Doe',
                subtitle: 'Hello!',
                date: '31.05.2023'),
          ),
          const Divider(height: 0),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
              const ChatPage(
                title: 'Test',
              )));
            },
            child: const ChatItem(leading: 'JD',
                title: 'John Doe',
                subtitle: 'Hello!',
                date: '31.05.2023'),
          ),
          const Divider(height: 0),
        ],
      ),
    );
  }
}
