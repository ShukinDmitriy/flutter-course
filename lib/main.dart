import 'package:chat_app/services/message_service.dart';
import 'package:chat_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'firebase_options.dart';
import 'home_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "Chat App",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final getIt = GetIt.instance;
  getIt.registerSingleton<MessageService>(MessageService(), signalsReady: true);
  getIt.registerSingleton<UserService>(UserService(), signalsReady: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff6750a4),
        useMaterial3: true,
        textTheme: GoogleFonts.spaceGroteskTextTheme(textTheme),
      ),
      home: const HomePage(title: 'Chat'),
    );
  }
}
