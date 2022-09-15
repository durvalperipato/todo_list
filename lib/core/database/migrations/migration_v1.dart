import 'package:sqflite/sqflite.dart';

import 'migration.dart';

class MigrationV1 implements Migration {
  @override
  void create(Batch batch) {
    batch.execute('''
    CREATE TABLE todo(
        id integer primary key autoincrement,
        descricao varchar(500) not null,
        data_hora datetime,
        finalizado integer
    )
''');
  }

  @override
  void update(Batch batch) {}
}
