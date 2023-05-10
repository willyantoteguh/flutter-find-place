
import 'package:dio/dio.dart';

import 'api_interceptors.dart';

class DioHandler {


  Dio get dio => _getDio();

  Dio _getDio() {
    BaseOptions options = BaseOptions(
      connectTimeout: 50000,
      receiveTimeout: 30000,
    );
    
    final dio = Dio(options);
    dio.interceptors.add(ApiInterceptors());

    return dio;
  }


}
