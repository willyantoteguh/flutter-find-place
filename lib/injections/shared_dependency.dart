import 'package:dio/dio.dart';
import 'package:flutter_find_places/core/network/api/dio_handler.dart';

import 'injections.dart';

class SharedDependency {
  Future<void> registerCore() async {
    //// Dio
    sl.registerLazySingleton<Dio>(() => sl<DioHandler>().dio);
      sl.registerLazySingleton<DioHandler>(() => DioHandler(
        ));
  
  }
}
