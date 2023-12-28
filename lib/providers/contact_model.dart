import 'package:freezed_annotation/freezed_annotation.dart';
part 'contact_model.freezed.dart';

@freezed
class Contact with _$Contact {
  factory Contact({
    required String name,
    required String number,
    String? email,
    String? image,
  }) = _Contact;
}
