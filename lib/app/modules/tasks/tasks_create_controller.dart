import 'package:todo_list/app/services/tasks/tasks_service.dart';
import 'package:todo_list/core/notifier/default_change_notifier.dart';

class TasksCreateController extends DefaultChangeNotifier {
  final TasksService _tasksService;
  DateTime? _selectedDate;

  TasksCreateController({required TasksService tasksService})
      : _tasksService = tasksService;

  set selectedDate(DateTime? selectedDate) {
    resetState();
    _selectedDate = selectedDate;
    notifyListeners();
  }

  DateTime? get selectedDate => _selectedDate;

  Future<void> save(String user, String description) async {
    try {
      showLoadingAndResetState();
      notifyListeners();
      if (_selectedDate != null) {
        await _tasksService.save(user, _selectedDate!, description);
        success();
      } else {
        setError('Data da task não selecionada');
      }
    } catch (e) {
      setError('Erro ao cadastrar task');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
