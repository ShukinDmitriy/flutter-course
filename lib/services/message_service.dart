import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

import '../models/chat.dart';
import '../models/message.dart';
import '../models/user.dart';
import '../models/user_chat.dart';
import '../services/network_user_service.dart';

class MessageService {
  final FirebaseDatabase firebaseDatabase;
  final NetworkUserService userService;

  MessageService(this.firebaseDatabase, this.userService);

  Future<List<UserChat>> getUserChats() async {
    final user = userService.getCurrentUser();

    final userChatsValue =
        (await firebaseDatabase.ref("userChats/${user.id}").get()).value;
    if (userChatsValue == null) {
      return [];
    }

    final List<UserChat> chatList = [];

    for (final entry in (userChatsValue as Map<Object?, Object?>).entries) {
      final companionUid = entry.key;
      final chatUid = entry.value;

      if (companionUid == null || chatUid == null) {
        continue;
      }

      final companion = await userService.getUserByUid(companionUid as String);
      final chat = await getChatByUid(chatUid as String);

      if (companion == null || chat == null) {
        continue;
      }

      chatList.add(UserChat(companion: companion, chat: chat));
    }

    chatList.sort((a, b) {
      if (a.chat.timestamp == null && b.chat.timestamp == null) {
        return 0;
      }

      if (a.chat.timestamp != null && b.chat.timestamp == null) {
        return -1;
      }
      if (a.chat.timestamp == null && b.chat.timestamp != null) {
        return 1;
      }

      return b.chat.timestamp!.compareTo(a.chat.timestamp!);
    });

    return chatList;
  }

  Future sendMessage(String chatUid, String text) async {
    final userId = userService.getUuid();
    final message =
        Message(userId: userId, text: text, timestamp: DateTime.now());

    final messageUid = const Uuid().v4();

    await firebaseDatabase
        .ref("messages/${chatUid}/${messageUid}")
        .set(message.toJson());
    await firebaseDatabase
        .ref("chats/${chatUid}/lastMessage")
        .set(message.text);
    await firebaseDatabase
        .ref("chats/${chatUid}/timestamp")
        .set(message.timestamp.millisecondsSinceEpoch);
  }

  Future<String?> createChat(User user) async {
    try {
      final currentUserUid = userService.getUuid();
      final userChatsValue =
          (await firebaseDatabase.ref("userChats/${currentUserUid}").get())
              .value;

      var userChats = <dynamic, dynamic>{};
      if (userChatsValue != null) {
        userChats =
            Map<dynamic, dynamic>.from(userChatsValue as Map<dynamic, dynamic>);
      }

      if (userChats.containsKey(user.id)) {
        return Future.value(userChats[user.id]);
      }

      final chatUid = const Uuid().v4();
      final chat = Chat(uid: chatUid, title: user.displayName);
      await firebaseDatabase.ref("chats").child(chatUid).set(chat.toJson());

      await firebaseDatabase
          .ref("userChats/${currentUserUid}/${user.id}")
          .set(chatUid);
      await firebaseDatabase
          .ref("userChats/${user.id}/${currentUserUid}")
          .set(chatUid);

      return Future.value(chatUid);
    } catch (e) {
      print(e);
      return Future.value(null);
    }
  }

  Future<Chat?> getChatByUid(String uid) async {
    if (uid == '') {
      return null;
    }

    final chatValue = (await firebaseDatabase.ref('chats/${uid}').get()).value;

    if (chatValue == null) {
      return null;
    }

    final chatMap = Map<String, dynamic>.from(chatValue as Map);
    return Chat.fromJson(chatMap);
  }

  Future<bool> deleteChat(String chatUid, String userUid) async {
    try {
      final currentUserUid = userService.getUuid();
      print('currentUserUid: ${currentUserUid}');
      print('userUid: ${userUid}');
      // чат
      await firebaseDatabase.ref("chats/${chatUid}").remove();
      // сообщения
      await firebaseDatabase.ref("messages/${chatUid}").remove();
      // связка с пользователями
      await firebaseDatabase
          .ref("userChats/${currentUserUid}/${userUid}")
          .remove();
      await firebaseDatabase
          .ref("userChats/${userUid}/${currentUserUid}")
          .remove();

      return Future.value(true);
    } catch (e) {
      print(e);
      return Future.value(false);
    }
  }

  Stream<List<Message>> getMessagesByChatUid(String uid) {
    return firebaseDatabase.ref("messages/${uid}").onValue.map((e) {
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
  }
}
