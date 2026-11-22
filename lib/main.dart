import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router.dart';
import 'core/store.dart';
import 'core/theme.dart';

void main() => runApp(const ProviderScope(child: DarImmoApp()));

class DarImmoApp extends StatelessWidget {
  const DarImmoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppStore.instance,
      builder: (context, _) {
        return MaterialApp.router(
          title: 'DarImmo',
          theme: buildTheme(),
          darkTheme: buildTheme(),
          themeMode:
              AppStore.instance.dark ? ThemeMode.dark : ThemeMode.light,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
} 