import 'package:dio/dio.dart';

class DioCore {

  Dio oauth;
  Dio resource;

  static final DioCore _singleton = DioCore._internal();

  factory DioCore() {
    return _singleton;
  }

  DioCore._internal() {
    final BaseOptions options = BaseOptions(
      baseUrl: 'https://www.pomangam.com:9530/api/v1',
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );

    oauth = Dio(options);
    resource = Dio(options);
  }

  addResourceHeader(Map<String, dynamic> header) {
    resource.interceptors.add(InterceptorsWrapper(
      onRequest:(RequestOptions options) async {
        options.headers.addAll(header);
        return options;
      },
      onResponse:(Response response) async {
        return response;
      },
      onError: (DioError e) async {
        return  e;
      }
    ));
  }

}