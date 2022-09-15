import 'package:todo_list/app/models/task_model.dart';
import 'package:todo_list/app/models/week_task_model.dart';
import 'package:todo_list/app/repositories/tasks/task_repository.dart';
import 'package:todo_list/app/services/tasks/tasks_service.dart';

class TasksServiceImpl implements TasksService {
  final TaskRepository _taskRepository;

  TasksServiceImpl({required TaskRepository taskRepository})
      : _taskRepository = taskRepository;

  @override
  Future<void> save(String user, DateTime date, String description) async =>
      _taskRepository.save(user, date, description);

  @override
  Future<List<TaskModel>> getToday(String user) {
    return _taskRepository.findByPeriod(user, DateTime.now(), DateTime.now());
  }

  @override
  Future<List<TaskModel>> getTomorrow(String user) {
    var tomorrow = DateTime.now().add(const Duration(days: 1));
    return _taskRepository.findByPeriod(user, tomorrow, tomorrow);
  }

  @override
  Future<WeekTaskModel> getWeek(String user) async {
    final today = DateTime.now();
    var startFilter = DateTime(today.year, today.month, today.day, 0, 0, 0);
    DateTime endFilter;

    if (startFilter.weekday != DateTime.monday) {
      startFilter =
          startFilter.subtract(Duration(days: startFilter.weekday - 1));
    }

    endFilter = startFilter.add(const Duration(days: 7));
    final tasks =
        await _taskRepository.findByPeriod(user, startFilter, endFilter);
    return WeekTaskModel(
        startDate: startFilter, endDate: endFilter, tasks: tasks);
  }

  @override
  Future<void> checkOrUnckeckTask(TaskModel task) async {
    _taskRepository.checkOrUnckeckTask(task);
  }

  @override
  Future<void> deleteTask(int id) async {
    _taskRepository.deleteTask(id);
  }
}
