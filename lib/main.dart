import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart' hide PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'data/repositories/user_repository.dart';
import 'firebase_options.dart';
import 'pages/chat_settings_page.dart';
import 'pages/contact_page.dart';
import 'pages/home_page.dart';
import 'pages/share_profile.dart';
import 'services/db_user_service.dart';
import 'services/message_service.dart';
import 'services/network_user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "Chat App",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  final fcmToken = await messaging.getToken();
  print(fcmToken);

  FirebaseUIAuth.configureProviders([
    PhoneAuthProvider(),
  ]);

  final getIt = GetIt.instance;
  final FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  // firebaseDatabase.setPersistenceEnabled(true);
  final DbUserService dbUserService = DbUserService();
  final NetworkUserService networkUserService =
      NetworkUserService(firebaseDatabase);
  getIt.registerSingleton<DbUserService>(dbUserService, signalsReady: true);
  getIt.registerSingleton<NetworkUserService>(networkUserService,
      signalsReady: true);
  getIt.registerSingleton<UserRepository>(
      UserRepository(
          networkUserService: networkUserService, dbUserService: dbUserService),
      signalsReady: true);
  getIt.registerSingleton<MessageService>(
      MessageService(firebaseDatabase, networkUserService),
      signalsReady: true);

  runApp(ProviderScope(
      // observers: [Logger()],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final providers = [PhoneAuthProvider()];

    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff6750a4),
        useMaterial3: true,
        textTheme: GoogleFonts.spaceGroteskTextTheme(textTheme),
      ),
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? '/sign-in'
          : HomePage.routeName,
      routes: {
        ChatSettingsPage.routeName: (context) => const ChatSettingsPage(),
        ContactPage.routeName: (context) => const ContactPage(),
        HomePage.routeName: (context) => const HomePage(),
        ShareProfile.routeName: (context) => const ShareProfile(),
        '/sign-in': (context) {
          return SignInScreen(
            providers: providers,
            actions: [
              VerifyPhoneAction((context, action) {
                Navigator.pushNamed(context, '/phone');
              }),
            ],
          );
        },
        '/phone': (context) => PhoneInputScreen(actions: [
              SMSCodeRequestedAction((context, action, flowKey, phone) {
                Navigator.of(context).pushReplacementNamed(
                  '/sms',
                  arguments: {
                    'action': action,
                    'flowKey': flowKey,
                    'phone': phone,
                  },
                );
              }),
            ]),
        '/sms': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

          return SMSCodeInputScreen(
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                Navigator.of(context).pushReplacementNamed(HomePage.routeName);
              })
            ],
            flowKey: arguments?['flowKey'],
            action: arguments?['action'],
          );
        },
      },
    );
  }
}
