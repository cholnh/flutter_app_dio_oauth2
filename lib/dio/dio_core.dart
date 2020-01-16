import 'package:dio/dio.dart';

Dio dio = Dio(BaseOptions(
  baseUrl: 'https://www.pomangam.com:9530/api/v1',
  connectTimeout: 5000,
  receiveTimeout: 3000,
));