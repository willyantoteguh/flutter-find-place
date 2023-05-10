import 'package:flutter/material.dart';
import 'package:flutter_find_places/core/navigation/routes/navigation_helper.dart';
import 'package:get/get.dart';


class MainApp extends StatelessWidget {
  final String initialRoute;
  const MainApp(this.initialRoute);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      initialRoute: initialRoute,
      debugShowCheckedModeBanner: false,
     getPages: Navigation.routes,
    );
  }
}
