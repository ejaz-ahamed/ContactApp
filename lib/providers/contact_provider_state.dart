import 'package:contact_app/objectbox/entityclass.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_provider_state.freezed.dart';

@freezed
class ContactProviderState with _$ContactProviderState {
  factory ContactProviderState({
    required List<Contact> contacts,
    String? newContactImage,
  }) = _ContactProviderState;
}
