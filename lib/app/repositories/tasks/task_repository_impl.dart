import 'package:todo_list/app/models/task_model.dart';
import 'package:todo_list/app/repositories/tasks/task_repository.dart';
import 'package:todo_list/core/database/sqlite_connection_factory.dart';

class TaskRepositoryImpl implements TaskRepository {
  final SqliteConnectionFactory _sqliteConnectionFactory;

  TaskRepositoryImpl({required SqliteConnectionFactory sqliteConnectionFactory})
      : _sqliteConnectionFactory = sqliteConnectionFactory;

  @override
  Future<void> save(String user, DateTime date, String description) async {
    final conn = await _sqliteConnectionFactory.openConnection();
    await conn.insert('todo', {
      'id': null,
      'user': user,
      'descricao': description,
      'data_hora': date.toIso8601String(),
      'finalizado': 0,
    });
  }

  @override
  Future<List<TaskModel>> findByPeriod(
      String user, DateTime start, DateTime end) async {
    final startFilter = DateTime(start.year, start.month, start.day, 0, 0, 0);
    final endtFilter = DateTime(end.year, end.month, end.day, 23, 59, 59);

    final conn = await _sqliteConnectionFactory.openConnection();
    final result = await conn.rawQuery(
      ''' select *
            from todo 
            where user = ?
            and
            data_hora between ? and ?
            order by data_hora
            
        ''',
      [
        user,
        startFilter.toIso8601String(),
        endtFilter.toIso8601String(),
      ],
    );

    return result.map((todo) => TaskModel.loadFromDB(todo)).toList();
  }

  @override
  Future<void> checkOrUnckeckTask(TaskModel task) async {
    final conn = await _sqliteConnectionFactory.openConnection();
    final finished = task.finished ? 1 : 0;
    await conn.rawUpdate(
        'update todo set finalizado = ? where id = ?', [finished, task.id]);
  }

  @override
  Future<void> deleteTask(int id) async {
    final conn = await _sqliteConnectionFactory.openConnection();
    await conn.rawQuery('delete from todo where id = ?', [id]);
  }
}
