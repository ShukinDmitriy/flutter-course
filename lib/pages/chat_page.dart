import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/bottom_bar.dart';
import '../components/messages.dart';
import '../components/user_avatar.dart';
import 'chat_settings_page.dart';

class ChatPage extends ConsumerStatefulWidget {
  static const routeName = '/chat';

  static Route createRoute(String title, String chatUid, String userUid,
      String displayName, String? avatarUrl) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ChatPage(
        title: title,
        chatUid: chatUid,
        userUid: userUid,
        displayName: displayName,
        avatarUrl: avatarUrl,
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
  final String chatUid;
  final String userUid;
  final String displayName;
  final String? avatarUrl;

  const ChatPage(
      {required this.title,
      required this.chatUid,
      required this.userUid,
      required this.displayName,
      this.avatarUrl,
      Key? key})
      : super(key: key);

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: UserAvatar(
                    displayName: widget.displayName,
                    avatarUrl: widget.avatarUrl),
              ),
            ),
            Text(widget.title),
          ],
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.all(15.0),
            key: const ValueKey('editChat'),
            onPressed: () async {
              Navigator.pushNamed(
                context,
                ChatSettingsPage.routeName,
                arguments: ChatSettingsArguments(widget.chatUid, widget.title,
                    widget.userUid, widget.displayName, widget.avatarUrl),
              );
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.grey,
              size: 30,
            ),
          ),
        ],
      ),
      body: Messages(chatUid: widget.chatUid),
      bottomNavigationBar: BottomBar(chatUid: widget.chatUid),
    );
  }
}
