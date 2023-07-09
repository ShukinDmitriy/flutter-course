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
    onTap(String title) {
      return () {
        Navigator.of(context).push(_createRoute(title));
      };
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: onTap('Chat'),
            child: const ChatItem(
                leading: 'JD',
                title: 'John Doe',
                subtitle: 'Hello!',
                date: '31.05.2023'),
          ),
          const Divider(height: 0),
          GestureDetector(
            onTap: onTap('Chat'),
            child: const ChatItem(
                leading: 'JD',
                title: 'John Doe',
                subtitle: 'Hello!',
                date: '31.05.2023'),
          ),
          const Divider(height: 0),
          GestureDetector(
            onTap: onTap('Chat'),
            child: const ChatItem(
                leading: 'JD',
                title: 'John Doe',
                subtitle: 'Hello!',
                date: '31.05.2023'),
          ),
          const Divider(height: 0),
          GestureDetector(
            onTap: onTap('Chat'),
            child: const ChatItem(
                leading: 'JD',
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

Route _createRoute(String title) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ChatPage(
      title: title,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
