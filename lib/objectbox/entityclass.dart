import 'package:objectbox/objectbox.dart';

@Entity()
class Contact {
  @Id()
  int id = 0;

  String? name;
  String? number;
  String? email;
  String? image;

  Contact({
    this.id = 0,
    required this.name,
    required this.number,
    this.image,
    this.email,
  });
}
