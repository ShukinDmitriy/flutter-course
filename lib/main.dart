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
  final _dbRef = FirebaseDatabase.instance.ref("messages");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: StreamBuilder(
          stream: _dbRef.onValue,
          builder: (context, snapshot) {
            List<Message> messageList = [];

            if (snapshot.hasData &&
                snapshot.data != null &&
                (snapshot.data!).snapshot.value != null) {
              final firebaseMessages = Map<dynamic, dynamic>.from(
                  (snapshot.data!).snapshot.value as Map<dynamic, dynamic>);

              firebaseMessages.forEach((key, value) {
                final currentMessage = Map<String, dynamic>.from(value);
                messageList.add(Message.fromMap(currentMessage));
              });

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                    reverse: true,
                    itemCount: messageList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  messageList[index].userId.substring(0, 8),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(StringToHex.toColor(
                                          messageList[index].userId))),
                                ),
                                const SizedBox(
                                  width: 6.0,
                                ),
                                Text(
                                  timeago.format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(
                                              messageList[index].timestamp))),
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
                              messageList[index].text,
                              style: const TextStyle(fontSize: 16.0),
                            )
                          ],
                        ),
                      );
                    }),
              );
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
