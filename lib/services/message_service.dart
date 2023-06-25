import 'package:chat_app/models/message.dart';
import 'package:chat_app/services/user_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';

class MessageService {
  final getIt = GetIt.instance;

  Stream<List<Message>> get messagesStream =>
      FirebaseDatabase.instance.ref("messages").onValue.map((e) {
        final value = e.snapshot.value;
        final List<Message> messageList = [];

        if (value != null) {
          final firebaseMessages =
              Map<dynamic, dynamic>.from(value as Map<dynamic, dynamic>);

          firebaseMessages.forEach((key, value) {
            final currentMessage = Map<String, Object?>.from(value);
            messageList.add(Message.fromJson(currentMessage));
          });
        }

        return messageList;
      });

  Future sendMessage(text) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("messages");
    final userId = await getIt<UserService>().getUuid();
    final message =
        Message(userId: userId, text: text, timestamp: DateTime.now());

    final messageRef = ref.push();
    await messageRef.set(message.toJson());
  }
}
