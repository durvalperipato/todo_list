import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/models/task_model.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';
import 'package:todo_list/core/ui/theme_extensions.dart';

import 'task.dart';

class HomeTasks extends StatelessWidget {
  const HomeTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Selector<HomeController, String>(
            selector: (_, controller) => controller.filterSelected.value,
            builder: (_, value, __) =>
                Text('TASK\'S $value', style: context.titleStyle),
          ),
          Column(
            children: context
                .select<HomeController, List<TaskModel>>(
                    (controller) => controller.filteredTasks)
                .map((t) => Task(
                      model: t,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
