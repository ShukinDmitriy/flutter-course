import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/settings.dart';

part 'settings_notifier.g.dart';

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Settings build() {
    return const Settings();
  }

  void setIsEdit(bool isEdit) {
    state = state.copyWith(isEdit: isEdit);
  }

  void setIsAvatar(bool isAvatar) {
    state = state.copyWith(isAvatar: isAvatar);
  }

  void setAvatarURL(String? avatarURL) {
    state = state.copyWith(avatarURL: avatarURL);
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