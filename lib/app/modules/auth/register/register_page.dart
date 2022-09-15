import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/core/notifier/default_listener_notifier.dart';
import 'package:todo_list/core/ui/theme_extensions.dart';
import 'package:todo_list/core/validator/validators.dart';
import 'package:todo_list/core/widgets/todo_list_field.dart';
import 'package:todo_list/core/widgets/todo_list_logo.dart';
import 'package:validatorless/validatorless.dart';

import 'register_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _confirmPasswordEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    var defaultListerner = DefaultListenerNotifier(
        changeNotifier: context.read<RegisterController>());
    defaultListerner.listener(
        context: context,
        successCallBack: (notifier, listenerInstance) {
          listenerInstance.dispose();
        });
  }

  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    _confirmPasswordEC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: ClipOval(
            child: Container(
              color: context.primaryColor.withAlpha(20),
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back_ios_new_outlined,
                size: 20,
                color: context.primaryColor,
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ToDo List',
              style: TextStyle(
                fontSize: 10,
                color: context.primaryColor,
              ),
            ),
            Text(
              'Cadastro',
              style: TextStyle(
                fontSize: 12,
                color: context.primaryColor,
              ),
            )
          ],
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width * .5,
            child: const FittedBox(
              fit: BoxFit.fitHeight,
              child: TodoListLogo(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TodoListField(
                    label: 'E-mail',
                    controller: _emailEC,
                    validator: Validatorless.multiple(
                      [
                        Validatorless.required('E-mail obrigatório'),
                        Validatorless.email('E-mail inválido'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TodoListField(
                    label: 'Senha',
                    controller: _passwordEC,
                    obscureText: true,
                    validator: Validatorless.multiple(
                      [
                        Validatorless.required('Senha obrigatória'),
                        Validatorless.min(
                            6, 'Senha deve ter pelo menos 6 caracteres'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TodoListField(
                    label: 'Confirmar senha',
                    controller: _confirmPasswordEC,
                    obscureText: true,
                    validator: Validatorless.multiple(
                      [
                        Validatorless.required('Confirma senha obrigatória'),
                        Validators.compare(
                            _passwordEC, 'Senha diferente de confirma senha')
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        final formValid =
                            _formKey.currentState?.validate() ?? false;
                        if (formValid) {
                          context.read<RegisterController>().registerUser(
                              email: _emailEC.text, password: _passwordEC.text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('Salvar'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
