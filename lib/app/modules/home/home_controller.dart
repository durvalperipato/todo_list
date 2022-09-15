import 'package:flutter/material.dart';
import 'package:todo_list/app/models/task_filter_enum.dart';
import 'package:todo_list/app/models/task_model.dart';
import 'package:todo_list/app/models/total_tasks_model.dart';
import 'package:todo_list/app/models/week_task_model.dart';
import 'package:todo_list/app/services/tasks/tasks_service.dart';
import 'package:todo_list/core/notifier/default_change_notifier.dart';

class HomeController extends DefaultChangeNotifier {
  var filterSelected = TaskFilterEnum.today;
  final TasksService _tasksService;
  TotalTasksModel? todayTotalTasks;
  TotalTasksModel? tomorrowTotalTasks;
  TotalTasksModel? weekTotalTasks;
  List<TaskModel> allTasks = [];
  List<TaskModel> filteredTasks = [];
  DateTime? initialDateOfWeek;
  DateTime? selectedDay;
  bool showFinishingTasks = false;
  late String user;

  HomeController({required TasksService tasksService})
      : _tasksService = tasksService;

  Future<void> loadTotalTasks() async {
    try {
      final allTasks = await Future.wait([
        _tasksService.getToday(user),
        _tasksService.getTomorrow(user),
        _tasksService.getWeek(user),
      ]);

      final todayTasks = allTasks[0] as List<TaskModel>;
      final tomorrowTasks = allTasks[1] as List<TaskModel>;
      final weekTasks = allTasks[2] as WeekTaskModel;
      todayTotalTasks = TotalTasksModel(
          totalTasks: todayTasks.length,
          totalTasksFinish: todayTasks.where((task) => task.finished).length);
      tomorrowTotalTasks = TotalTasksModel(
          totalTasks: tomorrowTasks.length,
          totalTasksFinish:
              tomorrowTasks.where((task) => task.finished).length);
      weekTotalTasks = TotalTasksModel(
          totalTasks: weekTasks.tasks.length,
          totalTasksFinish:
              weekTasks.tasks.where((task) => task.finished).length);
    } finally {
      notifyListeners();
    }
  }

  Future<void> findTasks({required TaskFilterEnum filter}) async {
    filterSelected = filter;
    showLoading();
    notifyListeners();
    List<TaskModel> tasks;
    switch (filter) {
      case TaskFilterEnum.today:
        tasks = await _tasksService.getToday(user);
        break;
      case TaskFilterEnum.tomorrow:
        tasks = await _tasksService.getTomorrow(user);
        break;
      case TaskFilterEnum.week:
        final weekModel = await _tasksService.getWeek(user);
        initialDateOfWeek = weekModel.startDate;
        tasks = weekModel.tasks;
        break;
    }
    filteredTasks = tasks;
    allTasks = tasks;
    if (filter == TaskFilterEnum.week) {
      if (selectedDay != null) {
        filterByDay(date: selectedDay!);
      } else if (initialDateOfWeek != null) {
        filterByDay(date: initialDateOfWeek!);
      }
    } else {
      selectedDay = null;
    }

    if (!showFinishingTasks) {
      filteredTasks = filteredTasks.where((task) => !task.finished).toList();
    }

    hideLoading();
    notifyListeners();
  }

  Future<void> refreshPage() async {
    await findTasks(filter: filterSelected);
    await loadTotalTasks();
    notifyListeners();
  }

  void filterByDay({required DateTime date}) {
    selectedDay = date;
    filteredTasks = allTasks.where((task) => task.dateTime == date).toList();
    notifyListeners();
  }

  Future<void> checkOrUncheckTask({required TaskModel task}) async {
    showLoadingAndResetState();
    notifyListeners();
    final taskUpdate = task.copyWith(finished: !task.finished);
    await _tasksService.checkOrUnckeckTask(taskUpdate);
    hideLoading();
    refreshPage();
  }

  void showOrHideFinishingTasks() {
    showFinishingTasks = !showFinishingTasks;
    refreshPage();
  }

  void setUser(String userEmail) {
    user = userEmail;
  }

  Future<bool> confirmDeleteTask(BuildContext context, int id) async {
    final task = filteredTasks.firstWhere((element) => element.id == id);
    filteredTasks.remove(task);
    bool delete = true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Task foi excluída'),
        backgroundColor: Colors.red[200],
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.black,
          onPressed: () {
            delete = false;
          },
        ),
      ),
    );
    notifyListeners();
    await Future.delayed(const Duration(seconds: 3), () async {
      if (delete) {
        await _tasksService.deleteTask(id);
      } else {
        filteredTasks.add(task);
      }
    });
    refreshPage();
    return delete;
  }
}
