import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';

part 'settings.freezed.dart';

@freezed
class Settings with _$Settings {
  const factory Settings({
    @Default(false) bool isEdit,
    @Default(false) bool isAvatar,
    @Default(null) String? avatarURL,
    @Default('no_name') String displayName,
    @Default('') String id,
    @Default(null) Position? position,
}) = _Settings;
}
