import 'package:chat_app/components/bottom_bar.dart';
import 'package:chat_app/components/messages.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  static const routeName = '/chat';

  static Route createRoute(String title) {
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
