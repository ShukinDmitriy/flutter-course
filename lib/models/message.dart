import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class Message with _$Message {

 const factory Message({
  required String userId,
  required String text,
  @JsonKey(fromJson: Message._timestampFromJson, toJson: Message._timestampToJson)
  required DateTime timestamp,
 }) = _Message;

 factory Message.fromJson(Map<String, Object?> json)
 => _$MessageFromJson(json);

 static DateTime _timestampFromJson(int int) => DateTime.fromMillisecondsSinceEpoch(int);
 static int _timestampToJson(DateTime time) => time.millisecondsSinceEpoch;
}