import 'package:chat_app/components/shimmer.dart';
import 'package:chat_app/services/message_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import 'message_item.dart';

class Messages extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getIt = GetIt.instance;
    // final exampleProvider = ref.watch(ExampleProvider);
    //
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // ref.read(ExampleProvider.notifier).state++;
    // });
    //
    // print(exampleProvider.toString());
    
    return StreamBuilder(
      stream: getIt<MessageService>().messagesStream,
      builder: (context, snapshot) {
        final messageList = snapshot.data;

        if (messageList != null && messageList.isNotEmpty) {
          return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              reverse: true,
              itemCount: messageList.length,
              itemBuilder: (context, index) {
                final currentMessage = messageList[index];
                return MessageItem(message: currentMessage);
              });
        } else {
          return Shimmer(
            child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                reverse: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return const MessageItem(isShimmer: true);
                }),
          );
        }
      },
    );
  }
}
