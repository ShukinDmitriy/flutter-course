import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/chat_input.dart';

part 'chat_input_notifier.g.dart';

@riverpod
class ChatInputNotifier extends _$ChatInputNotifier {
  @override
  ChatInput build() {
    return ChatInput(
      controller: TextEditingController(),
      isSending: false,
    );
  }

  void setIsSending(bool isSending) {
    state = state.copyWith(isSending: isSending);
  }
}
