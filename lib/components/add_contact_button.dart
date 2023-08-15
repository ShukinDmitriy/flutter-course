import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../notifiers/add_contact_notifier.dart';
import '../services/network_user_service.dart';

class AddContactButton extends ConsumerStatefulWidget {
  final ValueChanged<bool>? onAddedContact;

  const AddContactButton({super.key, this.onAddedContact});

  @override
  ConsumerState<AddContactButton> createState() => _AddContactButtonState();
}

class _AddContactButtonState extends ConsumerState<AddContactButton> {
  final inputController = TextEditingController();
  final userService = GetIt.instance<NetworkUserService>();

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Align(
      alignment: Alignment.bottomRight,
      child: IconButton(
        padding: const EdgeInsets.all(10.0),
        icon: const Icon(
          Icons.add_circle_outline,
          color: Colors.blue,
          size: 50,
        ),
        onPressed: () async {
          inputController.clear();
          await showDialog(
            context: context,
            useRootNavigator: false,
            builder: (context) {
              return Consumer(builder: (context, ref, _) {
                bool showError = ref.watch(addContactNotifierProvider
                    .select((value) => value.isError));

                return AlertDialog(
                  title: const Text('Add user to contact list'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      showError
                          ? TextField(
                              controller: inputController,
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                labelText: 'Insert UID user',
                              ),
                            )
                          : TextField(
                              controller: inputController,
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                labelText: 'Insert UID user',
                              ),
                            ),
                      showError
                          ? const Text('Check entered UID')
                          : const Text(''),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop(
                            false); // dismisses only the dialog and returns false
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final addUserResult = await userService
                            .addUserToContact(inputController.text);
                        if (addUserResult) {
                          ref
                              .read(addContactNotifierProvider.notifier)
                              .setIsError(false);
                          Navigator.of(context, rootNavigator: true).pop(
                              true); // dismisses only the dialog and returns true
                          if (widget.onAddedContact != null) {
                            widget.onAddedContact!(true);
                          }
                        } else {
                          ref
                              .read(addContactNotifierProvider.notifier)
                              .setIsError(true);
                        }
                      },
                      child: const Text('Add'),
                    ),
                  ],
                );
              });
            },
          );
        },
      ),
    ));
  }
}
