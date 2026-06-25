import 'package:flutter/material.dart';
import 'package:tao996/defapp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final myGlobal = MyGlobal();
  await myGlobal.init(['tao996_demo']);
}
