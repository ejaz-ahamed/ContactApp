import 'dart:io';
import 'package:contact_app/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void pickImage(ImageSource type) async {
      XFile? image = await picker.pickImage(source: type);
      if (image != null) {
        ref.read(contactProviderProvider.notifier).pickImage(image.path);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Image pick failed")));
        }
      }
      Navigator.pop(context);
    }

    void saveNewContact() {
      if (formKey.currentState!.validate()) {
        ref.read(contactProviderProvider.notifier).addContact();
        ref.read(contactProviderProvider.notifier).resetInput();
        Navigator.pop(context);
      }
    }

    void addContact() {
      showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: AlertDialog(
              title: const Text("Create new Contact"),
              content: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Consumer(builder: (context, ref, child) {
                          return Container(
                            height: MediaQuery.sizeOf(context).height / 6,
                            width: MediaQuery.sizeOf(context).width / 2,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              image: ref
                                          .watch(contactProviderProvider)
                                          .newContactImage !=
                                      null
                                  ? DecorationImage(
                                      image: FileImage(File(ref
                                          .watch(contactProviderProvider)
                                          .newContactImage!)),
                                      fit: BoxFit.cover,
                                    )
                                  : const DecorationImage(
                                      image: NetworkImage(
                                        "https://as2.ftcdn.net/v2/jpg/05/89/93/27/1000_F_589932782_vQAEAZhHnq1QCGu5ikwrYaQD0Mmurm0N.jpg",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          );
                        }),
                        Positioned(
                          bottom: 0,
                          right: 10,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade900,
                                shape:
                                    const CircleBorder(side: BorderSide.none)),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Pick Image from"),
                                    content: Row(
                                      children: [
                                        TextButton(
                                          onPressed: () =>
                                              pickImage(ImageSource.gallery),
                                          child: const Text("Gallery"),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              pickImage(ImageSource.camera),
                                          child: const Text("Camera"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Icon(
                              Icons.add_a_photo_sharp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      "Name:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextFormField(
                      validator: ref
                          .read(contactProviderProvider.notifier)
                          .validateName,
                      cursorColor: Colors.black,
                      controller: ref
                          .watch(contactProviderProvider.notifier)
                          .nameController,
                      decoration: InputDecoration(
                        hintText: "Name",
                        filled: true,
                        fillColor: Colors.grey.shade400,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const Text(
                      "Mobile:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      cursorColor: Colors.black,
                      controller: ref
                          .watch(contactProviderProvider.notifier)
                          .numberController,
                      decoration: InputDecoration(
                        hintText: "Phone Number",
                        filled: true,
                        fillColor: Colors.grey.shade400,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "type something";
                        } else if (value.length < 10) {
                          return "Enter 10 Digits";
                        }
                        return null;
                      },
                    ),
                    const Text(
                      "E-mail:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextField(
                      cursorColor: Colors.black,
                      controller: ref
                          .watch(contactProviderProvider.notifier)
                          .emailController,
                      decoration: InputDecoration(
                        hintText: "E-Mail(Optional)",
                        filled: true,
                        fillColor: Colors.grey.shade400,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Back"),
                ),
                TextButton(
                  onPressed: () => saveNewContact(),
                  child: const Text("Save"),
                )
              ],
            ),
          );
        },
      );
    }

    void deleteContact(int index) {
      ref.read(contactProviderProvider.notifier).delContact(index);
    }

    void updateContact(int index) {
      if (formKey.currentState!.validate()) {
        ref.read(contactProviderProvider.notifier).updateContact(index);
      }
      Navigator.pop(context);
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
          ),
          title: const Text(
            "Contacts",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => addContact(),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: ref.watch(contactProviderProvider).contacts.isEmpty
            ? const Center(
                child: Text(
                  "Your Contact List is Empty.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : ListView.separated(
                itemBuilder: (context, index) {
                  final contact =
                      ref.watch(contactProviderProvider).contacts[index];

                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: contact.image == null
                            ? Image.network(
                                "https://as2.ftcdn.net/v2/jpg/05/89/93/27/1000_F_589932782_vQAEAZhHnq1QCGu5ikwrYaQD0Mmurm0N.jpg",
                                fit: BoxFit.fill,
                              )
                            : Image.file(
                                File(contact.image!),
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                    title: Text(
                      contact.name ?? '',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      contact.number ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              if (contact.image != null) {
                                ref
                                    .read(contactProviderProvider.notifier)
                                    .pickImage(contact.image!);
                              }

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return SingleChildScrollView(
                                    child: AlertDialog(
                                      title: const Text("Edit Your Contact"),
                                      content: Form(
                                        key: formKey,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Consumer(builder:
                                                    (context, ref, child) {
                                                  return Container(
                                                    height: MediaQuery.sizeOf(
                                                                context)
                                                            .height /
                                                        6,
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width /
                                                        2,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.grey,
                                                      image: ref
                                                                  .watch(
                                                                      contactProviderProvider)
                                                                  .newContactImage !=
                                                              null
                                                          ? DecorationImage(
                                                              image: FileImage(File(ref
                                                                  .watch(
                                                                      contactProviderProvider)
                                                                  .newContactImage!)),
                                                              fit: BoxFit.cover,
                                                            )
                                                          : const DecorationImage(
                                                              image:
                                                                  NetworkImage(
                                                                "https://as2.ftcdn.net/v2/jpg/05/89/93/27/1000_F_589932782_vQAEAZhHnq1QCGu5ikwrYaQD0Mmurm0N.jpg",
                                                              ),
                                                            ),
                                                    ),
                                                  );
                                                }),
                                                Positioned(
                                                  bottom: 0,
                                                  right: 10,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors
                                                            .grey.shade900,
                                                        shape:
                                                            const CircleBorder(
                                                                side: BorderSide
                                                                    .none)),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: const Text(
                                                                "Pick Image from"),
                                                            content: Row(
                                                              children: [
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      pickImage(
                                                                          ImageSource
                                                                              .gallery),
                                                                  child: const Text(
                                                                      "Gallery"),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      pickImage(
                                                                          ImageSource
                                                                              .camera),
                                                                  child: const Text(
                                                                      "Camera"),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: const Icon(
                                                      Icons.add_a_photo_sharp,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Text(
                                              "Name:",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            TextFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "type something";
                                                }
                                                return null;
                                              },
                                              cursorColor: Colors.black,
                                              controller: ref
                                                  .read(contactProviderProvider
                                                      .notifier)
                                                  .nameController,
                                              decoration: InputDecoration(
                                                hintText: "Name",
                                                filled: true,
                                                fillColor: Colors.grey.shade400,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide.none,
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                            ),
                                            const Text(
                                              "Mobile:",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            TextFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "type something";
                                                } else if (value.length < 10) {
                                                  return "Enter 10 Digits";
                                                }
                                                return null;
                                              },
                                              keyboardType: TextInputType.phone,
                                              cursorColor: Colors.black,
                                              controller: ref
                                                  .read(contactProviderProvider
                                                      .notifier)
                                                  .numberController,
                                              decoration: InputDecoration(
                                                hintText: "Phone Number",
                                                filled: true,
                                                fillColor: Colors.grey.shade400,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide.none,
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                            ),
                                            const Text(
                                              "E-mail:",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            TextField(
                                              cursorColor: Colors.black,
                                              controller: ref
                                                  .read(contactProviderProvider
                                                      .notifier)
                                                  .emailController,
                                              decoration: InputDecoration(
                                                hintText: "E-Mail(Optional)",
                                                filled: true,
                                                fillColor: Colors.grey.shade400,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide.none,
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            ref
                                                .read(contactProviderProvider
                                                    .notifier)
                                                .resetInput();
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Back"),
                                        ),
                                        TextButton(
                                          onPressed: () => updateContact(index),
                                          child: const Text("Edit"),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                              ref
                                      .read(contactProviderProvider.notifier)
                                      .nameController
                                      .text =
                                  ref
                                      .watch(contactProviderProvider)
                                      .contacts[index]
                                      .name!;
                              ref
                                      .read(contactProviderProvider.notifier)
                                      .numberController
                                      .text =
                                  ref
                                      .watch(contactProviderProvider)
                                      .contacts[index]
                                      .number!;
                              ref
                                      .read(contactProviderProvider.notifier)
                                      .emailController
                                      .text =
                                  ref
                                      .watch(contactProviderProvider)
                                      .contacts[index]
                                      .email!;
                            },
                            icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () => deleteContact(index),
                            icon: const Icon(Icons.delete)),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                itemCount: ref.watch(contactProviderProvider).contacts.length),
      ),
    );
  }
}
