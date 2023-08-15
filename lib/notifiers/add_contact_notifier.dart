import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/add_contact.dart';

part 'add_contact_notifier.g.dart';

@riverpod
class AddContactNotifier extends _$AddContactNotifier {
  @override
  AddContact build() {
    return const AddContact();
  }

  void setIsError(bool isError) {
    state = state.copyWith(isError: isError);
  }
}
