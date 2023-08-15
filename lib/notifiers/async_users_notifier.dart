import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/repositories/user_repository.dart';
import '../models/user.dart';

part 'async_users_notifier.g.dart';

@riverpod
class AsyncUsersNotifier extends _$AsyncUsersNotifier {
  @override
  FutureOr<List<User>> build() async {
    final getIt = GetIt.instance;
    final users = await getIt<UserRepository>().getUsers();
    return users;
  }

  Future<void> loadUsers() async {
    final getIt = GetIt.instance;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard<List<User>>(() async {
      return getIt<UserRepository>().getUsers(resetDb: true);
    });
  }
}
