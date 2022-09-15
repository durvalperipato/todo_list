import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/modules/tasks/tasks_create_controller.dart';
import 'package:todo_list/app/modules/tasks/widgets/calendar_button.dart';
import 'package:todo_list/core/auth/auth_provider.dart';
import 'package:todo_list/core/notifier/default_listener_notifier.dart';
import 'package:todo_list/core/ui/theme_extensions.dart';
import 'package:todo_list/core/widgets/todo_list_field.dart';
import 'package:validatorless/validatorless.dart';

class TasksCreatePage extends StatefulWidget {
  final TasksCreateController _controller;

  const TasksCreatePage({Key? key, required TasksCreateController controller})
      : _controller = controller,
        super(key: key);

  @override
  State<TasksCreatePage> createState() => _TasksCreatePageState();
}

class _TasksCreatePageState extends State<TasksCreatePage> {
  final _formKey = GlobalKey<FormState>();

  final _descriptionEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(changeNotifier: widget._controller).listener(
        context: context,
        successCallBack: (notifier, listenerInstance) {
          listenerInstance.dispose();
          Navigator.of(context).pop();
        });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Criar Atividade',
                  style: context.titleStyle.copyWith(fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TodoListField(
                label: '',
                controller: _descriptionEC,
                validator: Validatorless.required('Descrição obrigatória'),
              ),
              const SizedBox(
                height: 20,
              ),
              CalendarButton(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: context.primaryColor,
        onPressed: () {
          final formValid = _formKey.currentState?.validate() ?? false;
          if (formValid) {
            // TODO FAZER ESTA PARTE DE SALVAR COM NA COLUMA USUÀRIO
            widget._controller.save(
                context.read<AuthProvider>().userEmail!, _descriptionEC.text);
          }
        },
        label: const Text(
          'Salvar Task',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
