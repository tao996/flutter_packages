import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:tao996/tao996.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          title: i18n('appTitle', 'tao996 Demo'),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
