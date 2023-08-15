import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_contact.freezed.dart';

@freezed
class AddContact with _$AddContact {
  const factory AddContact({
    @Default(false) bool isError,
  }) = _AddContact;
}
