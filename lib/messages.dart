import 'package:chat_app/services/message_service.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:string_to_hex/string_to_hex.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final MessageService _messageService = MessageService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _messageService.messagesStream,
      builder: (context, snapshot) {
        final messageList = snapshot.data;

        if (messageList != null && messageList.isNotEmpty) {
          return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              reverse: true,
              itemCount: messageList.length,
              itemBuilder: (context, index) {
                final currentMessage = messageList[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            currentMessage.userId.substring(0, 8),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(StringToHex.toColor(
                                    currentMessage.userId.substring(0, 6)))),
                          ),
                          const SizedBox(
                            width: 6.0,
                          ),
                          Text(
                            timeago.format(currentMessage.timestamp),
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black38,
                              fontSize: 13.0,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        currentMessage.text,
                        style: const TextStyle(fontSize: 16.0),
                      )
                    ],
                  ),
                );
              });
        } else {
          return const Text('No messages');
        }
      },
    );
  }
}
