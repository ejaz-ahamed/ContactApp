import 'package:contact_app/objectbox.g.dart';
import 'package:contact_app/objectbox/entityclass.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ObjectBox {
  static ObjectBox? _instance;
  final Store store;
  late final Box<Contact> contactBox;

  ObjectBox._create(this.store) {
    contactBox = store.box<Contact>();
  }

  static ObjectBox get instance {
    return _instance!;
  }

  static Future<void> create() async {
    if (_instance == null) {
      final docsDir = await getApplicationDocumentsDirectory();
      final store =
          await openStore(directory: p.join(docsDir.path, "obx-example"));
      _instance = ObjectBox._create(store);
    }
  }
}
