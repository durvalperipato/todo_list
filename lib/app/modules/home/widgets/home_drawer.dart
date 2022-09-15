import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/services/user/user_service.dart';
import 'package:todo_list/core/auth/auth_provider.dart';
import 'package:todo_list/core/ui/messages.dart';
import 'package:todo_list/core/ui/theme_extensions.dart';

class HomeDrawer extends StatelessWidget {
  final nameVN = ValueNotifier<String>('');

  HomeDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration:
                BoxDecoration(color: context.primaryColor.withAlpha(70)),
            child: Row(
              children: [
                Selector<AuthProvider, String>(
                  selector: (context, authProvider) =>
                      authProvider.user?.photoURL ??
                      'https://tm.ibxk.com.br/2021/12/13/13093901049065.jpg?ims=704x264',
                  builder: (_, value, __) {
                    return CircleAvatar(
                      backgroundImage: NetworkImage(value),
                      radius: 30,
                    );
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Selector<AuthProvider, String>(
                      selector: (context, authProvider) =>
                          authProvider.user?.displayName ?? 'Sem Nome',
                      builder: (_, name, __) => Text(
                        name,
                        style: context.textTheme.subtitle2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Alterar nome'),
                content: TextField(
                  onChanged: (value) => nameVN.value = value,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (nameVN.value.isEmpty) {
                        Messages.of(context).showError('Nome obrigatório');
                      } else {
                        Loader.show(context);
                        await context
                            .read<UserService>()
                            .updateDisplayName(nameVN.value);
                        Loader.hide();
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Alterar'),
                  ),
                ],
              ),
            ),
            title: const Text('Alterar nome'),
          ),
          ListTile(
              title: const Text('Sair'),
              onTap: () {
                context.read<AuthProvider>().logout();
              }),
        ],
      ),
    );
  }
}
