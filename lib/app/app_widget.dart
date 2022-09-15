import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo_list/app/modules/auth/auth_module.dart';
import 'package:todo_list/app/modules/home/home_module.dart';
import 'package:todo_list/app/modules/splash/splash_page.dart';
import 'package:todo_list/app/modules/tasks/tasks_module.dart';
import 'package:todo_list/core/database/sqlite_adm_connection.dart';
import 'package:todo_list/core/navigator/todo_list_navigator.dart';

import '../core/ui/todo_list_ui_config.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  var sqliteAdmConnection = SqliteAdmConnection();

  @override
  void initState() {
    super.initState();
    //FirebaseAuth auth = FirebaseAuth.instance;
    WidgetsBinding.instance.addObserver(sqliteAdmConnection);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(sqliteAdmConnection);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      debugShowCheckedModeBanner: false,
      navigatorKey: TodoListNavigator.navigatorKey,
      title: 'Todo List Provider',
      theme: TodoListUiConfig.theme,
      routes: {
        ...AuthModule().routers,
        ...HomeModule().routers,
        ...TasksModule().routers,
      },
      home: const SplashPage(),
    );
  }
}
