import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/models/task_model.dart';
import 'package:todo_list/app/modules/home/home_controller.dart';

class Task extends StatefulWidget {
  final TaskModel model;

  const Task({Key? key, required this.model}) : super(key: key);

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  final dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Selector<HomeController, bool>(
      selector: (_, controller) =>
          controller.filteredTasks.contains(widget.model),
      builder: (_, value, __) => Visibility(
        visible: value,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: Colors.grey),
            ],
          ),
          child: IntrinsicHeight(
            child: Dismissible(
              direction: DismissDirection.startToEnd,
              key: ObjectKey(widget.model),
              confirmDismiss: (direction) async {
                await context
                    .read<HomeController>()
                    .confirmDeleteTask(context, widget.model.id);
                return false;
              },
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.delete_forever,
                      size: 30,
                    ),
                  ),
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(8),
                leading: Checkbox(
                    value: widget.model.finished,
                    onChanged: (value) => context
                        .read<HomeController>()
                        .checkOrUncheckTask(task: widget.model)),
                title: Text(
                  widget.model.description,
                  style: TextStyle(
                    decoration: widget.model.finished
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                subtitle: Text(
                  dateFormat.format(widget.model.dateTime),
                  style: TextStyle(
                    decoration: widget.model.finished
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(width: 1),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
