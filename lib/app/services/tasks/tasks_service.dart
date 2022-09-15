import 'package:todo_list/app/models/task_model.dart';
import 'package:todo_list/app/models/week_task_model.dart';

abstract class TasksService {
  Future<void> save(String user, DateTime date, String description);
  Future<void> deleteTask(int id);
  Future<List<TaskModel>> getToday(String user);
  Future<List<TaskModel>> getTomorrow(String user);
  Future<WeekTaskModel> getWeek(String user);
  Future<void> checkOrUnckeckTask(TaskModel task);
}
