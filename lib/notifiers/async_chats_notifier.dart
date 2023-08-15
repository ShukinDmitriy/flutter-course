import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/user_chat.dart';
import '../services/message_service.dart';

part 'async_chats_notifier.g.dart';

@riverpod
class AsyncChatsNotifier extends _$AsyncChatsNotifier {
  @override
  FutureOr<List<UserChat>> build() async {
    final getIt = GetIt.instance;
    return await getIt<MessageService>().getUserChats();
  }

  Future<void> loadChats() async {
    final getIt = GetIt.instance;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard<List<UserChat>>(() async {
      return getIt<MessageService>().getUserChats();
    });
  }
}
