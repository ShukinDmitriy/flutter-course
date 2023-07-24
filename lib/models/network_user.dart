import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_user.freezed.dart';
part 'network_user.g.dart';

@freezed
class NetworkUser with _$NetworkUser {

  const factory NetworkUser({
    required String id,
    required String displayName,
    String? photoUrl,
  }) = _NetworkUser;

  factory NetworkUser.fromJson(Map<String, Object?> json)
  => _$NetworkUserFromJson(json);
}
