import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShareArguments {
  final String userId;

  ShareArguments(this.userId);
}

class ShareProfile extends StatelessWidget {
  static const routeName = '/share-profile';

  const ShareProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ShareArguments;

    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Share profile'),
        ),
        body: Builder(
          builder: (BuildContext context) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  QrImageView(
                    data: args.userId,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),

                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: args.userId));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Copied Link!')),
                          );
                        },
                        child: const Text('Share'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
