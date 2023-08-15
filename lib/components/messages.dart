import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../components/shimmer.dart';
import '../models/message.dart';
import 'message_item.dart';
import '../services/message_service.dart';
import '../services/network_user_service.dart';

class Messages extends ConsumerStatefulWidget {
  final String chatUid;

  const Messages({required this.chatUid, super.key});

  @override
  ConsumerState<Messages> createState() => _MessagesState();
}

class _MessagesState extends ConsumerState<Messages> {
  final messagesProvider =
      StreamProvider.family<List<Message>, String?>((ref, uid) {
    return GetIt.instance<MessageService>().getMessagesByChatUid(uid ?? '');
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = GetIt.instance<NetworkUserService>().getCurrentUser();
    final asyncMessages = ref.watch(messagesProvider(widget.chatUid));

    return asyncMessages.when(data: (messages) {
      if (messages.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(16.0),
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final currentMessage = messages[index];
                  return MessageItem(
                    message: currentMessage,
                    isSelfMessage: currentMessage.userId == currentUser.id,
                  );
                },
              ),
            )
          ],
        );
      } else {
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('You have not sent messages yet'),
            ),
          ],
        );
      }
    }, error: (err, stack) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Error: $err'),
        ],
      );
    }, loading: () {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(16.0),
                reverse: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return const MessageItem(isShimmer: true);
                }),
          ),
        ],
      );
    });
  }
}
