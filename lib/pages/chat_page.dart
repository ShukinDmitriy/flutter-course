import 'package:chat_app/components/bottom_bar.dart';
import 'package:chat_app/components/messages.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:string_to_hex/string_to_hex.dart';

import '../services/message_service.dart';

class ChatPage extends StatefulWidget {
  final String title;

  const ChatPage({required this.title, Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _dbRef = FirebaseDatabase.instance.ref('messages');
  final TextEditingController _controller = TextEditingController();
  final getIt = GetIt.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      body: const Messages(),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
