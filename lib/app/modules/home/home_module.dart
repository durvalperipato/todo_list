import 'package:provider/provider.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';
import 'package:todo_list/app/modules/home/home_page.dart';
import 'package:todo_list/app/repositories/tasks/task_repository.dart';
import 'package:todo_list/app/repositories/tasks/task_repository_impl.dart';
import 'package:todo_list/app/services/tasks/tasks_service.dart';
import 'package:todo_list/app/services/tasks/tasks_service_impl.dart';
import 'package:todo_list/core/auth/auth_provider.dart';
import 'package:todo_list/core/modules/todo_list_module.dart';

class HomeModule extends TodoListModule {
  HomeModule()
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
                    HomeController(tasksService: context.read())),
          ],
          routers: {
            '/home': (context) => HomePage(
                  homeController: context.read()
                    ..setUser(context.read<AuthProvider>().userEmail!),
                ),
          },
        );
}
