import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat.freezed.dart';

part 'chat.g.dart';

@freezed
class Chat with _$Chat {
  const factory Chat({
    required String uid,
    required String title,
    String? lastMessage,
    @JsonKey(fromJson: Chat._timestampFromJson, toJson: Chat._timestampToJson)
    DateTime? timestamp,
  }) = _Chat;

  factory Chat.fromJson(Map<String, Object?> json) => _$ChatFromJson(json);

  static DateTime? _timestampFromJson(int? int) =>
      int == null ? null : DateTime.fromMillisecondsSinceEpoch(int);

  static int? _timestampToJson(DateTime? time) => time?.millisecondsSinceEpoch;
}
