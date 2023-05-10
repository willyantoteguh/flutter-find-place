import 'package:flutter/material.dart';
import 'package:flutter_find_places/features/home/presentation/controller/home_controller.dart';
import 'package:get/get.dart';

class ShowBookmarkedPlace extends StatefulWidget {
  const ShowBookmarkedPlace({Key? key}) : super(key: key);

  @override
  State<ShowBookmarkedPlace> createState() => _ShowBookmarkedPlaceState();
}

class _ShowBookmarkedPlaceState extends State<ShowBookmarkedPlace> {
  final controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    controller.getAllPlace();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [],
      ),
    );
  }
}
