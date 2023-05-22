import 'package:chat_app/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:string_to_hex/string_to_hex.dart';
import 'firebase_options.dart';
import 'models/message.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "Chat App",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // final databaseService = DatabaseService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'Chat'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: StreamBuilder(
          stream: _databaseService.messagesStream,
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
                                        currentMessage.userId))),
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
        ),
        bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Row(
            children: [
              Expanded(
                child: BottomAppBar(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(fontSize: 16.0),
                    decoration: const InputDecoration(
                      labelText: 'Message',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 8.0,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  DatabaseService().sendMessage(_controller.text);
                  _controller.text = '';
                },
                icon: const Icon(Icons.send),
              )
            ],
          ),
        ));
  }
}
