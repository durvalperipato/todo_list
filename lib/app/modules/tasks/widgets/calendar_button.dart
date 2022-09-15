import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/app/modules/tasks/tasks_create_controller.dart';
import 'package:todo_list/core/ui/theme_extensions.dart';
import 'package:provider/provider.dart';

class CalendarButton extends StatelessWidget {
  final dateFormat = DateFormat('dd/MM/y');

  CalendarButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var lastDate = DateTime.now();
        lastDate = lastDate.add(const Duration(days: 10 * 365));
        final DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: lastDate,
        );
        // ignore: use_build_context_synchronously
        context.read<TasksCreateController>().selectedDate = selectedDate;
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.today,
              color: Colors.grey,
            ),
            const SizedBox(
              width: 10,
            ),
            Selector<TasksCreateController, DateTime?>(
                selector: (_, controller) => controller.selectedDate,
                builder: (_, selectedDate, __) {
                  if (selectedDate != null) {
                    return Text(
                      dateFormat.format(selectedDate),
                      style: context.titleStyle,
                    );
                  }
                  return Text(
                    'SELECIONE UMA DATA',
                    style: context.titleStyle,
                  );
                }),
          ],
        ),
      ),
    );
  }
}
