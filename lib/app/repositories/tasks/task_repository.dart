import 'package:todo_list/app/models/task_model.dart';

abstract class TaskRepository {
  Future<void> save(String user, DateTime date, String description);
  Future<void> deleteTask(int id);
  Future<List<TaskModel>> findByPeriod(
      String user, DateTime start, DateTime end);
  Future<void> checkOrUnckeckTask(TaskModel task);
}
