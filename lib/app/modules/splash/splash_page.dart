import 'package:flutter/material.dart';
import 'package:todo_list/core/widgets/todo_list_logo.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Splash Page'),
      ),
      body: const Center(
        child: TodoListLogo(),
      ),
    );
  }
}
