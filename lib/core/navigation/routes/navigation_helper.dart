import 'package:flutter_find_places/core/navigation/bindings/controller/home.controller.binding.dart';
import 'package:flutter_find_places/features/home/presentation/screen/home_screen.dart';
import 'package:get/get.dart';

import 'routes.dart';

class Navigation {
  static List<GetPage> routes = [
    GetPage(name: Routes.HOME, page: () => const HomeScreen(), binding: HomeControllerBinding())
  ];
}
