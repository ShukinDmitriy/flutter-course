import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/message_service.dart';

class SendButton extends StatefulWidget {
  final TextEditingController controller;

  const SendButton({required this.controller, Key? key}) : super(key: key);

  @override
  State<SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<SendButton> {
  bool isSending = false;
  final getIt = GetIt.instance;

  onPressed() async {
    if (widget.controller.text == '') {
      return;
    }

    setState(() {
      isSending = true;
    });

    await getIt<MessageService>().sendMessage(widget.controller.text);
    widget.controller.text = '';

    setState(() {
      isSending = false;
    });
  }

  void onChangeAnimation() {
    setState(() {
      isSending = !isSending;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sendButton = IconButton(
      key: const ValueKey('sendButton'),
      onPressed: onPressed,
      icon: const Icon(Icons.send, color: Colors.blue,),
    );

    final waitButton = IconButton(
      key: const ValueKey('waitButton'),
      onPressed: () {},
      icon: const Icon(Icons.cancel_schedule_send, color: Colors.grey,),
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: isSending ? waitButton : sendButton,
    );
  }
}
