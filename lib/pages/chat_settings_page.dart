import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../pages/home_page.dart';
import '../components/main_bottom_bar.dart';
import '../components/user_avatar.dart';
import '../notifiers/async_chats_notifier.dart';
import '../services/message_service.dart';

class ChatSettingsArguments {
  final String chatUid;
  final String chatTitle;
  final String userUid;
  final String displayName;
  final String? avatarUrl;

  ChatSettingsArguments(this.chatUid, this.chatTitle, this.userUid,
      this.displayName, this.avatarUrl);
}

class ChatSettingsPage extends ConsumerStatefulWidget {
  static const routeName = '/chat-settings';

  const ChatSettingsPage({super.key});

  @override
  ConsumerState<ChatSettingsPage> createState() => _ChatSettingsPageState();
}

class _ChatSettingsPageState extends ConsumerState<ChatSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ChatSettingsArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args.chatTitle),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: UserAvatar(
                displayName: args.displayName, avatarUrl: args.avatarUrl),
          ),
          Center(
            child:
                Text(args.displayName, style: const TextStyle(fontSize: 24.0)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                padding: const EdgeInsets.all(15.0),
                key: const ValueKey('deleteChat'),
                onPressed: () async {
                  final deleteChatResult =
                      await GetIt.instance<MessageService>()
                          .deleteChat(args.chatUid, args.userUid);
                  if (deleteChatResult) {
                    await ref
                        .watch(asyncChatsNotifierProvider.notifier)
                        .loadChats();
                    Navigator.pushNamed(context, HomePage.routeName);
                  }
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 50,
                ),
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: MainBottomBar(
        onDestinationSelected: (int index) {
          Navigator.pop(context);
        },
      ),
    );
  }
}
