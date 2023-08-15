import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../notifiers/async_chats_notifier.dart';
import '../notifiers/chat_input_notifier.dart';
import '../services/message_service.dart';

class SendButton extends ConsumerStatefulWidget {
  final String chatUid;

  const SendButton({required this.chatUid, super.key});

  @override
  ConsumerState<SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends ConsumerState<SendButton> {
  final getIt = GetIt.instance;

  onPressed() async {
    final TextEditingController controller =
        ref.read(chatInputNotifierProvider.select((value) => value.controller));

    if (controller.text == '') {
      return;
    }

    ref.read(chatInputNotifierProvider.notifier).setIsSending(true);

    await getIt<MessageService>().sendMessage(widget.chatUid, controller.text);
    controller.text = '';

    ref.read(chatInputNotifierProvider.notifier).setIsSending(false);
    ref.read(asyncChatsNotifierProvider.notifier).loadChats();
  }

  @override
  Widget build(BuildContext context) {
    bool isSending =
        ref.watch(chatInputNotifierProvider.select((value) => value.isSending));

    final sendButton = IconButton(
      key: const ValueKey('sendButton'),
      onPressed: onPressed,
      icon: const Icon(
        Icons.send,
        color: Colors.blue,
      ),
    );

    final waitButton = IconButton(
      key: const ValueKey('waitButton'),
      onPressed: () {},
      icon: const Icon(
        Icons.cancel_schedule_send,
        color: Colors.grey,
      ),
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: isSending ? waitButton : sendButton,
    );
  }
}
