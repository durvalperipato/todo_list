// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:todo_list/app/models/task_filter_enum.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';
import 'package:todo_list/app/modules/home/widgets/home_drawer.dart';
import 'package:todo_list/app/modules/home/widgets/home_filters.dart';
import 'package:todo_list/app/modules/home/widgets/home_header.dart';
import 'package:todo_list/app/modules/home/widgets/home_tasks.dart';
import 'package:todo_list/app/modules/home/widgets/home_week_filter.dart';
import 'package:todo_list/app/modules/tasks/tasks_module.dart';
import 'package:todo_list/core/notifier/default_listener_notifier.dart';
import 'package:todo_list/core/ui/theme_extensions.dart';

class HomePage extends StatefulWidget {
  final HomeController _homeController;
  const HomePage({
    Key? key,
    required HomeController homeController,
  })  : _homeController = homeController,
        super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(changeNotifier: widget._homeController).listener(
        context: context,
        successCallBack: (notifier, listenerInstance) {
          listenerInstance.dispose();
        });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget._homeController.loadTotalTasks();
      widget._homeController.findTasks(filter: TaskFilterEnum.today);
    });
  }

  Future<void> _goToCreateTask(BuildContext context) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          animation =
              CurvedAnimation(parent: animation, curve: Curves.easeInQuad);
          return ScaleTransition(
            scale: animation,
            alignment: Alignment.bottomRight,
            child: child,
          );
        },
        pageBuilder: ((context, animation, secondaryAnimation) {
          return TasksModule().getPage('/task/create', context);
        }),
      ),
    );
    await widget._homeController.refreshPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.primaryColor),
        backgroundColor: const Color(0XFFFAFBFE),
        elevation: 0,
        actions: [
          PopupMenuButton(
            onSelected: (value) =>
                widget._homeController.showOrHideFinishingTasks(),
            icon: const Icon(Icons.filter_alt),
            itemBuilder: (_) => [
              PopupMenuItem<bool>(
                value: true,
                child: Text(
                    '${widget._homeController.showFinishingTasks ? 'Ocultar' : 'Mostrar'} tarefas concluídas'),
              ),
            ],
          )
        ],
      ),
      backgroundColor: const Color(0XFFFAFBFE),
      drawer: HomeDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      HomeHeader(),
                      HomeFilters(),
                      HomeWeekFilter(),
                      HomeTasks(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToCreateTask(context),
        backgroundColor: context.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
