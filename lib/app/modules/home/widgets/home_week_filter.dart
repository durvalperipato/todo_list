import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/models/task_filter_enum.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';
import 'package:todo_list/core/ui/theme_extensions.dart';

class HomeWeekFilter extends StatelessWidget {
  const HomeWeekFilter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: context.select<HomeController, bool>(
          (controller) => controller.filterSelected == TaskFilterEnum.week),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'DIA DA SEMANA',
            style: context.titleStyle,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 95,
            child: Selector<HomeController, DateTime>(
              selector: (_, controller) =>
                  controller.initialDateOfWeek ?? DateTime.now(),
              builder: (_, initialDateOfWeek, __) => DatePicker(
                initialDateOfWeek,
                locale: 'pt_BR',
                initialSelectedDate: initialDateOfWeek,
                selectionColor: context.primaryColor,
                selectedTextColor: Colors.white,
                daysCount: 7,
                monthTextStyle: const TextStyle(fontSize: 8),
                dateTextStyle: const TextStyle(fontSize: 13),
                dayTextStyle: const TextStyle(fontSize: 13),
                onDateChange: (date) {
                  context.read<HomeController>().filterByDay(date: date);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
