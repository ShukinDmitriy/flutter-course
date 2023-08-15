import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat.dart';
import 'user.dart';

part 'user_chat.freezed.dart';

@freezed
class UserChat with _$UserChat {
  const factory UserChat({
    required User companion,
    required Chat chat,
  }) = _UserChat;
}
