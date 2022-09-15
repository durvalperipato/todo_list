import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/core/auth/auth_provider.dart';
import 'package:todo_list/core/ui/theme_extensions.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Selector<AuthProvider, String>(
        selector: (_, authProvider) =>
            authProvider.user?.displayName ?? 'Sem nome',
        builder: (_, value, __) => Text(
          'E ai, $value!',
          style: context.textTheme.headline5
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
