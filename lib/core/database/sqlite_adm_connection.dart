import 'package:flutter/material.dart';
import 'package:todo_list/core/database/sqlite_connection_factory.dart';

class SqliteAdmConnection with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final connection = SqliteConnectionFactory();

    switch (state) {
      case AppLifecycleState.resumed:
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        connection.closeConnection();
        break;

      default:
    }

    super.didChangeAppLifecycleState(state);
  }
}
