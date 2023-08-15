import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'chat_page.dart';
import '../components/chat_item.dart';
import '../components/shimmer.dart';
import '../components/user_avatar.dart';
import '../notifiers/async_chats_notifier.dart';
import '../services/message_service.dart';

class ChatsPage extends ConsumerStatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends ConsumerState<ChatsPage> {
  final MessageService messageService = GetIt.instance<MessageService>();

  @override
  Widget build(BuildContext context) {
    final asyncChats = ref.watch(asyncChatsNotifierProvider);

    onTap(String title, String chatUid, String userUid, String displayName,
        String? avatarUrl) {
      return () {
        Navigator.of(context).push(ChatPage.createRoute(
            title, chatUid, userUid, displayName, avatarUrl));
      };
    }

    return asyncChats.when(data: (chatList) {
      if (chatList.isNotEmpty) {
        return Scaffold(
          key: const ValueKey('chatList'),
          appBar: AppBar(
            title: const Text('Chats'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: chatList.length,
                  itemBuilder: (context, index) {
                    final currentChat = chatList[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: onTap(
                            currentChat.chat.title,
                            currentChat.chat.uid,
                            currentChat.companion.id,
                            currentChat.companion.displayName,
                            currentChat.companion.photoUrl,
                          ),
                          child: ChatItem(
                              leading: UserAvatar(
                                  displayName:
                                      currentChat.companion.displayName,
                                  avatarUrl: currentChat.companion.photoUrl),
                              title: currentChat.chat.title,
                              subtitle: currentChat.chat.lastMessage,
                              date: currentChat.chat.timestamp),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(height: 0),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      } else {
        return Scaffold(
          key: const ValueKey('emptyChatList'),
          appBar: AppBar(
            title: const Text('Chats'),
          ),
          body: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('You don\'t have chats yet'),
              ),
            ],
          ),
        );
      }
    }, error: (err, stack) {
      return Scaffold(
        key: const ValueKey('errorChatList'),
        appBar: AppBar(
          title: const Text('Chats'),
        ),
        body: Text('Error: $err'),
      );
    }, loading: () {
      return Scaffold(
        key: const ValueKey('loadingChatList'),
        appBar: AppBar(
          title: const Text('Chats'),
        ),
        body: Shimmer(
          child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return const ChatItem(isShimmer: true);
              }),
        ),
      );
    });
  }
}
