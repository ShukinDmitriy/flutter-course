import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_input.freezed.dart';

@freezed
class ChatInput with _$ChatInput {
  const factory ChatInput({
    required TextEditingController controller,
    required bool isSending,
  }) = _ChatInput;
}
