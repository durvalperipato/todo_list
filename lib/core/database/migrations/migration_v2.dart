import 'package:sqflite/sqflite.dart';

import 'migration.dart';

class MigrationV2 implements Migration {
  @override
  void create(Batch batch) {
    batch.execute('''ALTER TABLE todo
                     ADD user varchar(500) 
                  ''');
  }

  @override
  void update(Batch batch) {
    batch.execute('''ALTER TABLE todo
                     ADD user varchar(500) 
                  ''');
  }
}
