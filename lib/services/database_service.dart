import 'package:chat_app/models/message.dart';
import 'package:chat_app/services/user_service.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final UserService _userService = UserService();

  Stream<List<Message>> get messagesStream =>
      FirebaseDatabase.instance.ref("messages").onValue.map((e) {
        final value = e.snapshot.value;
        final List<Message> messageList = [];

        if (value != null) {
          final firebaseMessages =
              Map<dynamic, dynamic>.from(value as Map<dynamic, dynamic>);

          firebaseMessages.forEach((key, value) {
            final currentMessage = Map<String, dynamic>.from(value);
            messageList.add(Message.fromMap(currentMessage));
          });
        }

        return messageList;
      });

  Future getData() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('message').get();
    if (snapshot.exists) {
      print(snapshot.value);
    } else {
      print('No data available.');
    }
  }

  Future sendMessage(text) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("messages");
    final userId = await _userService.getUuid();
    final message =
        Message(userId: userId, text: text, timestamp: DateTime.now());

    final messageRef = ref.push();
    await messageRef.set(message.toJson());
  }
}
