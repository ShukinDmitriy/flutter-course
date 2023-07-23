import 'package:chat_app/models/message.dart';
import 'package:chat_app/services/network_user_service.dart';
import 'package:firebase_database/firebase_database.dart';

class MessageService {
  final FirebaseDatabase firebaseDatabase;
  final NetworkUserService userService;

  MessageService(this.firebaseDatabase, this.userService);

  Stream<List<Message>> get messagesStream =>
      firebaseDatabase.ref("messages").onValue.map((e) {
        final value = e.snapshot.value;
        final List<Message> messageList = [];

        if (value != null) {
          final firebaseMessages =
              Map<dynamic, dynamic>.from(value as Map<dynamic, dynamic>);

          firebaseMessages.forEach((key, value) {
            final currentMessage = Map<String, Object?>.from(value);
            messageList.add(Message.fromJson(currentMessage));
          });

          messageList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        }

        return messageList;
      });

  Future sendMessage(text) async {
    DatabaseReference ref = firebaseDatabase.ref("messages");
    final userId = userService.getUuid();
    final message =
        Message(userId: userId, text: text, timestamp: DateTime.now());

    final messageRef = ref.push();
    await messageRef.set(message.toJson());
  }
}
