import 'package:flutter/material.dart';
import 'package:chat_app/components/news_card.dart';
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
              name: 'News card',
              builder: (context) {
                final title = context.knobs.text(label: 'Title', initial: 'Заголовок');
                final subtitle = context.knobs.text(label: 'Subtitle', initial: 'Подзаголовок');

                return Center(
                    child:
                        NewsCard(title: title, subtitle: subtitle));
              })
        ],
      );
}
