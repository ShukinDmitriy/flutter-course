import 'package:chat_app/components/bottom_bar.dart';
import 'package:chat_app/components/messages.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String title;

  const ChatPage({required this.title, Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      body: const Messages(),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
