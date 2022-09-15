import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/models/task_filter_enum.dart';
import 'package:todo_list/app/models/total_tasks_model.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';
import 'package:todo_list/app/modules/home/widgets/todo_card_filter.dart';
import 'package:todo_list/core/ui/theme_extensions.dart';

class HomeFilters extends StatelessWidget {
  const HomeFilters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FILTROS',
          style: context.titleStyle,
        ),
        const SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              TodoCardFilter(
                label: 'HOJE',
                taskFilterlabel: TaskFilterEnum.today,
                selected: context.select<HomeController, TaskFilterEnum>(
                        (value) => value.filterSelected) ==
                    TaskFilterEnum.today,
                totalTasksModel:
                    context.select<HomeController, TotalTasksModel?>(
                  (controller) => controller.todayTotalTasks,
                ),
              ),
              TodoCardFilter(
                label: 'AMANHÃ',
                taskFilterlabel: TaskFilterEnum.tomorrow,
                selected: context.select<HomeController, TaskFilterEnum>(
                        (value) => value.filterSelected) ==
                    TaskFilterEnum.tomorrow,
                totalTasksModel:
                    context.select<HomeController, TotalTasksModel?>(
                  (controller) => controller.tomorrowTotalTasks,
                ),
              ),
              TodoCardFilter(
                label: 'SEMANA',
                taskFilterlabel: TaskFilterEnum.week,
                selected: context.select<HomeController, TaskFilterEnum>(
                        (value) => value.filterSelected) ==
                    TaskFilterEnum.week,
                totalTasksModel:
                    context.select<HomeController, TotalTasksModel?>(
                  (controller) => controller.weekTotalTasks,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
