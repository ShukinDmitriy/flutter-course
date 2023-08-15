import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/settings.dart';
import '../models/user.dart' as app_user;
import '../services/network_user_service.dart';

part 'settings_notifier.g.dart';

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Settings build() {
    final getIt = GetIt.instance;

    app_user.User user = getIt<NetworkUserService>().getCurrentUser();

    if (user.photoUrl != null) {
      return Settings(
        isAvatar: true,
        avatarURL: user.photoUrl,
        displayName: user.displayName,
        id: user.id,
      );
    }
    return Settings(
      displayName: user.displayName,
      id: user.id,
    );
  }

  void setIsEdit(bool isEdit) {
    state = state.copyWith(isEdit: isEdit);
  }

  void setAvatarURL(String? avatarURL) {
    state = state.copyWith(isAvatar: avatarURL != null, avatarURL: avatarURL);
  }

  void setDisplayName(String displayName) {
    state = state.copyWith(displayName: displayName);
  }

  void setId(String id) {
    state = state.copyWith(id: id);
  }

  void setPosition(Position? position) {
    state = state.copyWith(position: position);
  }
}
