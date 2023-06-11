import 'package:flutter/material.dart';
import 'package:chat_app/components/chat_item.dart';
import 'package:chat_app/components/contact_item.dart';
import 'package:chat_app/components/news_card.dart';
import 'package:chat_app/models/user.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

void main() => runApp(const MyApp());

final _plugins = initializePlugins(
  contentsSidePanel: true,
  knobsSidePanel: true,
  initialDeviceFrameData: DeviceFrameData(
    device: Devices.ios.iPhone13,
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Storybook(
        initialStory: 'Screens/Scaffold',
        plugins: _plugins,
        stories: [
          Story(
              name: 'Chat item',
              builder: (context) {
                final leading =
                    context.knobs.text(label: 'Leading', initial: 'JD');
                final title =
                    context.knobs.text(label: 'Title', initial: 'John Doe');
                final subtitle = context.knobs
                    .text(label: 'Subtitle', initial: 'Hello!');
                final date = context.knobs
                    .text(label: 'Date', initial: '31.05.2023');

                return Center(
                    child: ChatItem(leading: leading,title: title, subtitle: subtitle, date: date));
              }),
          Story(
              name: 'News card',
              builder: (context) {
                final title =
                    context.knobs.text(label: 'Title', initial: 'Заголовок');
                final subtitle = context.knobs
                    .text(label: 'Subtitle', initial: 'Подзаголовок');

                return Center(
                    child: NewsCard(title: title, subtitle: subtitle));
              }),
          Story(
              name: 'Contact item',
              builder: (context) {
                final displayName =
                    context.knobs.text(label: 'DisplayName', initial: 'Имя');
                final photoUrl = context.knobs.options(
                    label: 'PhotoUrl',
                    initial: 'assets/images/avatar1.png',
                    options: [
                      const Option(label: '№1', value: 'assets/images/avatar1.png'),
                      const Option(label: '№2', value: 'assets/images/avatar2.jpg'),
                      const Option(label: '№3', value: 'assets/images/avatar3.jpg'),
                    ]);

                return Center(
                    child: ContactItem(
                        user: User(
                            id: 'id',
                            displayName: displayName,
                            photoUrl: photoUrl)));
              }),
        ],
      );
}
