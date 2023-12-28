import 'package:contact_app/objectbox/entityclass.dart';
import 'package:contact_app/objectbox/objectstore.dart';
import 'package:contact_app/providers/contact_provider_state.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'contact_provider.g.dart';

@riverpod
class ContactProvider extends _$ContactProvider {
  late final TextEditingController nameController;
  late final TextEditingController numberController;
  late final TextEditingController emailController;

  @override
  ContactProviderState build() {
    nameController = TextEditingController();
    numberController = TextEditingController();
    emailController = TextEditingController();

    ref.onDispose(dispose);

    return ContactProviderState(
      contacts: ObjectBox.instance.contactBox.getAll(),
      newContactImage: null,
    );
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    numberController.dispose();
  }

  String?  validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "type something";
    } else if (state.contacts.contains(Contact(name: value, number: ""))) {
      return "Name already exists..";
    }
    return null;
  }

  void pickImage(String imagePath) {
    state = state.copyWith(newContactImage: imagePath);
  }

  void resetInput() {
    nameController.clear();
    numberController.clear();
    emailController.clear();
    state = state.copyWith(newContactImage: null);
  }

  void addContact() {
    final name = nameController.text;
    final number = numberController.text;
    final email = emailController.text;

    final contactToAdd = Contact(
      name: name,
      number: number,
      email: email,
      image: state.newContactImage,
    );
    ObjectBox.instance.contactBox.put(contactToAdd);
    state = state.copyWith(contacts: [...state.contacts, contactToAdd]);
    resetInput();
  }

  void delContact(int index) {
    final updatedContacts = [...state.contacts];
    ObjectBox.instance.contactBox.remove(state.contacts[index].id);
    updatedContacts.removeAt(index);
    state = state.copyWith(contacts: updatedContacts);
  }

  void updateContact(int index) {
    final name = nameController.text;
    final number = numberController.text;
    final email = emailController.text;

    final contactToUpdate = Contact(
      id: state.contacts[index].id,
      name: name,
      number: number,
      email: email,
      image: state.newContactImage,
    );
    final updatedContacts = [...state.contacts];
    updatedContacts[index] = contactToUpdate;
    ObjectBox.instance.contactBox.put(contactToUpdate);
    state = state.copyWith(contacts: updatedContacts);
    resetInput();
  }
}
