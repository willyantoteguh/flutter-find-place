import 'package:flutter/material.dart';

import '../app/main_app.dart';
import '../core/navigation/routes/routes.dart';
import '../injections/injections.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initialRoute = await Routes.initialRoute;
  await Injections().initialize();
  runApp(MainApp(initialRoute));
}
