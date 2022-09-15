import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:todo_list/core/notifier/default_change_notifier.dart';
import 'package:todo_list/core/ui/messages.dart';

class DefaultListenerNotifier {
  final DefaultChangeNotifier changeNotifier;

  DefaultListenerNotifier({required this.changeNotifier});

  void listener(
      {required BuildContext context,
      required SuccessVoidCallBack successCallBack,
      ErrorCallBack? errorCallBack,
      EverVoidCallBack? everVoidCallBack}) {
    changeNotifier.addListener(() {
      if (everVoidCallBack != null) {
        everVoidCallBack(changeNotifier, this);
      }
      if (changeNotifier.loading) {
        Loader.show(context);
      } else {
        Loader.hide();
      }

      if (changeNotifier.hasError) {
        if (errorCallBack != null) {
          errorCallBack(changeNotifier, this);
        }
        Messages.of(context).showError(changeNotifier.error ?? 'Erro interno');
      } else if (changeNotifier.isSuccess) {
        successCallBack(changeNotifier, this);
      }
    });
  }

  void dispose() {
    changeNotifier.removeListener(() {});
  }
}

typedef SuccessVoidCallBack = void Function(
    DefaultChangeNotifier notifier, DefaultListenerNotifier listenerInstance);

typedef ErrorCallBack = void Function(
    DefaultChangeNotifier notifier, DefaultListenerNotifier listenerInstance);

typedef EverVoidCallBack = void Function(
    DefaultChangeNotifier notifier, DefaultListenerNotifier listenerInstance);
