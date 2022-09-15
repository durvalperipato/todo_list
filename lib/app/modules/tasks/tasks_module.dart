import 'package:provider/provider.dart';
import 'package:todo_list/app/modules/tasks/tasks_create_controller.dart';
import 'package:todo_list/app/modules/tasks/tasks_create_page.dart';
import 'package:todo_list/app/repositories/tasks/task_repository.dart';
import 'package:todo_list/app/repositories/tasks/task_repository_impl.dart';
import 'package:todo_list/app/services/tasks/tasks_service.dart';
import 'package:todo_list/app/services/tasks/tasks_service_impl.dart';
import 'package:todo_list/core/modules/todo_list_module.dart';

class TasksModule extends TodoListModule {
  TasksModule()
      : super(
          bindings: [
            Provider<TaskRepository>(
              create: (context) => TaskRepositoryImpl(
                sqliteConnectionFactory: context.read(),
              ),
            ),
            Provider<TasksService>(
                create: (context) =>
                    TasksServiceImpl(taskRepository: context.read())),
            ChangeNotifierProvider(
              create: (context) =>
                  TasksCreateController(tasksService: context.read()),
            )
          ],
          routers: {
            '/task/create': (context) => TasksCreatePage(
                  controller: context.read(),
                ),
          },
        );
}
